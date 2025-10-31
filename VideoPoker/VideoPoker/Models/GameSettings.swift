import SwiftUI

class GameSettings: ObservableObject {
    @AppStorage("hapticFeedbackEnabled") var hapticFeedbackEnabled: Bool = true
    @AppStorage("sfxEnabled") var sfxEnabled: Bool = true
    @AppStorage("musicEnabled") var musicEnabled: Bool = true
    
    static let shared = GameSettings()
    
    private init() {} // Singleton
    
    func playHapticFeedback() {
        guard hapticFeedbackEnabled else { return }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
} 
