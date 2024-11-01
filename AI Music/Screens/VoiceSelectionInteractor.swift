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
}

protocol VoiceSelectionDataStore: AnyObject {
    
}

final class VoiceSelectionInteractor: VoiceSelectionBusinessLogic, VoiceSelectionDataStore {
    
    var presenter: VoiceSelectionPresentationLogic?
    var worker: VoiceSelectionWorkingLogic = VoiceSelectionWorker()
    
    var voices: VoiceSelection.SelectionData.Response = .init(categories: [], voices: [])
    
    func fetchInspirationText() {
        presenter?.presentInspirationText(response: .init(inspirationText: getRandomInspiration()))
    }
    
    func clearInspirationText() {
        presenter?.presentClearInspirationText()
    }
    
    func fetchSelectionData() async {
        Task {
            do {
                let voicesResponse = try await worker.getVoices()
                
                let allVoices = voicesResponse.compactMap {
                                    VoiceSelection.Voice.ViewModel(
                                        imageURL: URL(string: $0.imageURL ?? ""),
                                        title: $0.name ?? "",
                                        isSelected: false,
                                        category: $0.category ?? ""
                                    )
                                }
                
                var uniqueCategories = voicesResponse.map { $0.category }.unique
                uniqueCategories.insert("All", at: 0)
                
                let allCategories = uniqueCategories.compactMap {
                    VoiceSelection.Category.ViewModel(
                        title: $0 ?? "",
                        isSelected: $0 == "All"
                    )
                }
                
                let response = VoiceSelection.SelectionData.Response(categories: allCategories, voices: allVoices)
                self.voices = response
                presenter?.presentSelectionData(response: voices)
            }
            catch {
                // TODO: Handle error
            }
        }
    }
    
    func selectCategory(request: VoiceSelection.SelectionData.Request) {
        let selectedCategory = voices.categories[request.selectedCategoryIndex]
        
        let filteredVoices: [VoiceSelection.Voice.ViewModel]
        if selectedCategory.title == "All" {
            filteredVoices = voices.voices
        } else {
            filteredVoices = voices.voices.filter {
                $0.category == selectedCategory.title
            }
        }
        
        voices.categories = voices.categories.map { category in
            var mutableCategory = category
            mutableCategory.isSelected = (category.title == selectedCategory.title)
            return mutableCategory
        }
        presenter?.presentSelectionData(response: .init(categories: voices.categories, voices: filteredVoices))
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
