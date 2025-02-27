import SwiftUI

struct RainView: View {
    @State private var rainDrops = Array(0..<30) // Number of raindrops

    var body: some View {
        ZStack {
            ForEach(rainDrops, id: \.self) { raindrop in
                Raindrop()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

// MARK: - Single Raindrop
struct Raindrop: View {
    @State private var dropOffset: CGFloat = -500
    private let dropSize: CGFloat = CGFloat.random(in: 4...8) // Random drop size
    private let fallDuration: Double = Double.random(in: 0.2...0.5) // Varying fall speed
    private let xOffset: CGFloat = CGFloat.random(in: -180...180) // Random horizontal position

    var body: some View {
        Capsule()
            .fill(Color.white.opacity(0.3))
            .frame(width: dropSize / 2, height: dropSize)
            .offset(x: xOffset, y: dropOffset)
            .onAppear {
                withAnimation(
                    Animation.linear(duration: fallDuration)
                        .repeatForever(autoreverses: false)
                        .delay(Double.random(in: 0...1)) // Stagger start time
                ) {
                    dropOffset = 500
                }
            }
    }
        
}

// MARK: - Preview
struct RainView_Previews: PreviewProvider {
    static var previews: some View {
        RainView()
            .background(Color.black) // To make raindrops visible
    }
}
