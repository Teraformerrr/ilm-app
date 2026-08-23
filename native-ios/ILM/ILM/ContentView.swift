//
//  ContentView.swift
//  ILM
//
//  Created by Mohamed Jamshed on 23/08/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Text("العلم")
                    .font(.system(size: 48, weight: .bold))

                Text("ILM")
                    .font(.title)
                    .fontWeight(.semibold)

                Text("Knowledge. Faith. Practice.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
