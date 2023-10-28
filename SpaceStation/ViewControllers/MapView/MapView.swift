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
    @State private var rocketOffset: CGPoint = .zero
    @State private var proxy: ScrollViewProxy? = nil

    var body: some View {
        MapScreen()
            .overlay(alignment: .bottom) {
                ControllerView
            }
            .onDisappear {
                mainObserver.showTabBar = true
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        proxy?.scrollTo(String.rocketProxyName, anchor: .center)
                    }) {
                        Image(systemName: "location.fill.viewfinder")
                    }
                }
            }
            .onAppear {
                // FIXME: Получать планеты
                planets = .planets
            }
    }
}

// MARK: - Views

private extension MapView {

    func MapScreen() -> some View {
        ScrollView([.horizontal, .vertical], showsIndicators: false) {
            ScrollViewReader { proxy in
                ZStack {
                    ForEach(planets) { planet in
                        let xOffset = planet.coordinates.x
                        let yOffset = -planet.coordinates.y

                        // FIXME: Заменить на фотки
                        Image("saturn")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(edge: .planetSize)
                            .offset(x: xOffset, y: yOffset)
                            .id(planet.id)
                    }

                    Image("ship")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: .shipSize)
                        .focusable()
                        .offset(x: rocketOffset.x, y: rocketOffset.y)
                        .id(String.rocketProxyName)
                }
                .frame(width: .screenScrollWidth, height: .screenScrollHeigth)
                .onAppear {
                    proxy.scrollTo(String.rocketProxyName, anchor: .center)
                    self.proxy = proxy
                }
            }
        }
    }

    func ControlButton(_ imageName: String) -> some View{
        Button {

        } label: {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: .buttonSize)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
    }

    var ControllerView: some View {
        VStack {
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
        .init(id: 1, name: "Планета 2", description: nil, discoveringDate: nil, imageURL: .saturn, square: nil, coordinates: .init(x: -100, y: -250)),
        .init(id: 2, name: "Планета 3", description: nil, discoveringDate: nil, imageURL: .saturn, square: nil, coordinates: .init(x: 350, y: 0)),
        .init(id: 3, name: "Планета 4", description: nil, discoveringDate: nil, imageURL: .saturn, square: nil, coordinates: .init(x: 100, y: 100)),
        .init(id: 4, name: "Планета 5", description: nil, discoveringDate: nil, imageURL: .saturn, square: nil, coordinates: .init(x: 100, y: 500)),
        .init(id: 5, name: "Планета 6", description: nil, discoveringDate: nil, imageURL: .saturn, square: nil, coordinates: .init(x: 100, y: 0)),
    ]
}

// MARK: - Constants

private extension CGFloat {

    static let buttonSize: CGFloat = 40
    static let planetSize: CGFloat = 150
    static let shipSize: CGFloat = 90
    static let screenScrollWidth: CGFloat = 700
    static let screenScrollHeigth: CGFloat = 1500
}

private extension String {

    static let rocketProxyName = "Rocket"
}
