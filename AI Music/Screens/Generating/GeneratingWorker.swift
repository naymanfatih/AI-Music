//
//  GeneratingWorker.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 5.11.2024.
//

import Alamofire
import Foundation

protocol GeneratingWorkingLogic: AnyObject {
    func getMusicGenerate(request: StartMusicGenerateRequest) async throws -> StartMusicGenerateResponse
}

final class GeneratingWorker: GeneratingWorkingLogic {
    func getMusicGenerate(request: StartMusicGenerateRequest) async throws -> StartMusicGenerateResponse {
        let url = API.startMusicGenerate(request: request).url
        let data = try await AF.request(url, method: .post)
            .validate()
            .serializingDecodable(StartMusicGenerateResponse.self).value
        return data
    }
}
