//
//  GeneratingPresenter.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 5.11.2024.
//

import Foundation

protocol GeneratingPresentationLogic: AnyObject {
    func presentVideo()
    func presentGradientView()
}

final class GeneratingPresenter: GeneratingPresentationLogic {
    
    weak var viewController: GeneratingDisplayLogic?
    
    func presentVideo() {
        guard let videoPath = Bundle.main.path(forResource: "generating-video", ofType: "mp4") else {
            print("Video not found.")
            return
        }
        let videoURL = URL(fileURLWithPath: videoPath)
        viewController?.displayVideoPlayer(viewModel: .init(videoURL: videoURL))
    }
    
    func presentGradientView() {
        let viewModel = Generating.Gradient.ViewModel.init()
        viewController?.displayGradientView(viewModel: viewModel)
    }
}
