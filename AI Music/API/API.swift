//
//  API.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 1.11.2024.
//

import Alamofire
import UIKit

enum API {
    static var baseURL: String {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("BASE_URL not set in Info.plist")
        }
        return baseURL
    }
    
    case getVoices
    case startMusicGenerate(request: StartMusicGenerateRequest)
    
    var url: String {
        switch self {
        case .getVoices:
            return "\(API.baseURL)/getVoice"
        case .startMusicGenerate:
            return "\(API.baseURL)/startMusicGenerate"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getVoices, .startMusicGenerate:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getVoices, .startMusicGenerate:
            return ["Content-Type": "application/json"]
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getVoices:
            return nil
        case let .startMusicGenerate(request):
            return request.toParameters()
        }
    }
}

extension API {
    func fetch<T: Decodable>(responseType: T.Type) async throws -> T {
        return try await AF.request(
            url,
            method: method,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .validate()
        .serializingDecodable(responseType).value
    }
}
