//
//  GeneratingInteractor.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 5.11.2024.
//

import Foundation

protocol GeneratingBusinessLogic: AnyObject {
    func fetchVideo()
    func setupGradientView()
}

protocol GeneratingDataStore: AnyObject {
    
}

final class GeneratingInteractor: GeneratingBusinessLogic, GeneratingDataStore {
    
    var presenter: GeneratingPresentationLogic?
    var worker: GeneratingWorkingLogic = GeneratingWorker()
    
    func fetchVideo() {
        presenter?.presentVideo()
    }
    
    func setupGradientView() {
        presenter?.presentGradientView()
    }
}
