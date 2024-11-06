//
//  StartMusicGenerateRequest.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 5.11.2024.
//

import Foundation
import Alamofire

struct StartMusicGenerateRequest: Codable {
    let promp: String
    let cover: String
}

extension StartMusicGenerateRequest {
    func toParameters() -> Parameters? {
        guard let data = try? JSONEncoder().encode(self),
              let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
              let parameters = jsonObject as? Parameters else {
            return nil
        }
        return parameters
    }
}
