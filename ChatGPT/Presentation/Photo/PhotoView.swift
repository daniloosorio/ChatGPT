//
//  PhotoView.swift
//  ChatGPT
//
//  Created by Danilo Osorio on 12/03/25.
//

import SwiftUI

struct PhotoView: View {
    @StateObject var viewModel = PhotoViewModel()
    @State var text = "evil"
    var body: some View {
        VStack{
            Text("Fotos")
            
            Form {
                AsyncImage(url: viewModel.imageURL){ image in
                    image
                        .resizable()
                        .scaledToFit()
                        .overlay(alignment:.bottomTrailing) {
                            Button {
                                Task{
                                    await viewModel.saveImageGalery()
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "arrow.down.circle.fill")
                                        .resizable()
                                        .frame(width: 30,height: 30)
                                        .shadow(color: .black, radius: 0.2)
                                }
                                .padding(8)
                                .foregroundColor(.green)
                            }
                        }
                }
                placeholder: {
                    VStack{
                        if !viewModel.isLoading {
                            
                            Image(systemName: "photo.on.rectangle.angled")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40,height: 40)
                        } else{
                            ProgressView()
                                .padding(.bottom,12)
                            Text("Pintando imagen 🌆")
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(width: 300,height: 300)
                }
                TextField("Describe tu imagen",
                          text: $text,
                          axis: .vertical)
                .lineLimit(10)
                .lineSpacing(5)
                
                HStack{
                    Spacer()
                    Button("🏞️ Generar Imagen"){
                        Task {
                            await viewModel.generateImage(withText: text)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.isLoading)
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
