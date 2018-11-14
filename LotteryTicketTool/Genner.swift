//
//  File.swift
//  LotteryTicketTool
//
//  Created by 成殿 on 13/11/2018.
//  Copyright © 2018 chengluffy. All rights reserved.
//

import Foundation
import WCDBSwift

enum TicketType {
    case sportsLottery
    case welfareLottery
}

class GenerateTicketTool {
    
    class Pool {
        var firstPool: [Int]? = nil
        var secondPool: [Int]? = nil
    }
    
    class func generateTicket(with type: TicketType) -> Ticket {
        
        let pool = generatePool(with: type)
        
        var firstPool = pool.firstPool!
        var secondPool = pool.secondPool!
        
        var firstZoon = [Int]()
        var secondZoon = [Int]()
        
        let i = type == .sportsLottery ? 5 : 6
        let j = type == .sportsLottery ? 2 : 1
        for _ in 1...i {
            let index = Int.random(in: 0...(firstPool.count - 1))
            firstZoon.append(firstPool[index])
            firstPool.remove(at: index)
        }
        
        for _ in 1...j {
            let index = Int.random(in: 0...(secondPool.count - 1))
            secondZoon.append(secondPool[index])
            secondPool.remove(at: index)
        }
        
        let luckyTiket = Ticket()
        luckyTiket.firstZoon = firstZoon.sorted(by: <)
        luckyTiket.secondZoon = secondZoon.sorted(by: <)
        
        luckyTiket.date = Date()
        luckyTiket.cate = type == .sportsLottery ? 0 : 1
        
        return luckyTiket
    }
    
    class func generatePool(with type: TicketType) -> Pool {
        let pool = Pool()
        
        var i = 0
        var j = 0
        
        switch type {
            case .sportsLottery:
                i = 33
                j = 16
                break
            case .welfareLottery:
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

class Ticket: TableCodable {
    var firstZoon: [Int]? = nil
    var secondZoon: [Int]? = nil
    var date: Date? = nil
    var cate: Int = 0
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = Ticket
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case firstZoon
        case secondZoon
        case date
        case cate
    }
    
    func describe() -> String {
        var str1 = String()
        for i in firstZoon ?? [] {
            str1.append("  \(i)")
        }
        
        var str2 = String()
        for j in secondZoon ?? [] {
            str2.append("  \(j)")
        }
        return "first zoon: \(str1)\nsecond zoon:\(str2)"
    }
    
}
