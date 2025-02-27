import SwiftUI

struct MistView: View {
    @State private var mistOffset1: CGFloat = -50
    @State private var mistOffset2: CGFloat = 50
    @State private var mistOpacity: Double = 0.8
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.4).ignoresSafeArea() // Light mist background
            
            // Mist Layer 1 - Moves slowly
            MistLayer()
                .offset(y: -200)
                .opacity(mistOpacity)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
                        mistOffset1 = 50
                    }
                }
            
            // Mist Layer 2 - Moves in the opposite direction
            MistLayer()
                .offset(y: -100)
                .opacity(mistOpacity - 0.1)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                        mistOffset2 = -50
                    }
                }
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                mistOpacity = 0.7 // Mist fades in and out subtly
            }
        }
    }
}

// MARK: - Mist Layer (Blurred White Overlay)
struct MistLayer: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.white.opacity(0.2))
            .frame(width: UIScreen.main.bounds.width * 1.2, height: 200)
            .blur(radius: 30) // Soft mist effect
    }
}

// MARK: - Preview
struct MistView_Previews: PreviewProvider {
    static var previews: some View {
        MistView()
            .previewLayout(.sizeThatFits)
            .background(Color.blue.opacity(0.3)) // Simulating a sky background
    }
}
