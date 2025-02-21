//
//  StarSky.swift
//  ChatGPTChallengeFebruary
//
//  Created by Jakub Plachy on 17.02.2025.
//

import SwiftUI

struct NightTimeBackground: View {
        let starCount = 100

        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    // Background gradient for a night sky.
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    
                    // Generate flickering stars.
                    ForEach(0..<starCount, id: \.self) { _ in
                        // Random size and base opacity.
                        let size = CGFloat.random(in: 1...3)
                        let baseOpacity = Double.random(in: 0.5...1.0)
                        // Random duration for flickering effect.
                        let flickerDuration = Double.random(in: 1.0...2.0)
                        
                        FlickeringStar(size: size, baseOpacity: baseOpacity, flickerDuration: flickerDuration)
                            .position(
                                x: CGFloat.random(in: 0...geometry.size.width),
                                y: CGFloat.random(in: 0...geometry.size.height)
                            )
                    }
                }
            }
        }
    }

    struct FlickeringStar: View {
        let size: CGFloat
        let baseOpacity: Double
        let flickerDuration: Double
        
        @State private var isFaded = false

        var body: some View {
            Circle()
                .fill(Color.white)
                .frame(width: size, height: size)
                // Flickers between a lower and the base opacity.
                .opacity(isFaded ? baseOpacity * 0.3 : baseOpacity)
                .onAppear {
                    withAnimation(
                        Animation.easeInOut(duration: flickerDuration)
                            .repeatForever(autoreverses: true)
                            // Random delay so that stars aren't all in sync.
                            .delay(Double.random(in: 0...flickerDuration))
                    ) {
                        isFaded.toggle()
                    }
                }
        }
    }

#Preview {
    NightTimeBackground()
}
