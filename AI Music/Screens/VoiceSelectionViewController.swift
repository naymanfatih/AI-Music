//
//  VoiceSelectionViewController.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 31.10.2024.
//

import UIKit

protocol VoiceSelectionDisplayLogic: AnyObject {
    func displayInspirationText(viewModel: VoiceSelection.Case.ViewModel)
    func displayClearInspirationText()
}

final class VoiceSelectionViewController: UIViewController {
    @IBOutlet weak var inspirationView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var inspirationButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    var interactor: VoiceSelectionBusinessLogic?
    var router: (VoiceSelectionRoutingLogic & VoiceSelectionDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = VoiceSelectionInteractor()
        let presenter = VoiceSelectionPresenter()
        let router = VoiceSelectionRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTapGesture()
        configurePlaceholder()
    }
    
    @IBAction func getInspiration() {
        interactor?.fetchInspirationText()
    }
    
    @IBAction func clearInspiration() {
        interactor?.clearInspirationText()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func configurePlaceholder() {
        textView.text = Constants.VoiceSelection.placeholder
        textView.textColor = .white.withAlphaComponent(0.5)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupUI() {
        title = Constants.VoiceSelection.title

        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: UIFont.boldSystemFont(ofSize: 15)
        ]
        let title = Constants.VoiceSelection.inspirationButtonTitle
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        inspirationButton.setAttributedTitle(attributedTitle, for: .normal)
        
        inspirationView.layer.cornerRadius = 12
        clearButton.isHidden = true
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension VoiceSelectionViewController: VoiceSelectionDisplayLogic {
    func displayInspirationText(viewModel: VoiceSelection.Case.ViewModel) {
        textView.text = viewModel.inspirationText
        textView.textColor = .white
        clearButton.isHidden = false
    }
    
    func displayClearInspirationText() {
        configurePlaceholder()
        textView.resignFirstResponder()
        clearButton.isHidden = true
    }
}

extension VoiceSelectionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Constants.VoiceSelection.placeholder {
            textView.text = ""
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            configurePlaceholder()
            clearButton.isHidden = true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        clearButton.isHidden = textView.text.isEmpty
    }
}
