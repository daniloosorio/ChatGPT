//
//  EditView.swift
//  ChatGPT
//
//  Created by Danilo Osorio on 13/03/25.
//

import SwiftUI

struct EditView: View {
    @StateObject var viewModel = EditViewModel()
    @State var text: String = ""
    @State var selectedImage: Image?
    @State var emptyImage: Image = Image(systemName: "photo.on.rectangle.angled")
    
    var currentImage: some View {
        if let selectedImage {
            selectedImage
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 300)
        } else {
             emptyImage
                .resizable()
                .scaledToFill()
                .frame(width: 40,height: 40)
        }
    }
    var body: some View {
        Text("Create a mask")
            .font(.headline)
            .padding(.vertical, 12)
    }
}
