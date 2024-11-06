//
//  GeneratingRouter.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 5.11.2024.
//

import UIKit

protocol GeneratingRouterDelegate: AnyObject {
    func routeResult(generatedURL: URL?)
}

protocol GeneratingRoutingLogic: AnyObject {
    func dismiss()
    func routeToResult()
}

protocol GeneratingDataPassing: AnyObject {
    var dataStore: GeneratingDataStore? { get }
    var delegate: GeneratingRouterDelegate? { get set }
}

final class GeneratingRouter: GeneratingRoutingLogic, GeneratingDataPassing {
    
    weak var viewController: GeneratingViewController?
    var dataStore: GeneratingDataStore?
    weak var delegate: GeneratingRouterDelegate?
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
    
    func routeToResult() {
        viewController?.dismiss(animated: true, completion: {
            guard let generatedMusicURL = self.dataStore?.generatedMusicURL else { return }
            self.delegate?.routeResult(generatedURL: URL(string: generatedMusicURL))
        })
    }
}
