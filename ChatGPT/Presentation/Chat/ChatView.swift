//
//  ChatView.swift
//  ChatGPT
//
//  Created by Danilo Osorio on 12/03/25.
//

import SwiftUI

struct ChatView: View {
    @StateObject var viewModel = ViewModel()
    @State var prompt: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            ConversationView()
                .environmentObject(viewModel)
                .padding(.horizontal)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .onTapGesture {
                    isFocused = false
                }

            HStack{
                TextField("Escribe una pregunta...",
                          text: $prompt,
                          axis: .vertical)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(25)
                .lineLimit(6)
                .focused($isFocused)
                
                Button {
                    Task {
                        await viewModel.send(message:prompt)
                        prompt = ""
                        
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(Color.white)
                        .frame(width: 44,height: 44)
                        .background(Color.blue)
                        .cornerRadius(22)
                }.padding(.leading,8)
                
            }
            
        }.padding()
    }
}

#Preview {
    ChatView()
}
