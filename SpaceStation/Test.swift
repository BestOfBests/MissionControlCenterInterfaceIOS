//
//  Test.swift
//  SpaceStation
//
//  Created by Dmitriy Permyakov on 28/10/2023.
//

import SwiftUI

struct Test: View {
    var body: some View {
        Image("space")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 200, height: 200)
            .mask {
                Image("questionMark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300 * 0.5)
            }
    }
}

#Preview {
    Test()
}
