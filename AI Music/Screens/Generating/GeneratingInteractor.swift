//
//  GeneratingInteractor.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 5.11.2024.
//

import Foundation

protocol GeneratingBusinessLogic: AnyObject {
    func setupLoopVideo()
    func setupGradientView()
    func generateVideo()
}

protocol GeneratingDataStore: AnyObject {
    var generateMusicRequest: StartMusicGenerateRequest? { get set }
    var generatedMusicURL: String? { get set }
}

final class GeneratingInteractor: GeneratingBusinessLogic, GeneratingDataStore {
    var generateMusicRequest: StartMusicGenerateRequest?
    var generatedMusicURL: String?
    
    var presenter: GeneratingPresentationLogic?
    var worker: GeneratingWorkingLogic = GeneratingWorker()
    
    func setupLoopVideo() {
        presenter?.presentVideo()
    }
    
    func setupGradientView() {
        presenter?.presentGradientView()
    }
    
    func generateVideo() {
        guard let generateMusicRequest else { return }
        Task {
            do {
                let generatedMusic = try await worker.getMusicGenerate(request: generateMusicRequest)
                generatedMusicURL = generatedMusic.resultURL
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.presenter?.presentResult()
                }
            }
            catch {
                // TODO: Handle error
            }
        }
    }
}
