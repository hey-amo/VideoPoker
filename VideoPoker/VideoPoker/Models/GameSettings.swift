import SwiftUI

class GameSettings: ObservableObject {
    @AppStorage("hapticFeedbackEnabled") var hapticFeedbackEnabled: Bool = true
    
    static let shared = GameSettings()
    
    private init() {} // Singleton
    
    func playHapticFeedback() {
        guard hapticFeedbackEnabled else { return }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
} 