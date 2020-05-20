//
//  FirstViewController.swift
//  LotteryTicketTool
//
//  Created by 成殿 on 12/11/2018.
//  Copyright © 2018 chengluffy. All rights reserved.
//

import UIKit
import WCDBSwift
import Alamofire
import Moya

class FirstViewController: UIViewController {
    
    /// 0: 大乐透 1: 双色球
    @IBInspectable open var type: Int = 0

    @IBOutlet weak var tableView: UITableView!
    var dataSource = [Ticket]()
    var netDataSource = [Ticket]()
    var expectNext: Int?
    lazy var database: Database = {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let database = Database(withPath: "\(docPath)/tikets.db")
        return database
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.tableFooterView = UIView()
        getData()
    }

    @IBAction func generateAction(_ sender: Any) {
        
        let alertC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertC.addAction(UIAlertAction.init(title: "输入", style: .default, handler: { (_) in
            self.enterCode()
        }))
        alertC.addAction(UIAlertAction.init(title: "随机生成", style: .default, handler: { (_) in
            guard let expect = self.expectNext else { return }
            let ticket = GenerateTicketTool.generateTicket(with: self.type == 0 ? .sportsLottery : .welfareLottery, expect: expect)
            do {
                try self.database.insert(objects: ticket, intoTable: "ticket")
            } catch let error {
                debugPrint(error)
            }
            self.reloadData()
        }))
        alertC.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (_) in
        }))
        let presentC = alertC.popoverPresentationController
        if (presentC != nil) {
            let view: UIView = (sender as! UIBarButtonItem).value(forKey: "view") as! UIView
            presentC?.sourceView = view
            presentC?.sourceRect = view.bounds
            presentC?.permittedArrowDirections = .any
        }
        
        present(alertC, animated: true, completion: {
        })
    }
    
    func enterCode() {
        let alertC = UIAlertController(title: "手动输入", message: "用点分割", preferredStyle: .alert)
        alertC.addTextField { (textField) in
            textField.keyboardType = .decimalPad
        }
        alertC.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (_) in
            self.saveCode(codeStr: alertC.textFields?.first?.text ?? "")
        }))
        alertC.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (_) in
        }))
        present(alertC, animated: true) {
        }
    }
    
    func saveCode(codeStr: String) {
        guard let expect = expectNext else { return }
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:SS"
        let opentime = df.string(from: date)
        let opentimestamp = date.timeIntervalSince1970
        let arr = codeStr.components(separatedBy: ".")
        if arr.count == 7 {
            if type == 0 {
                let arr1 = arr.prefix(upTo: 5)
                let arr2 = arr.suffix(from: 5)
                let openCode = arr1.joined(separator: ",") + "+" + arr2.joined(separator: ",")
                let ticket = Ticket(expect: "\(expect)", opencode: openCode, opentime: opentime, opentimestamp: Int64(opentimestamp), cate: self.type == 0 ? 0 : 1, ticketPurchased: false, degree: 0)
                do {
                    try database.insert(objects: ticket, intoTable: "ticket")
                    reloadData()
                } catch {
                    debugPrint(error)
                }
            } else {
                let arr1 = arr.prefix(upTo: 6)
                let arr2 = arr.suffix(from: 6)
                let openCode = arr1.joined(separator: ",") + "+" + arr2.joined(separator: ",")
                let ticket = Ticket(expect: "\(expect)", opencode: openCode, opentime: opentime, opentimestamp: Int64(opentimestamp), cate: self.type == 0 ? 0 : 1, ticketPurchased: false, degree: 0)
                do {
                    try database.insert(objects: ticket, intoTable: "ticket")
                    reloadData()
                } catch {
                    debugPrint(error)
                }
            }
        } else {
            alertMsg(msg: "输入值验证失败")
        }
    }
    
    func alertMsg(msg: String) {
        let alertC = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
        present(alertC, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                alertC.dismiss(animated: true) {
                }
            }
        }
    }
    
    func reloadData() {
        do {
            dataSource = try database.getObjects(on: Ticket.Properties.all, fromTable: "ticket", where: Ticket.Properties.cate == type, orderBy: [Ticket.Properties.opentimestamp.asOrder(by: .descending)])
        } catch let error {
            debugPrint(error)
        }
        
        do {
            netDataSource = try database.getObjects(on: Ticket.Properties.all, fromTable: "ticket", where: Ticket.Properties.cate == type + 2, orderBy: [Ticket.Properties.opentimestamp.asOrder(by: .descending)], offset: 1)
        } catch let error {
            debugPrint(error)
        }
        
        if netDataSource.count > 0 {
            expectNext = Int(netDataSource.first!.expect)! + 1
        }
        let arr = dataSource.filter({ $0.ticketPurchased == true && $0.degree == 0})
        if arr.count > 0 {
            for (index, ticket) in arr.enumerated() {
                do {
                    let arr: [Ticket] = try database.getObjects(on: Ticket.CodingKeys.all, fromTable: "ticket", where: Ticket.Properties.expect == ticket.expect && Ticket.Properties.cate == self.type + 2)
                    guard let opened = arr.first else {
                        self.tableView.reloadData()
                        return
                    }
                    let code = opened.opencode
                    let first = code.components(separatedBy: "+").first?.components(separatedBy: ",").map { (str) -> Int in
                        return Int(str)!
                    }
                    let second = code.components(separatedBy: "+").last?.components(separatedBy: ",").map { (str) -> Int in
                        return Int(str)!
                    }
                    
                    let code1 = ticket.opencode
                    let first1 = code1.components(separatedBy: "+").first?.components(separatedBy: ",").map { (str) -> Int in
                        return Int(str)!
                    }
                    let second1 = code1.components(separatedBy: "+").last?.components(separatedBy: ",").map { (str) -> Int in
                        return Int(str)!
                    }
                    
                    var degree = -1
                    let result1 = intersection(first!, first1!)
                    let result2 = intersection(second!, second1!)
                    if type == 1 {
                        if result1.count == 6 && result2.count == 1 {
                            degree = 1
                        } else if result1.count == 6 && result2.count == 0 {
                            degree = 2
                        } else if result1.count == 5 && result2.count == 1 {
                            degree = 3
                        } else if result1.count == 5 && result2.count == 0 || result1.count == 4 && result2.count == 1 {
                            degree = 4
                        } else if result1.count == 4 && result2.count == 0 || result1.count == 3 && result2.count == 1 {
                            degree = 5
                        } else if result1.count == 0 && result2.count == 1 {
                            degree = 6
                        }
                    } else {
                        if result1.count == 5 && result2.count == 2 {
                            degree = 1
                        } else if result1.count == 5 && result2.count == 1 {
                            degree = 2
                        } else if result1.count == 5 && result2.count == 0 {
                            degree = 3
                        } else if result1.count == 4 && result2.count == 2 {
                            degree = 4
                        } else if result1.count == 4 && result2.count == 1 {
                            degree = 5
                        } else if result1.count == 3 && result2.count == 2 {
                            degree = 6
                        } else if result1.count == 4 && result2.count == 0 {
                            degree = 7
                        } else if result1.count == 3 && result2.count == 1 || result1.count == 2 && result2.count == 2 {
                            degree = 8
                        } else if result1.count == 3 && result2.count == 0 || result1.count == 1 && result2.count == 2 || result1.count == 2 && result2.count == 1 || result1.count == 0 && result2.count == 2 {
                            degree = 9
                        }
                    }
                    var ticket = ticket
                    ticket.degree = degree
                    try database.update(table: "ticket", on: Ticket.Properties.degree, with: ticket, where: Ticket.Properties.opentimestamp == ticket.opentimestamp)
                    dataSource[index] = ticket
                } catch {
                    debugPrint(error)
                }
            }
            tableView.reloadData()
        } else {
            tableView.reloadData()
        }
    }
    
    @IBAction func getData() {
        
        let apiTool = MoyaProvider<ApiTool>()
        apiTool.request(type == 0 ? ApiTool.getDLT : ApiTool.getSSQ) { (result) in
            switch result {
            case let .success(result):
                guard result.response?.statusCode == 200 else {
                    self.reloadData()
                    return
                }
                let resp = try! result.map(Response.self)
                
                var arr = resp.data.map { (ticket) -> Ticket in
                    var ticket = ticket
                    ticket.cate = self.type + 2
                    ticket.degree = 0
                    ticket.ticketPurchased = false
                    return ticket
                }
                
                arr = arr.sorted { (a, b) -> Bool in
                    return a.opentimestamp < b.opentimestamp
                }
                
                do {
                    for ticket in arr {
                        let dataSource: [Ticket] = try self.database.getObjects(on: Ticket.CodingKeys.all, fromTable: "ticket", where: Ticket.Properties.expect == ticket.expect && Ticket.Properties.cate == ticket.cate!)
                        if dataSource.count > 0 {
                        } else {
                            try self.database.insert(objects: arr, intoTable: "ticket")
                        }
                    }
                } catch {
                    debugPrint(error)
                }
                
                self.reloadData()
            case let .failure(error):
                debugPrint(error.errorUserInfo)
            }
        }
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        let alertC = UIAlertController(title: "确定删除未购历史吗?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
            
        }
        let sureAction = UIAlertAction(title: "确定", style: .destructive) { (_) in
            do {
                try self.database.delete(fromTable: "ticket", where: Ticket.Properties.cate == self.type && Ticket.Properties.ticketPurchased == false)
            } catch let error {
                debugPrint(error)
            }
            self.reloadData()
        }
        alertC.addAction(cancelAction)
        alertC.addAction(sureAction)
        present(alertC, animated: true) {
            
        }
    }
}

