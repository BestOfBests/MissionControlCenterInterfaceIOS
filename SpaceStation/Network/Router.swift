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
    case planets
    case rotationSpeed
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
        case .station: return String.baseUrl + .station
        case .planets: return String.baseUrl + .planets
        case .rotationSpeed: return String.baseUrl + .rotationSpeed
        }
    }
}

// MARK: CONSTANTS

private extension String {
    
    static let baseUrl = String.serverHost + "/api"
    static let station = "/Station"
    static let planets = String.station + "/planets"
    static let rotationSpeed = "Station/rotationSpeed"
}

extension String {

    static let serverHost = "http://192.168.43.18:2023"
}
