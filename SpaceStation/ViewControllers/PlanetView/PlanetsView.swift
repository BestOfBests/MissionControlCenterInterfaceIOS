//
//  PlanetsView.swift
//  Vikings
//
//  Created by Dmitriy Permyakov on 28/10/2023.
//

import SwiftUI

struct PlanetsView: View {
    @State private var planets: [PlanetModel] = []
    @State private var offsetY: CGFloat = .zero
    @State private var currentIndex: CGFloat = .zero

    var body: some View {
        GeometryReader {
            let size = $0.size
            let cardSize = size.width * 0.8

            LinearGradient(
                colors: [
                .clear,
                .brown.opacity(0.2),
                .brown.opacity(0.45),
                .brown
            ], 
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 300)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()

            HeaderView()

            VStack(spacing: 0) {
                ForEach(planets) { planet in
                    PlanetView(planet: planet, size: size)
                }
            }
            .frame(width: size.width)
            .padding(.top, size.height - cardSize)
            .offset(y: offsetY)
            .offset(y: -currentIndex * cardSize)
        }
        .coordinateSpace(name: "SCROLL")
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged({ value in
                    offsetY = value.translation.height * 0.4
                })
                .onEnded({ value in
                    let translation = value.translation.height
                    withAnimation(.easeInOut) {
                        if translation > 0 {
                            if currentIndex > 0 && translation > 250 {
                                currentIndex -= 1
                            }
                        } else {
                            if currentIndex < CGFloat(planets.count - 1) && -translation > 250 {
                                currentIndex += 1
                            }
                        }

                        offsetY = .zero
                    }
                })
        )
        .onAppear {
            planets = .planets
        }
    }

    func HeaderView() -> some View {
        VStack {
            HStack {
                Spacer()
                Button{

                } label: {
                    Image(systemName: "info.circle")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.foreground)
                }
            }

            GeometryReader {
                let size = $0.size

                HStack(spacing: 0) {
                    ForEach(planets) { planet in
                        VStack(spacing: 15) {
                            Text(planet.name ?? .planetEmptyName)
                                .font(.title.bold())
                                .multilineTextAlignment(.center)
                            Text(planet.square?.toString ?? .squareEmptyName)
                        }
                        .frame(width: size.width)
                    }
                }
                .offset(x: currentIndex * -size.width)
                .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8), value: currentIndex)
            }
            .padding(.top, -5)
        }
        .padding(15)
    }
}

// MARK: - Preview

#Preview {
    PlanetsView()
}

// MARK: - Constants

private extension String {

    static let planetEmptyName = "Название не задано"
    static let squareEmptyName = "Площадь не известна"

}

// MARK: - Mock data

private extension [PlanetModel] {

    static let planets: [PlanetModel] = [
        .init(id: 0, name: "Планета 1", description: nil, discoveringDate: nil, imageURL: .saturn, square: nil, coordinates: .init(x: 0, y: 0)),
        .init(id: 1, name: "Планета 2", description: nil, discoveringDate: nil, imageURL: .saturn, square: nil, coordinates: .init(x: 10, y: 10)),
        .init(id: 2, name: "Планета 3", description: nil, discoveringDate: nil, imageURL: .saturn, square: nil, coordinates: .init(x: 20, y: 20)),
        .init(id: 3, name: "Планета 4", description: nil, discoveringDate: nil, imageURL: .saturn, square: nil, coordinates: .init(x: 30, y: 30)),
        .init(id: 4, name: "Планета 5", description: nil, discoveringDate: nil, imageURL: .saturn, square: nil, coordinates: .init(x: 40, y: 40)),
        .init(id: 5, name: "Планета 6", description: nil, discoveringDate: nil, imageURL: .saturn, square: nil, coordinates: .init(x: 50, y: 50)),
    ]
}
