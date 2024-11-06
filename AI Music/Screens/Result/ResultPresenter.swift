//
//  ResultPresenter.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 6.11.2024.
//

import UIKit

protocol ResultPresentationLogic: AnyObject {
    func presentUI(response: Result.UI.Response)
    func presentLoopButton(response: Result.Loop.Response)
    func presentAudio(response: Result.Audio.Response)
}

final class ResultPresenter: ResultPresentationLogic {
    
    weak var viewController: ResultDisplayLogic?
    
    func presentUI(response: Result.UI.Response) {
        viewController?.displayUI(viewModel: .init(title: response.title, prompt: response.prompt, imageURL: response.imageURL))
    }
    
    func presentLoopButton(response: Result.Loop.Response) {
        let viewModel: Result.Loop.ViewModel = .init(
            isLooping: response.isLooping,
            borderWidth: response.isLooping ? 1 : 0,
            borderColor: UIColor.primary.cgColor,
            alpha: response.isLooping ? 1 : 0.7
        )
        viewController?.displayLoopButton(viewModel: viewModel)
    }
    
    func presentAudio(response: Result.Audio.Response) {
        viewController?.displayPlayAudio(viewModel: .init(localURL: response.localURL))
    }
}
