import SwiftUI

struct RealisticThunderstormView: View {
    @State private var showLightning = false
    
    var body: some View {
        ZStack {
            // Background: Normally dark, but brightens during lightning
            Color.black
                .opacity(showLightning ? 1 : 0) // Lightning effect
                .animation(.easeInOut(duration: 0.2), value: showLightning)
                .ignoresSafeArea()
        }
        .onAppear {
            triggerLightning()
        }
    }
    
    // Function to trigger lightning at random intervals
    private func triggerLightning() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 2...8)) {
            withAnimation(.easeIn(duration: 0.1)) {
                showLightning = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.1...0.3)) {
                withAnimation(.easeOut(duration: 0.2)) {
                    showLightning = false
                }
                triggerLightning() // Recursively call for next lightning flash
            }
        }
    }
}

// MARK: - Preview
struct RealisticThunderstormView_Previews: PreviewProvider {
    static var previews: some View {
        RealisticThunderstormView()
            .previewLayout(.sizeThatFits)
            .background(Color.black) // Keep the preview background dark
    }
}
