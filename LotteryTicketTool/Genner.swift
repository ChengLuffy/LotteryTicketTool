//
//  File.swift
//  LotteryTicketTool
//
//  Created by 成殿 on 13/11/2018.
//  Copyright © 2018 chengluffy. All rights reserved.
//

import Foundation
import WCDBSwift
import SwiftRandom

enum TicketType {
    case sportsLottery
    case welfareLottery
}

class GenerateTicketTool {
    
    class Pool {
        var firstPool: [Int]? = nil
        var secondPool: [Int]? = nil
    }
    
    class func generateTicket(with type: TicketType, expect: Int) -> Ticket {
        
        let pool = generatePool(with: type)
        
        var firstPool = pool.firstPool!
        var secondPool = pool.secondPool!
        
        var firstZoon = [Int]()
        var secondZoon = [Int]()
        
        let i = type == .sportsLottery ? 5 : 6
        let j = type == .sportsLottery ? 2 : 1
        for _ in 1...i {
            let item = firstPool.randomItem()!
            firstZoon.append(item)
            firstPool.removeAll(where: { $0 == item })
        }
        firstZoon.sort()
        for _ in 1...j {
            let item = secondPool.randomItem()!
            secondZoon.append(item)
            secondPool.removeAll(where: { $0 == item })
        }
        secondZoon.sort()
        let first = firstZoon.map({ return "\($0)" }).joined(separator: ",")
        let second = secondZoon.map({ return "\($0)" }).joined(separator: ",")
        let opencode = first + "+" + second
        
        let date = Date()
        let opentimestamp = Int64(date.timeIntervalSince1970)
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:SS"
        let opentime = dateFormater.string(from: date)
        
        var luckyTiket = Ticket.init(expect: "\(expect)", opencode: opencode, opentime: opentime, opentimestamp: opentimestamp)
        luckyTiket.cate = type == .sportsLottery ? 0 : 1
        
        return luckyTiket
    }
    
    class func generatePool(with type: TicketType) -> Pool {
        let pool = Pool()
        
        var i = 0
        var j = 0
        
        switch type {
            case .welfareLottery:
                i = 33
                j = 16
                break
            case .sportsLottery:
                i = 35
                j = 12
                break
        }
        
        var first = [Int]()
        
        for i in 1...i {
            first.append(i)
        }
        
        var second = [Int]()
        
        for j in 1...j {
            second.append(j)
        }
        
        pool.firstPool = first
        pool.secondPool = second
        
        return pool
    }
}

struct Response: Codable {
    let code: String
    let data: [Ticket]
}

struct Ticket: TableCodable {
    let expect: String
    let opencode: String
    let opentime: String
    let opentimestamp: Int64
    var cate: Int? = 0
    var ticketPurchased: Bool? = false
    var degree: Int? = 0
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = Ticket
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case expect
        case opencode
        case opentime
        case opentimestamp
        case cate
        case ticketPurchased
        case degree

        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                opentimestamp: ColumnConstraintBinding(isPrimary: true),
                cate: ColumnConstraintBinding(isNotNull: false, defaultTo: ColumnDef.DefaultType.int64(0)),
                ticketPurchased: ColumnConstraintBinding(isNotNull: false, defaultTo: ColumnDef.DefaultType.bool(false)),
                degree: ColumnConstraintBinding(isNotNull: false, defaultTo: ColumnDef.DefaultType.int32(0))
            ]
        }
    }
}
