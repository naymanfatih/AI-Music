//
//  GeneratingModels.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 5.11.2024.
//

import UIKit

// swiftlint:disable nesting
enum Generating {
    
    enum Video {
        
        struct Request {
            
        }
        
        struct Response {
            
        }
        
        struct ViewModel {
            let videoURL: URL
        }
        
    }
    
    enum Gradient {
        struct ViewModel {
            let leftColor: UIColor = UIColor.primary.withAlphaComponent(0.4)
            let rightColor: UIColor = UIColor.secondary.withAlphaComponent(0.4)
        }
    }
    
}
// swiftlint:enable nesting
