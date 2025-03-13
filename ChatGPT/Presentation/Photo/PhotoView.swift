//
//  PhotoView.swift
//  ChatGPT
//
//  Created by Danilo Osorio on 12/03/25.
//

import SwiftUI

struct PhotoView: View {
    @State var text = "Two baby cats"
    var body: some View {
        VStack{
            Text("Fotos")
            
            Form {
                TextField("Describe tu imagen",
                          text: $text,
                          axis: .vertical)
                .lineLimit(10)
                .lineSpacing(5)
                
                HStack{
                    Spacer()
                    Button("🏞️ Generar Imagen"){
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(false)
                    .padding(.vertical)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    PhotoView()
}
