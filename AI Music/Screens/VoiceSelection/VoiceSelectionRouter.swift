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
        let generatingVC: GeneratingViewController = UIApplication.getViewController()
        viewController?.present(generatingVC, animated: true)
    }
}
