//
//  GetVoiceResponse.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 1.11.2024.
//

import Foundation

struct GetVoiceResponse: Codable {
    let objects: [Voice]?
}

struct Voice: Codable {
    let imageURL: String?
    let category: String?
    let order: Int?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "imageUrl"
        case category, order, name
    }
}
