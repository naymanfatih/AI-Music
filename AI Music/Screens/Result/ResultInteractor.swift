//
//  ResultInteractor.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 6.11.2024.
//

import Foundation

protocol ResultBusinessLogic: AnyObject {
    func fetchUI()
    func switchLoopButton()
    func fetchAudio()
}

protocol ResultDataStore: AnyObject {
    var audioURL: URL? { get set }
    var prompt: String? { get set }
    var voice: String? { get set }
    var coverImageURL: URL? { get set }
}

final class ResultInteractor: ResultBusinessLogic, ResultDataStore {
    var prompt: String?
    var voice: String?
    var coverImageURL: URL?
    var isLooping: Bool = true
    var audioURL: URL?
    
    var presenter: ResultPresentationLogic?
    var worker: ResultWorkingLogic = ResultWorker()
    
    func fetchUI() {
        presenter?.presentUI(
            response: .init(
                title: voice ?? "",
                prompt: prompt ?? "",
                imageURL: coverImageURL ?? URL(string: "")!
            )
        )
    }
    
    func switchLoopButton() {
        isLooping = !isLooping
        presenter?.presentLoopButton(response: .init(isLooping: isLooping))
    }
    
    func fetchAudio() {
        guard let audioURL else { return }
        let downloadTask = URLSession.shared.downloadTask(with: audioURL) { [weak self] localURL, _, error in
            guard let self, let localURL, error == nil else { return }
            presenter?.presentAudio(response: .init(localURL: localURL))
        }
        downloadTask.resume()
    }
}
