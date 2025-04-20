//
//  MainMenuView.swift
//  VideoPoker
//
//  Created by Amarjit on 08/04/2025.
//

import SwiftUI
import SwiftData

struct MainMenuView: View {

    var body: some View {
        Text("Simple Video Poker").font(.largeTitle)
        
        Button(action: {
            print("Play")
        }) {
            Text("Play")
                .font(.title)
                .frame(width: 44, height: 44)
        }
    }
}

#Preview {
    MainMenuView()
}
