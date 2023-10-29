//
//  MapView.swift
//  SpaceStation
//
//  Created by Dmitriy Permyakov on 28/10/2023.
//

import SwiftUI

struct MapView: View {
    @EnvironmentObject var mainObserver: MainObserver
    @State private var station: StationStateModel!
    @State private var ConstPlanets: [PlanetModel]!
    @State private var rocketOffset: CGPoint = .zero
    @State private var proxy: ScrollViewProxy? = nil
    @State private var timer: Timer?
    @State private var showButtons = true
    @State private var showView = false

    var body: some View {
        VStack{
            if showView && station != nil && ConstPlanets != nil {
                MapScreen()
                    .overlay(alignment: .bottom) {
                        ControllerView
                    }
            } else {
                VStack(spacing: 10) {
                    ProgressView()
                    Image("not_found")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                    Text("Error")
                        .font(.title3)
                }
            }
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
                FetchPlanets()
                timer = Timer(timeInterval: 0.1, repeats: true) { _ in
                    FetchRocket()
                }
                RunLoop.main.add(timer!, forMode: .common)
            }
            .navigationTitle("Управление")
            .toolbar(.hidden, for: .tabBar)

    }
}

// MARK: - Views

private extension MapView {

    func MapScreen() -> some View {
        ScrollView([.horizontal, .vertical], showsIndicators: false) {
            ScrollViewReader { proxy in
                ZStack {
                    ForEach(mainObserver.planets) { planet in
                        let xOffset = planet.coordinates.x
                        let yOffset = planet.coordinates.y

                        AsyncImage(url: planet.imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(edge: (planet.radius ?? 0) / 30)
                                .offset(x: xOffset, y: yOffset)
                                .id(planet.id)

                        } placeholder: {
                            ShimmeringView()
                                .frame(edge: 130)
                                .clipShape(Circle())
                                .offset(x: xOffset, y: yOffset)
                        }

                    }

                    Image("ship")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: .shipSize)
                        .focusable()
                        .offset(x: rocketOffset.x, y: rocketOffset.y)
                        .id(String.rocketProxyName)
                        .rotationEffect(
                            .degrees((station.transform.directionAngleDegrees ?? 0) + 90)
                        )
                }
                .frame(width: .screenScrollWidth, height: .screenScrollHeigth)
                .onAppear {
                    proxy.scrollTo(String.rocketProxyName, anchor: .center)
                    self.proxy = proxy
                }
            }
        }
    }

    @ViewBuilder
    func ControlButton(_ imageName: String) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 1.5)) {
                showButtons = false
                ButtonControlAction(imageName)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 2)) {
                    showButtons = true
                }
            }
        } label: {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: .buttonSize)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .offset(y: showButtons ? 0 : 200)
    }

    var ControllerView: some View {
        VStack {
            HStack {
                ForEach([String].buttonsControl, id: \.self) {
                    ControlButton($0)
                }
            }
        }
    }
}

// MARK: - Functions

private extension MapView {
    
