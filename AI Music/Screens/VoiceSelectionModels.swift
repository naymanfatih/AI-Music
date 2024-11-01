//
//  VoiceSelectionModels.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 31.10.2024.
//

import Foundation

// swiftlint:disable nesting
enum VoiceSelection {
    enum Inspiration {
        struct Request {
            
        }
        
        struct Response {
            let inspirationText: String
        }
        
        struct ViewModel {
            let inspirationText: String
        }
    }
    
    enum SelectionData {
        struct Request {
            let selectedCategoryIndex: Int
        }
        
        struct Response {
            var categories: [Category.ViewModel]
            var voices: [Voice.ViewModel]
        }
        
        struct ViewModel {
            let categories: [Category.ViewModel]
            let voices: [Voice.ViewModel]
        }
    }
    
    enum Category {
        struct ViewModel: Hashable {
            let title: String
            var isSelected: Bool
        }
    }
    
    enum Voice {
        struct ViewModel {
            let imageURL: URL?
            let title: String
            var isSelected: Bool
            let category: String
        }
    }
}
// swiftlint:enable nesting
