//
//  CloudView.swift
//  ChatGPTChallengeFebruary
//
//  Created by Jakub Plachy on 25.02.2025.
//

import SwiftUI

struct RealisticCloudView: View {
    @State private var cloudOffsets: [CGFloat] = Array(repeating: 0, count: 4)

    var body: some View {
        ZStack {
            // Multiple layers of clouds with different speeds and opacities
            ForEach(0..<4, id: \.self) { index in
                CloudLayerView(cloudIndex: index)
                    .offset(x: cloudOffsets[index])
                    .opacity(0.5 + Double(index) * 0.15) // Different opacities
                    .onAppear {
                        withAnimation(Animation.linear(duration: 20 + Double(index) * 5).repeatForever(autoreverses: false)) {
                            cloudOffsets[index] = -UIScreen.main.bounds.width * 1.5
                        }
                    }
            }
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .offset(y: -200)
        .opacity(0.5)
    }
}

// MARK: - Single Cloud Layer
struct CloudLayerView: View {
    let cloudIndex: Int
    private let cloudImages = ["cloud1", "cloud2", "cloud3"] // Ensure these images exist in Assets
    
    var body: some View {
        Image(cloudImages[cloudIndex % cloudImages.count])
            .resizable()
            .scaledToFit()
            .frame(width: UIScreen.main.bounds.width * 1.2, height: 200)
            .offset(y: CGFloat.random(in: -50...50)) // Random vertical offset for variation
    }
}

// MARK: - Preview
struct RealisticCloudView_Previews: PreviewProvider {
    static var previews: some View {
        RealisticCloudView()
            .previewLayout(.sizeThatFits)
    }
}
