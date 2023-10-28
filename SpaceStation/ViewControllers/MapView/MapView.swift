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
    }
}

// MARK: - Views

private extension MapView {

    @ViewBuilder
    func MapScreen(_ size: CGSize) -> some View {
        VStack {

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

#Preview {
    MapView()
        .environmentObject(MainObserver())
}
