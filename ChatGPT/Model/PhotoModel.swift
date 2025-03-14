//
//  PhotoModel.swift
//  ChatGPT
//
//  Created by Danilo Osorio on 13/03/25.
//

import Foundation

struct DataResponse: Decodable {
    let url: String
}

struct ModelResponse: Decodable {
    let data: [DataResponse]
}
