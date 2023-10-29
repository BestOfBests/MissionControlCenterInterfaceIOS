//
//  StationView.swift
//  SpaceStation
//
//  Created by Dmitriy Permyakov on 29/10/2023.
//

import SwiftUI

struct StationView: View {
    @State private var station: StationStateModel = .mock

    var body: some View {
        VStack {
            VStack(spacing: 10) {
                Image("station")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text(station.name ?? "Без названия")
                    .font(.title)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .shimmer(.init(tint: .pink, highlight: .white))

                Text("Зарядка:")
                    .foregroundStyle(LinearGradient.instagramCircle)
                    .font(.headline)
                Label(
                    title: { Text(station.battery?.level?.toString ?? "") },
                    icon: { Image(systemName: "fuelpump") }
                )

                Text("Координаты:")
                    .foregroundStyle(LinearGradient.instagramCircle)
                    .font(.headline)
                
                HStack {
                    Text("X: \(station.transform.x)")
                    Text("Y: \(station.transform.y)")
                }

                Group {
                    Text("Установленаая линейная скорость:")
                        .foregroundStyle(LinearGradient.instagramCircle)
                        .font(.headline)
                    Text(station.transform.requiredLinearSpeed?.toString ?? "нету")
                    Text("Линейная скорость:")
                        .foregroundStyle(LinearGradient.instagramCircle)
                        .font(.headline)
                    Text(station.transform.linearSpeed?.toString ?? "нету")
                    Text("Угловая скорость:")
                        .foregroundStyle(LinearGradient.instagramCircle)
                        .font(.headline)
                    Text(station.transform.requiredRotationSpeedClockwiseDegrees?.toString ?? "нету")
                    Text("Направление:")
                        .foregroundStyle(LinearGradient.instagramCircle)
                        .font(.headline)
                    Text(station.transform.directionAngleDegrees?.toString ?? "нету")
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25.0)
                    .stroke(lineWidth: 2)
                    .fill(LinearGradient.instagramCircle.opacity(0.2))
            )
            Spacer()
        }
    }
}

#Preview {
    StationView()
}

private extension StationStateModel {

    static var mock = StationStateModel(
        name: "Станция",
        battery: .init(level: 1000, passiveDegradationRate: 1222, loadDegrationRate: 12123),
        linearSpeedAcceleration: 123,
        rotationSpeedDegreesAcceleration: 4321,
        transform: .init(
            x: 10,
            y: 40,
            requiredLinearSpeed: 21341,
            linearSpeed: 123213,
            requiredRotationSpeedClockwiseDegrees: 123,
            directionAngleDegrees: 123
        )
    )
}
