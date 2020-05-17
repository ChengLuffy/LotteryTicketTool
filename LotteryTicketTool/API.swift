//
//  API.swift
//  LotteryTicketTool
//
//  Created by 成殿 on 2020/5/17.
//  Copyright © 2020 chengluffy. All rights reserved.
//

import Foundation
import Moya

enum ApiTool {
    case getSSQ
    case getDLT
}

extension ApiTool : TargetType {
    var baseURL: URL {
        return URL.init(string: "http://f.apiplus.net")!
    }

    var path: String {
        switch self {
        case .getSSQ:
            return "ssq-10.json"
        case .getDLT:
            return "dlt-10.json"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
        
    var sampleData: Data {return Data(base64Encoded: "just for test")!}
    var task: Task {
        return .requestPlain
    }

    var headers: [String : String]?{ return ["Content-type" : "application/json"] }
}
