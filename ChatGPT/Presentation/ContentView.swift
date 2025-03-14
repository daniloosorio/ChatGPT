//
//  ContentView.swift
//  ChatGPT
//
//  Created by Danilo Osorio on 10/03/25.
//

// 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

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView{
            ChatView()
                .tabItem {
                    Image(systemName: "message.circle.fill")
                    Text("Chat")
                }
            PhotoView()
                .tabItem {
                    Image(systemName: "camera.circle.fill")
                    Text("Fotos")
                }
            EditView()
                .tabItem {
                    Image(systemName: "photo.artframe.circle.fill")
                    Text("Editar")
                }
        }
    }
}


#Preview {
    ContentView()
}
