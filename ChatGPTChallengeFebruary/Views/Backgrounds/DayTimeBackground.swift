//
//  DayTimeBackground.swift
//  ChatGPTChallengeFebruary
//
//  Created by Jakub Plachy on 18.02.2025.
//

import SwiftUI

struct DayTimeBackground: View {
    @State private var cloudOffset1: CGFloat = -200
    @State private var cloudOffset2: CGFloat = 300

    var body: some View {
        ZStack {
            // Gradient sky
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.cyan]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Sun
            Circle()
                .fill(Color.yellow)
                .opacity(0.5)
                .frame(width: 150, height: 150)
                .overlay(
                    Circle()
                        .fill(Color.yellow.opacity(0.5))
                        .frame(width: 200, height: 200)
                        .blur(radius: 20)
                )
                .position(x: UIScreen.main.bounds.width / 2, y: 100)
            
            // Animated clouds
            CloudView()
                .offset(x: cloudOffset1, y: -50)
                .onAppear {
                    withAnimation(Animation.linear(duration: 20).repeatForever(autoreverses: false)) {
                        cloudOffset1 = UIScreen.main.bounds.width + 100
                    }
                }

            CloudView()
                .offset(x: cloudOffset2, y: 80)
                .onAppear {
                    withAnimation(Animation.linear(duration: 25).repeatForever(autoreverses: false)) {
                        cloudOffset2 = -200
                    }
                }
        }
    }
}

struct CloudView: View {
    var body: some View {
        // Calculate base dimensions based on 75% of the screen width
        let screenWidth = UIScreen.main.bounds.width
        let baseWidth = screenWidth * 0.75
        let capsuleHeight = baseWidth / 2  // Maintaining a 2:1 width-to-height ratio
        let shadowWidth = baseWidth + 10
        let shadowHeight = capsuleHeight + 5
        
        return ZStack {
            // Main cloud body with an elongated capsule shape
            Capsule()
                .frame(width: baseWidth, height: capsuleHeight)
                .offset(y: 10)
            
            // Overlapping circles for a fluffy, organic look
            Circle()
                .frame(width: baseWidth * 0.5, height: baseWidth * 0.45)
                .offset(x: -baseWidth * 0.25, y: -10)
            Circle()
                .frame(width: baseWidth * 0.55, height: baseWidth * 0.5)
                .offset(x: baseWidth * 0.1, y: -20)
            Circle()
                .frame(width: baseWidth * 0.45, height: baseWidth * 0.4)
                .offset(x: baseWidth * 0.3, y: -5)
            
            // Subtle shadow effect for depth
            Capsule()
                .frame(width: shadowWidth, height: shadowHeight)
                .offset(y: 20)
                .foregroundColor(.white.opacity(0.6))
                .blur(radius: 12)
        }
        .foregroundColor(.white.opacity(0.85))
        .blur(radius: 5)
    }
}

#Preview {
    DayTimeBackground()
}
