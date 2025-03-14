//
//  PhotoViewModel.swift
//  ChatGPT
//
//  Created by Danilo Osorio on 13/03/25.
//

import Foundation
import UIKit

@MainActor
final class PhotoViewModel: ObservableObject {
    private let urlSession: URLSession
    @Published var imageURL: URL?
    @Published var isLoading = false
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func generateImage(withText text:String) async {
        guard let url = URL(string: "https://api.openai.com/v1/images/generations") else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer apikey", forHTTPHeaderField: "Authorization")
        
        let dictionary: [String: Any] = [
            "n": 1,
            "size":"1024x1024",
            "prompt": text
        ]
        
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        
        do {
            DispatchQueue.main.async {
                self.isLoading = true
            }
            let (data,_) = try await urlSession.data(for: urlRequest)
            let model = try JSONDecoder().decode(ModelResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.isLoading = false
                guard let firstModel = model.data.first else {
                    return
                }
                self.imageURL = URL(string: firstModel.url)
                print(self.imageURL ?? "no image url")
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func saveImageGalery() async {
        guard let imageURL = imageURL else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: imageURL)
            
            guard let image = UIImage(data: data) else {
                print("No se pudo convertir a UIImage")
                return
            }
            
            await MainActor.run {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            
        } catch {
            print("Error al descargar la imagen: \(error.localizedDescription)")
        }
    }

    
}
