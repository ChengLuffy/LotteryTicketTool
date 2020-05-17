//
//  HistoryViewController.swift
//  LotteryTicketTool
//
//  Created by 成殿 on 2020/5/18.
//  Copyright © 2020 chengluffy. All rights reserved.
//

import UIKit
import WCDBSwift

class HistoryViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(ListCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    var dataSource = [Ticket]()
    lazy var database: Database = {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let database = Database(withPath: "\(docPath)/tikets.db")
        return database
    }()
    var type: Int?
    
    init(type: Int) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        title = "历史数据"
        getHistortData()
    }
    
    func getHistortData() {
        guard let type = self.type else { return }
        do {
            dataSource = try database.getObjects(on: Ticket.Properties.all, fromTable: "ticket", where: Ticket.Properties.cate == type + 2, orderBy: [Ticket.Properties.opentimestamp.asOrder(by: .descending)])
        } catch let error {
            debugPrint(error)
        }
        tableView.reloadData()
    }

}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListCell
        let ticket = dataSource[indexPath.row]
        cell.ticket = ticket
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
