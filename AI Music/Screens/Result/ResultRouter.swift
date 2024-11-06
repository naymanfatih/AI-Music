//
//  ResultRouter.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 6.11.2024.
//

import UIKit

protocol ResultRoutingLogic: AnyObject {
    func shareAudioFile(_ localURL: URL?)
    func downloadAudioFile(_ localURL: URL?)
}

protocol ResultDataPassing: AnyObject {
    var dataStore: ResultDataStore? { get }
}

final class ResultRouter: NSObject, ResultRoutingLogic, ResultDataPassing, UIDocumentPickerDelegate {
    
    weak var viewController: ResultViewController?
    var dataStore: ResultDataStore?
    
    func shareAudioFile(_ localURL: URL?) {
        guard let localURL else { return }
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(UUID()).mp3")
        
        do {
            try FileManager.default.copyItem(at: localURL, to: tempURL)
            
            let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
            viewController?.present(activityVC, animated: true)
        } catch {
            // TODO: Error handling
        }
    }
    
    func downloadAudioFile(_ localURL: URL?) {
        guard let localURL else { return }
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(UUID()).mp3")
        
        do {
            try FileManager.default.copyItem(at: localURL, to: tempURL)
            
            let documentPicker = UIDocumentPickerViewController(forExporting: [tempURL])
            documentPicker.delegate = self
            viewController?.present(documentPicker, animated: true, completion: nil)
        } catch {
            // TODO: Error handling
        }
    }
}
