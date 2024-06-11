//
//  ContentView.swift
//  Basket Court
//
//  Created by Stanisław Makijenko on 17/05/2024.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    //Scene definition
        let scene = GameScene()
    
    var body: some View {
        VStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
        }
    }
}
#Preview {
    ContentView()
}
