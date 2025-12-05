//
//  MapPin.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 12/4/25.
//

import SwiftUI

struct MapPin: View {
    @State private var appear = false

    var body: some View {
        Image(systemName: "mappin")
            .font(.title)
            .bold()
            .foregroundStyle(.purple)
            .scaleEffect(appear ? 1.0 : 0.6)
            .opacity(appear ? 1.0 : 0.0)
            .onAppear {
                withAnimation(.bouncy) {
                    appear = true
                }
            }
    }
}

#Preview {
    MapPin()
}
