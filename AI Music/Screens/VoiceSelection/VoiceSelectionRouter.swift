//
//  VoiceSelectionRouter.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 31.10.2024.
//

import Foundation

protocol VoiceSelectionRoutingLogic: AnyObject {
    
}

protocol VoiceSelectionDataPassing: class {
    var dataStore: VoiceSelectionDataStore? { get }
}

final class VoiceSelectionRouter: VoiceSelectionRoutingLogic, VoiceSelectionDataPassing {
    
    weak var viewController: VoiceSelectionViewController?
    var dataStore: VoiceSelectionDataStore?
    
}
