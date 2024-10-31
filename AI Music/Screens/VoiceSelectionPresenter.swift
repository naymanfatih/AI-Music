//
//  VoiceSelectionPresenter.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 31.10.2024.
//

import Foundation

protocol VoiceSelectionPresentationLogic: AnyObject {
    func presentInspirationView()
    func presentInspirationText(response: VoiceSelection.Case.Response)
    func presentClearInspirationText()
}

final class VoiceSelectionPresenter: VoiceSelectionPresentationLogic {
    
    weak var viewController: VoiceSelectionDisplayLogic?
    
    func presentInspirationView() {
        viewController?.displayInspirationView()
    }
    
    func presentInspirationText(response: VoiceSelection.Case.Response) {
        viewController?.displayInspirationText(viewModel: .init(inspirationText: response.inspirationText))
    }
    
    func presentClearInspirationText() {
        viewController?.displayClearInspirationText()
    }
}
