import SwiftUI

struct SnowView: View {
    @State private var snowDrops = Array(0..<30) // Number of raindrops

    var body: some View {
        ZStack {
            ForEach(snowDrops, id: \.self) { _ in
                SnowDrop()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear) // Keep background transparent
        .offset(y: -430)
    }
}

// MARK: - Single Raindrop
struct SnowDrop: View {
    @State private var dropOffset: CGFloat = -100
    private let dropSize: CGFloat = CGFloat.random(in: 4...8) // Random drop size
    private let fallDuration: Double = Double.random(in: 3.0...5.0) // Varying fall speed
    private let xOffset: CGFloat = CGFloat.random(in: -180...180) // Random horizontal position

    var body: some View {
        Circle()
            .fill(Color.white.opacity(0.7))
            .frame(width: dropSize / 2, height: dropSize)
            .offset(x: xOffset, y: dropOffset)
            .onAppear {
                withAnimation(
                    Animation.linear(duration: fallDuration)
                        .repeatForever(autoreverses: false)
                        .delay(Double.random(in: 0...1)) // Stagger start time
                ) {
                    dropOffset = 300
                }
            }
    }
}

// MARK: - Preview
struct SnowView_Previews: PreviewProvider {
    static var previews: some View {
        SnowView()
            .previewLayout(.sizeThatFits)
            .background(Color.black.opacity(0.2)) // To make raindrops visible
    }
}
