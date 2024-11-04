//
//  VoiceSelectionViewController.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 31.10.2024.
//

import UIKit

protocol VoiceSelectionDisplayLogic: AnyObject {
    func displayInspirationText(viewModel: VoiceSelection.Inspiration.ViewModel)
    func displayClearInspirationText()
    func displaySelectionData(viewModel: VoiceSelection.SelectionData.ViewModel)
    func displayCheckContinueButton(viewModel: VoiceSelection.Check.ViewModel)
}

final class VoiceSelectionViewController: UIViewController {
    @IBOutlet weak var inspirationView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var inspirationButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var voiceCollectionView: UICollectionView!
    @IBOutlet weak var continueButtonContainerView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    
    var interactor: VoiceSelectionBusinessLogic?
    var router: (VoiceSelectionRoutingLogic & VoiceSelectionDataPassing)?
    
    var categories: [VoiceSelection.Category.ViewModel] = []
    var voices: [VoiceSelection.Voice.ViewModel] = []
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        continueButtonContainerView.applyGradient(colors: [.black.withAlphaComponent(0.0), .black], direction: .topToBottom)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTapGesture()
        configurePlaceholder()
        registerCells()
        interactor?.fetchSelectionData()
    }
    
    @IBAction func getInspiration() {
        interactor?.fetchInspirationText()
    }
    
    @IBAction func clearInspiration() {
        interactor?.clearInspirationText()
    }
    
    @IBAction func continue_() {
        print("DEVAM")
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
        
        let categoryLayout = UICollectionViewFlowLayout()
        categoryLayout.scrollDirection = .horizontal
        categoryCollectionView.collectionViewLayout = categoryLayout
        
        let voiceLayout = UICollectionViewFlowLayout()
        voiceLayout.scrollDirection = .vertical
        voiceCollectionView.collectionViewLayout = voiceLayout
        
        continueButton.layer.cornerRadius = 12
        continueButton.setTitleColor(.white.withAlphaComponent(0.5), for: .disabled)
    }
    
    private func registerCells() {
        categoryCollectionView.register(CategoryCollectionViewCell.self)
        voiceCollectionView.register(VoiceCollectionViewCell.self)
    }
}

extension VoiceSelectionViewController: VoiceSelectionDisplayLogic {
    func displayInspirationText(viewModel: VoiceSelection.Inspiration.ViewModel) {
        textView.text = viewModel.inspirationText
        textView.textColor = .white
        clearButton.isHidden = false
        interactor?.checkContinueButton(request: .init(inspirationText: textView.text))
    }
    
    func displayClearInspirationText() {
        configurePlaceholder()
        textView.resignFirstResponder()
        clearButton.isHidden = true
        interactor?.checkContinueButton(request: .init(inspirationText: textView.text))
    }
    
    func displaySelectionData(viewModel: VoiceSelection.SelectionData.ViewModel) {
        voices = viewModel.voices
        categories = viewModel.categories
        
        DispatchQueue.main.async {
            self.categoryCollectionView.reloadData()
            self.voiceCollectionView.reloadData()
        }
    }
    
    func displayCheckContinueButton(viewModel: VoiceSelection.Check.ViewModel) {
        let isEnabled = !viewModel.textIsEmpty && viewModel.isVoiceSelected
        continueButton.isEnabled = isEnabled
        
        if isEnabled {
            continueButton.applyGradient(colors: [.primary, .secondary], direction: .topLeftToBottomRight, cornerRadius: 12)
        } else {
            continueButton.removeGradientLayers()
            continueButton.backgroundColor = .continueDisabled
        }
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
        interactor?.checkContinueButton(request: .init(inspirationText: textView.text))
    }
}

extension VoiceSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categories.count
        } else if collectionView == voiceCollectionView {
            return voices.count
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell: CategoryCollectionViewCell = collectionView.dequeueCell(indexPath: indexPath)
            cell.configure(viewModel: categories[indexPath.item])
            return cell
        } else if collectionView == voiceCollectionView {
            let cell: VoiceCollectionViewCell = collectionView.dequeueCell(indexPath: indexPath)
            cell.configure(viewModel: voices[indexPath.item])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case categoryCollectionView:
            interactor?.selectCategory(request: .init(selectedIndex: indexPath.item))
        case voiceCollectionView:
            interactor?.selectVoice(request: .init(selectedIndex: indexPath.item))
            interactor?.checkContinueButton(request: .init(inspirationText: textView.text))
        default:
            break
        }
    }
}

extension VoiceSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            let title = categories[indexPath.item].title
            let font = UIFont.systemFont(ofSize: 15, weight: .medium)
            let width = title.size(withAttributes: [.font: font]).width
            return CGSize(width: width + 48, height: 42)
        } else if collectionView == voiceCollectionView {
            let itemsPerRow: CGFloat = 3
            let padding: CGFloat = 16
            let interItemSpacing: CGFloat = 12
            
            let availableWidth = collectionView.frame.width - (padding * 2) - (interItemSpacing * (itemsPerRow - 1))
            let itemWidth = availableWidth / itemsPerRow
            return CGSize(width: itemWidth, height: itemWidth + 30)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case categoryCollectionView:
            return 8
        case voiceCollectionView:
            return 12
        default:
            break
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case categoryCollectionView:
            return 0
        case voiceCollectionView:
            return 20
        default:
            break
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return UIEdgeInsets(top: 0, left: 16, bottom: 110, right: 16)
    }
}
