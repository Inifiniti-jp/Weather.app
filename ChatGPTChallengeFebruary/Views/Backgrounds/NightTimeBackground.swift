//
//  StarSky.swift
//  ChatGPTChallengeFebruary
//
//  Created by Jakub Plachy on 17.02.2025.
//

import SwiftUI

struct NightTimeBackground: View {
    

    var body: some View {
        ZStack {
            // Background gradient for a night sky.
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            
        }
    }
    }

#Preview {
    NightTimeBackground()
}
