//
//  MapView.swift
//  SpaceStation
//
//  Created by Dmitriy Permyakov on 28/10/2023.
//

import SwiftUI

struct MapView: View {
    @EnvironmentObject var mainObserver: MainObserver
    @State private var planets: [PlanetModel] = []

    var body: some View {
        GeometryReader { proxy in
            MapScreen(proxy.size)
                .overlay(alignment: .bottom) {
                    ControllerView
            }
        }
        .onDisappear {
            mainObserver.showTabBar = true
        }
        .onAppear {
            // TODO: Получать планеты
            planets = .planets
        }
    }
}

// MARK: - Views

private extension MapView {

    func MapScreen(_ size: CGSize) -> some View {
        ZStack(alignment: .topLeading) {
            ForEach(planets) { planet in
                let xOffset = planet.coordinates.x - size.width / 2
                let yOffset = planet.coordinates.y - size.height / 2

                Image("saturn")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .offset(x: xOffset, y: yOffset)
            }
        }
        .frame(width: size.width, height: size.height)
    }

    func ControlButton(_ imageName: String) -> some View{
        Button {

        } label: {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 40)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
    }

    var ControllerView: some View {
        VStack {
            Image("ship")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)

            HStack {
                ForEach([
                    "chevron.left.circle",
                    "flame.circle",
                    "chevron.right.circle"
                ], id: \.self) {
                    ControlButton($0)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    MapView()
        .environmentObject(MainObserver())
}

// MARK: - Mock Data

private extension [PlanetModel] {

    static let planets: [PlanetModel] = [
        .init(id: 0, name: "Планета 1", description: nil, discoveringDate: nil, imageURL: .saturn, square: nil, coordinates: .init(x: 0, y: 0)),
//        .init(id: 1, name: "Планета 2", description: nil, discoveringDate: nil, imageURL: .saturn, square: nil, coordinates: .init(x: 0, y: 750)),
//        .init(id: 2, name: "Планета 3", description: nil, discoveringDate: nil, imageURL: .saturn, square: nil, coordinates: .init(x: 350, y: 0)),
//        .init(id: 3, name: "Планета 4", description: nil, discoveringDate: nil, imageURL: .saturn, square: nil, coordinates: .init(x: 100, y: 100)),
//        .init(id: 4, name: "Планета 5", description: nil, discoveringDate: nil, imageURL: .saturn, square: nil, coordinates: .init(x: 100, y: 500)),
//        .init(id: 5, name: "Планета 6", description: nil, discoveringDate: nil, imageURL: .saturn, square: nil, coordinates: .init(x: 100, y: 0)),
    ]
}
