//
//  ClearDayView.swift
//  ChatGPTChallengeFebruary
//
//  Created by Jakub Plachy on 27.02.2025.
//

import SwiftUI

struct ClearDayView: View {
    var body: some View {
        Circle()
            .foregroundStyle(.yellow.opacity(0.7))
            .blur(radius: 20)
            .frame(maxWidth: 250)
            .offset(y: -200)
    }
}

#Preview {
    ClearDayView()
}
