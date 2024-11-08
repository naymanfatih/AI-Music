//
//  VoiceSelectionPresenter.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 31.10.2024.
//

import Foundation

protocol VoiceSelectionPresentationLogic: AnyObject {
    func presentInspirationText(response: VoiceSelection.Inspiration.Response)
    func presentClearInspirationText()
    func presentSelectionData(response: VoiceSelection.SelectionData.Response)
    func presentCheckContinueButton(response: VoiceSelection.Check.Response)
}

final class VoiceSelectionPresenter: VoiceSelectionPresentationLogic {
    
    weak var viewController: VoiceSelectionDisplayLogic?
    
    func presentInspirationText(response: VoiceSelection.Inspiration.Response) {
        viewController?.displayInspirationText(viewModel: .init(inspirationText: response.inspirationText))
    }
    
    func presentClearInspirationText() {
        viewController?.displayClearInspirationText()
    }
    
    func presentSelectionData(response: VoiceSelection.SelectionData.Response) {
        let uniqueCategories = response.categories.unique
        viewController?.displaySelectionData(viewModel: .init(categories: uniqueCategories, voices: response.voices))
    }
    
    func presentCheckContinueButton(response: VoiceSelection.Check.Response) {
        viewController?.displayCheckContinueButton(viewModel: .init(isVoiceSelected: response.isVoiceSelected, textIsEmpty: response.textIsEmpty))
    }
}