    func FetchRocket() {
        NetworkService.shared.request(
            router: .station,
            method: .get,
            type: StationStateEntity.self,
            parameters: nil
        ) { result in
            switch result {
            case .success(let info):
                station = info.mapper
                guard let pl = ConstPlanets else { 
                    print("pl is nil")
                    return
                }
                mainObserver.planets = pl.newCoordinates(
                    x: station.transform.x,
                    y: station.transform.y
                )
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func FetchPlanets() {
        NetworkService.shared.request(
            router: .station,
            method: .get,
            type: StationStateEntity.self,
            parameters: nil
        ) { result in
            switch result {
            case .success(let info):
                station = info.mapper
                NetworkService.shared.request(
                    router: .planets,
                    method: .get,
                    type: [PlanetEntity].self,
                    parameters: ["scanRadius": 1500]
                ) { result in
                    switch result {
                    case .success(let planets):
                        self.ConstPlanets = planets.map { $0.mapper }
                        mainObserver.planets = ConstPlanets.newCoordinates(
                            x: station.transform.x,
                            y: station.transform.y
                        )
                        showView = true
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func FetchData() {
        showView = true
    }

    func ButtonControlAction(_ imageName: String) {
        switch imageName {
        case "stop.circle":
            print("stop")
            Post3((station.transform.linearSpeed ?? 0) - 10)

        case "chevron.left.circle":
            print("left")
            Post1()

        case "flame.circle":
            print("Fire")
            let speed = station.transform.linearSpeed ?? 0
            print("speed \(speed)")
            Post3(speed + 10)

        default:
            print("right")
            Post2()
        }
    }
}

// MARK: - POST

private extension MapView {

    func Post1() {
        guard let url = URL(string: "http://192.168.29.106:2023/api/Station/rotationSpeed") else {
            print("ERROR: url")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let bodyData = try JSONSerialization.data(
                withJSONObject: ["requiredRotationSpeedClockwiseDegrees": -10]
            )
            request.httpBody = bodyData
        } catch {
            print("ERROR 1", error)
            return
        }
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error {
                print("ERROR 2", error.localizedDescription)
                return
            }
            print("SUCCES")
        }.resume()
    }

    func Post2() {
        guard let url = URL(string: "http://192.168.29.106:2023/api/Station/rotationSpeed") else {
            print("ERROR: url")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let bodyData = try JSONSerialization.data(
                withJSONObject: ["requiredRotationSpeedClockwiseDegrees": 10]
            )
            request.httpBody = bodyData
        } catch {
            print("ERROR 1", error)
            return
        }
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error {
                print("ERROR 2", error.localizedDescription)
                return
            }
            print("SUCCES")
        }.resume()
    }

    func Post3(_ speed: Double) {
        print("CURRENT SPEED \(speed)")
        guard let url = URL(string: "http://192.168.29.106:2023/api/Station/linearSpeed") else {
            print("ERROR: url")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let bodyData = try JSONSerialization.data(
                withJSONObject: ["requiredLinearSpeed": speed]
            )
            request.httpBody = bodyData
        } catch {
            print("ERROR 1", error)
            return
        }
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error {
                print("ERROR 2", error.localizedDescription)
                return
            }
            print("SUCCESS")
        }.resume()
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .environmentObject(MainObserver())
}

#Preview {
    MapView()
        .environmentObject(MainObserver())
}

// MARK: - Constants

private extension CGFloat {

    static let buttonSize: CGFloat = 40
    static let planetSize: CGFloat = 150
    static let shipSize: CGFloat = 90
    static let screenScrollWidth: CGFloat = 700
    static let screenScrollHeigth: CGFloat = 2000
}

private extension String {

    static let rocketProxyName = "Rocket"
}

private extension [String] {

    static let buttonsControl: Self = [
        "chevron.left.circle",
        "flame.circle",
        "stop.circle",
        "chevron.right.circle"
    ]
}

// MARK: - Mock Data

private extension [PlanetModel] {

    static let planets: [PlanetModel] = [
        .init(id: 0, name: "Планета 1", description: nil, discoveryDate: nil, imageURL: .saturn, radius: nil, mass: nil, coordinates: .init(x: -100, y: -250)),
        .init(id: 1, name: "Планета 1", description: nil, discoveryDate: nil, imageURL: .saturn, radius: nil, mass: nil, coordinates: .init(x: -100, y: -250)),
        .init(id: 2, name: "Планета 1", description: nil, discoveryDate: nil, imageURL: .saturn, radius: nil, mass: nil, coordinates: .init(x: 350, y: 0)),
        .init(id: 3, name: "Планета 1", description: nil, discoveryDate: nil, imageURL: .saturn, radius: nil, mass: nil, coordinates: .init(x: 100, y: 100)),
        .init(id: 4, name: "Планета 1", description: nil, discoveryDate: nil, imageURL: .saturn, radius: nil, mass: nil, coordinates: .init(x: 100, y: 500)),
        .init(id: 5, name: "Планета 1", description: nil, discoveryDate: nil, imageURL: .saturn, radius: nil, mass: nil, coordinates: .init(x: 100, y: 0)),
    ]

    static let planets2: [PlanetModel] = [
        .init(id: 0, name: "Планета 1", description: nil, discoveryDate: nil, imageURL: .saturn, radius: nil, mass: nil, coordinates: .init(x: -1000, y: 30)),
        .init(id: 1, name: "Планета 1", description: nil, discoveryDate: nil, imageURL: .saturn, radius: nil, mass: nil, coordinates: .init(x: -700, y: -950)),
        .init(id: 2, name: "Планета 1", description: nil, discoveryDate: nil, imageURL: .saturn, radius: nil, mass: nil, coordinates: .init(x: 450, y: 20)),
        .init(id: 3, name: "Планета 1", description: nil, discoveryDate: nil, imageURL: .saturn, radius: nil, mass: nil, coordinates: .init(x: 500, y: 300)),
        .init(id: 4, name: "Планета 1", description: nil, discoveryDate: nil, imageURL: .saturn, radius: nil, mass: nil, coordinates: .init(x: 500, y: 300)),
        .init(id: 5, name: "Планета 1", description: nil, discoveryDate: nil, imageURL: .saturn, radius: nil, mass: nil, coordinates: .init(x: -100, y: 300)),
        .init(id: 6, name: "Планета 1", description: nil, discoveryDate: nil, imageURL: .saturn, radius: nil, mass: nil, coordinates: .init(x: 20, y: 20))
    ]

    static let planets3: [PlanetModel] = [
        .init(id: 0, name: "Планета 1", description: nil, discoveryDate: nil, imageURL: .saturn, radius: nil, mass: nil, coordinates: .init(x: -10, y: 10)),
        .init(id: 1, name: "Планета 1", description: nil, discoveryDate: nil, imageURL: .saturn, radius: nil, mass: nil, coordinates: .init(x: -500, y: -950)),
        .init(id: 2, name: "Планета 1", description: nil, discoveryDate: nil, imageURL: .saturn, radius: nil, mass: nil, coordinates: .init(x: 0, y: 450)),
        .init(id: 3, name: "Планета 1", description: nil, discoveryDate: nil, imageURL: .saturn, radius: nil, mass: nil, coordinates: .init(x: 48, y: 800)),
        .init(id: 4, name: "Планета 1", description: nil, discoveryDate: nil, imageURL: .saturn, radius: nil, mass: nil, coordinates: .init(x: 0, y: 100)),
        .init(id: 5, name: "Планета 1", description: nil, discoveryDate: nil, imageURL: .saturn, radius: nil, mass: nil, coordinates: .init(x: 800, y: 0))
    ]
}
