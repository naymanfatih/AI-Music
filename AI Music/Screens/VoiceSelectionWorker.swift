//
//  VoiceSelectionWorker.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 31.10.2024.
//

import Alamofire
import Foundation

protocol VoiceSelectionWorkingLogic: AnyObject {
    func getVoices() async throws -> [Voice]
}

final class VoiceSelectionWorker: VoiceSelectionWorkingLogic {
    func getVoices() async throws -> [Voice] {
        let url = API.getVoices.url
        let data = try await AF.request(url, method: .post)
            .validate()
            .serializingDecodable(GetVoiceResponse.self).value
        return data.objects ?? []
    }
}
