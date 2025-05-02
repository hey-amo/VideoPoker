import SwiftUI

struct SettingsView: View {
    @StateObject private var settings = GameSettings.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Feedback")) {
                    Toggle("Haptic Feedback", isOn: $settings.hapticFeedbackEnabled)
                }
                Section(header: Text("Sound/Music")) {
                    Toggle("Sound Effects", isOn: $settings.sfxEnabled)
                    Toggle("Music", isOn:
                            $settings.musicEnabled)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
} 

#Preview {
    SettingsView()
}
