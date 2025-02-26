//
//  DayTimeBackground.swift
//  ChatGPTChallengeFebruary
//
//  Created by Jakub Plachy on 18.02.2025.
//

import SwiftUI

struct DayTimeBackground: View {
    
        var body: some View {
            
            
            ZStack {
 
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.teal]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            }
        }
    }

#Preview {
    DayTimeBackground()
}
