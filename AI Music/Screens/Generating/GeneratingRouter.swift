//
//  GeneratingRouter.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 5.11.2024.
//

import Foundation

protocol GeneratingRoutingLogic: AnyObject {
    func dismiss()
}

protocol GeneratingDataPassing: AnyObject {
    var dataStore: GeneratingDataStore? { get }
}

final class GeneratingRouter: GeneratingRoutingLogic, GeneratingDataPassing {
    
    weak var viewController: GeneratingViewController?
    var dataStore: GeneratingDataStore?
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
