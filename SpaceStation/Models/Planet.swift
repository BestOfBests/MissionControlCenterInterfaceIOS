//
//  Planet.swift
//  SpaceStation
//
//  Created by Dmitriy Permyakov on 28/10/2023.
//

import Foundation

// MARK: Entity

struct PlanetEntity: Decodable {
    let id: Int
    let name: String?
    let description: String?
    let discoveringDate: String?
    let imageURL: String?
    let square: Double?
    let coordinates: PlanetCoorinateEntity
}

struct PlanetCoorinateEntity: Decodable {
    let x: Double
    let y: Double
}

// MARK: View Model

struct PlanetModel: Identifiable {
    let id: Int
    let name: String?
    let description: String?
    let discoveringDate: String?
    let imageURL: URL?
    let square: Double?
    let coordinates: PlanetCoorinateModel
}

struct PlanetCoorinateModel {
    let x: Double
    let y: Double
}

// MARK: - Mapper

private extension PlanetCoorinateEntity {
    var mapper: PlanetCoorinateModel {
        PlanetCoorinateModel(x: x, y: y)
    }
}

extension PlanetEntity {

    var mapper: PlanetModel {
        PlanetModel(
            id: id,
            name: name,
            description: description,
            discoveringDate: discoveringDate,
            imageURL: imageURL?.toURL,
            square: square,
            coordinates: coordinates.mapper
        )
    }
}
