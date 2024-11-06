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
        return try await API.getVoices.fetch(responseType: GetVoiceResponse.self).objects ?? []
    }
}
