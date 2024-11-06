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
        return try await API.startMusicGenerate(request: request).fetch(responseType: StartMusicGenerateResponse.self)
    }
}
