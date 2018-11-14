//
//  SecondViewController.swift
//  LotteryTicketTool
//
//  Created by 成殿 on 12/11/2018.
//  Copyright © 2018 chengluffy. All rights reserved.
//

import UIKit
import WCDBSwift

class SecondViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataSource = [Ticket]()
    lazy var database: Database = {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let database = Database(withPath: "\(docPath)/tikets.db")
        let _ = database.canOpen
        return database
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.tableFooterView = UIView()
        reloadData()
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
        tableView.reloadData()
    }

}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


