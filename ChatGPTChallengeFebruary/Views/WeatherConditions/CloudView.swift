//
//  CloudView.swift
//  ChatGPTChallengeFebruary
//
//  Created by Jakub Plachy on 25.02.2025.
//

import SwiftUI

struct CloudView: View {
    @State private var cloudOffset: CGFloat = 0
    
    let cloudSpeed: Double = 20 // Adjust for faster/slower movement
    let cloudWidth: CGFloat = UIScreen.main.bounds.width // Slightly wider than screen
    
    var body: some View {
        ZStack {
            // Cloud layer moving seamlessly
            HStack(spacing: 0) {
                Image("cloud1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: cloudWidth)
                
                Image("cloud2") // Duplicate image to ensure seamless looping
                    .resizable()
                    .scaledToFit()
                    .frame(width: cloudWidth)
            }
            .offset(x: cloudOffset)
            .onAppear {
                startCloudAnimation()
            }
        }
        .ignoresSafeArea()
        .offset(y: -200)
    }
    
    // Moves clouds seamlessly
    private func startCloudAnimation() {
        withAnimation(Animation.linear(duration: 60).repeatForever(autoreverses: false)) {
            cloudOffset = -cloudWidth
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            cloudOffset = 0 // Reset position to make the loop seamless
            startCloudAnimation()
        }
    }
}

#Preview {
    CloudView()
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.black)
}
