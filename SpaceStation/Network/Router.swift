//
//  Router.swift
//  Vikings
//
//  Created by Дмитрий Пермяков on 18.09.2023.
//

import Foundation

// MARK: ROUTER

enum Router {
    case station
}

// MARK: METHODs

enum Method: String {
    case get  = "GET"
    case post = "POST"
}

// MARK: ENDPOINTS

extension Router {
    
    var endpoint: String {
        switch self {
        case .station: return .baseUrl + .station
        }
    }
}

// MARK: CONSTANTS

private extension String {
    
    static let baseUrl = "http://192.168.29.106:2023/api"
    static let station = "/Station"
}
