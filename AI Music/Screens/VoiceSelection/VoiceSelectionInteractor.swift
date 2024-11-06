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
    func fetchSelectionData()
    func selectCategory(request: VoiceSelection.SelectionData.Request)
    func selectVoice(request: VoiceSelection.SelectionData.Request)
    func checkContinueButton(request: VoiceSelection.Check.Request)
}

protocol VoiceSelectionDataStore: AnyObject {
    var selectedVoice: String? { get set }
    var selectedInspirationText: String? { get set }
    var selectedVoiceImageURL: URL? { get set }
}

final class VoiceSelectionInteractor: VoiceSelectionBusinessLogic, VoiceSelectionDataStore {
    
    var presenter: VoiceSelectionPresentationLogic?
    var worker: VoiceSelectionWorkingLogic = VoiceSelectionWorker()
    
    var allVoices: [VoiceSelection.Voice.ViewModel] = []
    var allCategories: [VoiceSelection.Category.ViewModel] = []
    var filteredVoices: [VoiceSelection.Voice.ViewModel] = []
    var selectedVoice: String?
    var selectedInspirationText: String?
    var selectedVoiceImageURL: URL?
    
    func fetchInspirationText() {
        presenter?.presentInspirationText(response: .init(inspirationText: getRandomInspiration()))
    }
    
    func clearInspirationText() {
        presenter?.presentClearInspirationText()
    }
    
    func fetchSelectionData() {
        Task {
            do {
                let voicesResponse = try await worker.getVoices()
                
                allVoices = voicesResponse.compactMap {
                    VoiceSelection.Voice.ViewModel(
                        imageURL: URL(string: $0.imageURL ?? ""),
                        title: $0.name ?? "",
                        isSelected: false,
                        category: $0.category ?? ""
                    )
                }
                filteredVoices = allVoices
                
                var uniqueCategories = voicesResponse.map { $0.category }.unique
                uniqueCategories.insert("All", at: 0)
                
                allCategories = uniqueCategories.compactMap {
                    VoiceSelection.Category.ViewModel(
                        title: $0 ?? "",
                        isSelected: $0 == "All"
                    )
                }
                
                let response = VoiceSelection.SelectionData.Response(categories: allCategories, voices: allVoices)
                presenter?.presentSelectionData(response: response)
            }
            catch {
                // TODO: Handle error
            }
        }
    }
    
    func selectCategory(request: VoiceSelection.SelectionData.Request) {
        let selectedCategory = allCategories[request.selectedIndex]
        
        if selectedCategory.title == "All" {
            filteredVoices = allVoices
        } else {
            filteredVoices = allVoices.filter {
                $0.category == selectedCategory.title
            }
        }
        
        allCategories = allCategories.map { category in
            var mutableCategory = category
            mutableCategory.isSelected = (category.title == selectedCategory.title)
            return mutableCategory
        }
        presenter?.presentSelectionData(response: .init(categories: allCategories, voices: filteredVoices))
    }
    
    func selectVoice(request: VoiceSelection.SelectionData.Request) {
        filteredVoices = filteredVoices.map { voice in
            var mutableVoice = voice
            mutableVoice.isSelected = false
            return mutableVoice
        }
        
        var selectedVoice = filteredVoices[request.selectedIndex]
        selectedVoice.isSelected = true
        
        self.selectedVoice = selectedVoice.title
        self.selectedVoiceImageURL = selectedVoice.imageURL
        filteredVoices[request.selectedIndex] = selectedVoice
        
        presenter?.presentSelectionData(response: .init(categories: allCategories, voices: filteredVoices))
    }
    
    func checkContinueButton(request: VoiceSelection.Check.Request) {
        let isEmpty = request.inspirationText.isEmpty || request.inspirationText == Constants.VoiceSelection.placeholder
        let isVoiceSelected = filteredVoices.contains {
            $0.isSelected
        }
        selectedInspirationText = request.inspirationText
        presenter?.presentCheckContinueButton(response: .init(textIsEmpty: isEmpty, isVoiceSelected: isVoiceSelected))
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
