//
//  SecondViewController.swift
//  LotteryTicketTool
//
//  Created by 成殿 on 12/11/2018.
//  Copyright © 2018 chengluffy. All rights reserved.
//

import UIKit
import Alamofire
import WCDBSwift

class SecondViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataSource = [Ticket]()
    var netDataSource = [Ticket]()
    lazy var database: Database = {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let database = Database(withPath: "\(docPath)/tikets.db")
        return database
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.tableFooterView = UIView()
        reloadData()
        getData()
    }

    @IBAction func generateAction(_ sender: Any) {
        let ticket = GenerateTicketTool.generateTicket(with: .welfareLottery)
        print(ticket.describe())
        do {
            try database.insert(objects: ticket, intoTable: "ticket")
        } catch let error {
            debugPrint(error)
        }
        reloadData()
    }
    
    func reloadData() {
        do {
            dataSource = try database.getObjects(on: Ticket.CodingKeys.all, fromTable: "ticket", where: Ticket.Properties.cate == 1, orderBy: [Ticket.Properties.date.asOrder(by: .descending)])
        } catch let error {
            debugPrint(error)
        }
        
        do {
            netDataSource = try database.getObjects(on: Ticket.CodingKeys.all, fromTable: "ticket", where: Ticket.Properties.cate == 3)
        } catch let error {
            debugPrint(error)
        }
        
        tableView.reloadData()
    }
    
    @IBAction func getData() {
        Alamofire.request("http://f.apiplus.net/ssq-1.json").responseJSON { (response) in
            response.result.ifSuccess {
                print(response.result.value ?? "nil")
                guard let result: NSDictionary = response.result.value as? NSDictionary else {
                    return
                }
                
                guard let data: NSArray = result["data"] as? NSArray else {
                    return
                }
                
                guard let obj: NSDictionary = data.firstObject as? NSDictionary else {
                    return
                }
                
                let code = obj["opencode"] as? NSString
                let arr = code?.components(separatedBy: "+")
                let ticket = Ticket()
                
                let str1 = arr?.first
                let arr1 = str1?.components(separatedBy: ",")
                var firstZoon = [Int]()
                for temp in arr1! {
                    firstZoon.append((temp as NSString).integerValue)
                }
                ticket.firstZoon = firstZoon
                
                let str2 = arr?.last
                let arr2 = str2?.components(separatedBy: ",")
                var secondZoon = [Int]()
                for temp in arr2! {
                    secondZoon.append((temp as NSString).integerValue)
                }
                ticket.secondZoon = secondZoon
                
                let dateStr = obj["opentime"] as! String
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd HH:mm:SS"
                let date = df.date(from: dateStr)
                ticket.date = date
                
                ticket.cate = 3
                
                do {
                    try self.database.delete(fromTable: "ticket", where: Ticket.Properties.cate == 3)
                } catch let error {
                    debugPrint(error)
                }
                
                do {
                    try self.database.insert(objects: ticket, intoTable: "ticket")
                } catch let error {
                    debugPrint(error)
                }
                
                self.reloadData()
            }
            
            response.result.ifFailure {
                
            }
        }
    }

}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return netDataSource.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? netDataSource.count : dataSource.count
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
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "上期开奖结果" : "随机生成历史"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return indexPath.section == 0 ? .none : .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try database.delete(fromTable: "ticket", where: Ticket.Properties.cate == 1, orderBy: [Ticket.Properties.date.asOrder(by: .descending)], limit: 1, offset: indexPath.row)
            } catch let error {
                debugPrint(error)
            }
            reloadData()
        }
    }
}


