//
//  ThunderStormView.swift
//  ChatGPTChallengeFebruary
//
//  Created by Jakub Plachy on 26.02.2025.
//

import SwiftUI

struct ThunderStormView: View {
    @State private var cloudOffset: CGFloat = 0
    
    let cloudSpeed: Double = 20 // Adjust for faster/slower movement
    let cloudWidth: CGFloat = UIScreen.main.bounds.width
    @State private var showLightning: Bool = false
    
    var body: some View {
        ZStack {
            // Cloud layer moving seamlessly
            HStack(spacing: 0) {
                Image("cloud1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: cloudWidth)
                    .offset(x: cloudOffset, y: -200)
                
                Image("cloud2") // Duplicate image to ensure seamless looping
                    .resizable()
                    .scaledToFit()
                    .frame(width: cloudWidth)
                    .offset(x: cloudOffset, y: -200)
            }
            .overlay(Color.white.opacity(showLightning ? 0.8 : 0).frame(width: UIScreen.main.bounds.width, height: 1000))
            .onAppear {
                triggerLightning()
                startCloudAnimation()
            }
        }
        .ignoresSafeArea()
        
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
    
    private func triggerLightning() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 10...15)) {
            withAnimation(.easeIn(duration: 0.1) .repeatCount(.random(in: 1...3))) {
                showLightning = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.1...0.3)) {
                withAnimation(.easeOut(duration: 0.2)) {
                    showLightning = false
                }
                triggerLightning() // Recursively call to trigger again
            }
        }
    }
}

#Preview {
    ThunderStormView()
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.black)
}
