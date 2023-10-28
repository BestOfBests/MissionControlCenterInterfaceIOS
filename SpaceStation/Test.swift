//
//  Test.swift
//  SpaceStation
//
//  Created by Dmitriy Permyakov on 28/10/2023.
//

import SwiftUI

struct Test: View {
    @State private var currentAmmount: CGFloat = .zero

    var body: some View {
        VStack(spacing: 0) {
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    Image("space")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 3500)
                        .scaleEffect(1 + currentAmmount)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    print("value: \(value)")
                                    currentAmmount = value - 1
                                }
                                .onEnded { _ in
                                    currentAmmount = 0
                                }
                        )
                }
        }
    }
}

#Preview {
    Test()
}
