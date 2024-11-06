//
//  VoiceSelectionRouter.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 31.10.2024.
//

import UIKit

protocol VoiceSelectionRoutingLogic: AnyObject {
    func routeToGenerating()
}

protocol VoiceSelectionDataPassing: AnyObject {
    var dataStore: VoiceSelectionDataStore? { get }
}

final class VoiceSelectionRouter: VoiceSelectionRoutingLogic, VoiceSelectionDataPassing {
    
    weak var viewController: VoiceSelectionViewController?
    var dataStore: VoiceSelectionDataStore?
    
    func routeToGenerating() {
        guard let text = dataStore?.selectedInspirationText, let voice = dataStore?.selectedVoice else { return }
        let generatingVC: GeneratingViewController = UIApplication.getViewController()
        generatingVC.modalPresentationStyle = .fullScreen
        generatingVC.router?.dataStore?.generateMusicRequest = .init(promp: text, cover: voice)
        generatingVC.router?.delegate = self
        viewController?.present(generatingVC, animated: true)
    }
}

extension VoiceSelectionRouter: GeneratingRouterDelegate {
    func routeResult(generatedURL: URL?) {
        guard
            let text = dataStore?.selectedInspirationText,
            let voice = dataStore?.selectedVoice,
            let imageURL = dataStore?.selectedVoiceImageURL,
            let generatedURL else { return }
        
        let resultVC: ResultViewController = UIApplication.getViewController()
        resultVC.router?.dataStore?.prompt = text
        resultVC.router?.dataStore?.voice = voice
        resultVC.router?.dataStore?.coverImageURL = imageURL
        resultVC.router?.dataStore?.audioURL = generatedURL
        viewController?.navigationController?.pushViewController(resultVC, animated: true)
    }
}