extension FirstViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return netDataSource.count == 0 ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListCell
        if indexPath.section == 0 {
            cell.ticket = netDataSource.first
        } else {
            let ticket = dataSource[indexPath.row]
            cell.ticket = ticket
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "上期开奖结果" : "购买历史"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            navigationController?.pushViewController(HistoryViewController(type: type), animated: true)
            return
        }
        let ticket = dataSource[indexPath.row]
        let pasteboard = UIPasteboard.general
        pasteboard.string = ticket.opencode
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if indexPath.section == 0 { return nil }
        let ticket = dataSource[indexPath.row]
        let actionProvider: UIContextMenuActionProvider = { _ in
            return UIMenu(title: "", children: [
                UIAction(title: ticket.ticketPurchased! ? "未购" : "已购") { [weak self] _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self?.sighTicketPurchased(at: indexPath)
                    }
                },
                UIAction(title: "删除", attributes: .destructive, handler: { [weak self] (_) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self?.deleteTicket(at: indexPath)
                    }
                })
            ])
        }

        return UIContextMenuConfiguration(identifier: "unique-ID" as NSCopying, previewProvider: nil, actionProvider: actionProvider)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 {
            return nil
        }
        let deleteItem = UIContextualAction(style: .destructive, title: "删除") {  (contextualAction, view, boolValue) in
            self.deleteTicket(at: indexPath)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteItem])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 {
            return nil
        }
        let ticket = dataSource[indexPath.row]
        let purchasedItem = UIContextualAction(style: .normal, title: ticket.ticketPurchased! ? "未购" : "已购") {  (contextualAction, view, boolValue) in
            self.sighTicketPurchased(at: indexPath)
        }
        purchasedItem.backgroundColor = ticket.ticketPurchased! ? UIColor.lightGray : UIColor.systemBlue
        let swipeActions = UISwipeActionsConfiguration(actions: [purchasedItem])
        return swipeActions
    }
    
}

extension FirstViewController {
    func sighTicketPurchased(at indexPath: IndexPath) {
        do {
            var ticket = dataSource[indexPath.row]
            ticket.ticketPurchased = !ticket.ticketPurchased!
            try database.update(table: "ticket", on: Ticket.Properties.ticketPurchased, with: ticket, where: Ticket.Properties.opentimestamp == ticket.opentimestamp)
            dataSource[indexPath.row] = ticket
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } catch let error {
            debugPrint(error)
        }
    }
    
    func deleteTicket(at indexPath: IndexPath) {
        do {
            try database.delete(fromTable: "ticket", where: Ticket.Properties.cate == self.type, orderBy: [Ticket.Properties.opentimestamp.asOrder(by: .descending)], limit: 1, offset: indexPath.row)
            dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch let error {
            debugPrint(error)
        }
    }
    
    func intersection(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
        guard nums1.count > 0 && nums2.count > 0 else {
        return []
        }

        var array = [Int]()

        for item in 0..<nums1.count {
            for jtem in 0..<nums2.count{
                if nums1[item] == nums2[jtem] {
                
                    if !array.contains(nums1[item]){
                        array.append(nums1[item])
                    }
               
                }
            }
        }
        return array
    }
}
