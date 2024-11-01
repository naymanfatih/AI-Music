//
//  VoiceSelectionInteractor.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 31.10.2024.
//

import Foundation

protocol VoiceSelectionBusinessLogic: AnyObject {
    func fetchInspirationText()
    func clearInspirationText()
    func fetchSelectionData ()
}

protocol VoiceSelectionDataStore: AnyObject {
    
}

final class VoiceSelectionInteractor: VoiceSelectionBusinessLogic, VoiceSelectionDataStore {
    
    var presenter: VoiceSelectionPresentationLogic?
    var worker: VoiceSelectionWorkingLogic = VoiceSelectionWorker()
    
    func fetchInspirationText() {
        presenter?.presentInspirationText(response: .init(inspirationText: getRandomInspiration()))
    }
    
    func clearInspirationText() {
        presenter?.presentClearInspirationText()
    }
    
    func fetchSelectionData() {
        <#code#>
    }
    
    private func getRandomInspiration() -> String {
        let inspirations = [
            "an atmospheric sleep soundscape with distant celestial melodies, creating a sense of floating in a calm night sky",
            "a dreamy music box melody that transports listeners to a serene and restful dreamland",
            "a calming meditation piece with the sounds of falling rain, distant thunder, and gentle wind chimes",
            "an evolving ambient soundscape that progresses through the changing seasons, from the blossoming of spring to the hush of winter",
            "a folk rock song that combines acoustic instruments with rock elements, telling a storytelling narrative",
            "a progressive rock epic with intricate instrumental sections, dynamic shifts, and thought-provoking melodies"
        ]
        return inspirations.randomElement() ?? ""
    }
}
