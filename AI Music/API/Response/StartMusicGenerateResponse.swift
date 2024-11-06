//
//  StartMusicGenerateResponse.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 5.11.2024.
//

struct StartMusicGenerateResponse: Codable {
    let resultURL: String?

    enum CodingKeys: String, CodingKey {
        case resultURL = "resultUrl"
    }
}
