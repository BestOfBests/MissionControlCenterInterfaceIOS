//
//  StationState.swift
//  SpaceStation
//
//  Created by Dmitriy Permyakov on 28/10/2023.
//

import Foundation

struct StationStateEntity: Decodable {
    let name: String
    let batteryLevel: Double
    let transform: StationTransformEntity
}

struct StationTransformEntity: Decodable {
    let x: Double
    let y: Double
}
