import SwiftUI

struct MenuView: View {
    @ObservedObject private var router = Router.shared
    
    var body: some View {
        NavigationView {
            List {
                Button("New Game") {
                    // Add new game logic
                    router.dismissModal()
                }
                
                Button("How to Play") {
                    // Add instructions logic
                }
                
                Button("Statistics") {
                    // Add stats logic
                }
            }
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        router.dismissModal()
                    }
                }
            }
        }
    }
} 
