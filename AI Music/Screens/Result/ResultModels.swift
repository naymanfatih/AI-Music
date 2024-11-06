//
//  ResultModels.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 6.11.2024.
//

import UIKit

// swiftlint:disable nesting
enum Result {
    
    enum UI {
    
        struct Request {
            
        }
        
        struct Response {
            let title: String
            let prompt: String
            let imageURL: URL
        }
        
        struct ViewModel {
            let title: String
            let prompt: String
            let imageURL: URL
        }
        
    }
    
    enum Loop {
        struct Response {
            let isLooping: Bool
        }
        
        struct ViewModel {
            let isLooping: Bool
            let borderWidth: CGFloat
            let borderColor: CGColor
            let alpha: CGFloat
        }
    }
    
    enum Audio {
        struct ViewModel {
            let localURL: URL
        }
        
        struct Response {
            let localURL: URL
        }
    }
    
}
// swiftlint:enable nesting
