//
//  ClearNightView.swift
//  ChatGPTChallengeFebruary
//
//  Created by Jakub Plachy on 27.02.2025.
//

import SwiftUI

struct ClearNightView: View {
    var body: some View {
        Circle()
            .fill(Color.white.opacity(0.5))
            .blur(radius: 20)
            .frame(maxWidth: 250)
            .offset(y: -200)
    }
}

#Preview {
    ClearNightView()
        .background(Color.black)
}
