//
//  ResultViewController.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 6.11.2024.
//

import UIKit
import AVFAudio

protocol ResultDisplayLogic: AnyObject {
    func displayUI(viewModel: Result.UI.ViewModel)
    func displayLoopButton(viewModel: Result.Loop.ViewModel)
    func displayPlayAudio(viewModel: Result.Audio.ViewModel)
}

final class ResultViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loopButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var promptContainerView: UIView!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
    var interactor: ResultBusinessLogic?
    var router: (ResultRoutingLogic & ResultDataPassing)?
    
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
        let interactor = ResultInteractor()
        let presenter = ResultPresenter()
        let router = ResultRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioPlayer?.pause()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadButton.layer.cornerRadius = 12
        downloadButton.applyGradient(colors: [.primary, .secondary], direction: .topLeftToBottomRight, cornerRadius: 12)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchUI()
        interactor?.switchLoopButton()
        interactor?.fetchAudio()
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func createMoreOptionsMenu() -> UIMenu {
        let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
            self?.router?.shareAudioFile(self?.audioPlayer?.url)
        }
        
        let copyTextAction = UIAction(title: "Copy Text", image: UIImage(systemName: "doc.on.doc")) { [weak self] _ in
            UIPasteboard.general.string = self?.promptLabel.text
        }
        
        return UIMenu(title: "", children: [shareAction, copyTextAction])
    }
    
    private func setupNavigationController() {
        let backButton = UIBarButtonItem(
            image: UIImage(named: "back"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
        
        let moreOptionsButton = UIBarButtonItem(
            image: UIImage(named: "more"),
            menu: createMoreOptionsMenu()
        )
        moreOptionsButton.tintColor = .white
        navigationItem.rightBarButtonItem = moreOptionsButton
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func updateSlider() {
        guard let audioPlayer = audioPlayer else { return }
        slider.value = Float(audioPlayer.currentTime)
        startTimeLabel.text = formatTime(audioPlayer.currentTime)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        audioPlayer?.currentTime = TimeInterval(sender.value)
        startTimeLabel.text = formatTime(audioPlayer?.currentTime ?? 0)
    }
    
    @IBAction func playPause(_ sender: UIButton) {
        guard let audioPlayer else { return }
        
        if audioPlayer.isPlaying {
            audioPlayer.pause()
            playPauseButton.setBackgroundImage(.init(systemName: "play.circle.fill"), for: .normal)
            stopTimer()
        } else {
            audioPlayer.play()
            playPauseButton.setBackgroundImage(.init(systemName: "pause.circle.fill"), for: .normal)
            startTimer()
        }
    }
    
    @IBAction func switchLoop() {
        interactor?.switchLoopButton()
    }
    
    @IBAction func download() {
        router?.downloadAudioFile(audioPlayer?.url)
    }
}

extension ResultViewController: ResultDisplayLogic {
    func displayUI(viewModel: Result.UI.ViewModel) {
        title = viewModel.title
        promptLabel.text = viewModel.prompt
        imageView.sd_setImage(with: viewModel.imageURL)
        
        setupNavigationController()
        imageView.layer.cornerRadius = 12
        promptContainerView.layer.cornerRadius = 12
        
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = .white.withAlphaComponent(0.3)
        
        let thumbImage = UIImage.circle(diameter: 14, color: .white)
        slider.setThumbImage(thumbImage, for: .normal)
        slider.setThumbImage(thumbImage, for: .highlighted)
    }
    
    func displayLoopButton(viewModel: Result.Loop.ViewModel) {
        loopButton.layer.cornerRadius = 8
        loopButton.layer.borderWidth = viewModel.borderWidth
        loopButton.layer.borderColor = viewModel.borderColor
        loopButton.titleLabel?.alpha = viewModel.alpha
        loopButton.imageView?.alpha = viewModel.alpha
        
        guard let audioPlayer else { return }
        
        let currentTime = audioPlayer.currentTime
        audioPlayer.numberOfLoops = viewModel.isLooping ? -1 : 0
        audioPlayer.currentTime = currentTime
    }
    
    func displayPlayAudio(viewModel: Result.Audio.ViewModel) {
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: viewModel.localURL)
            self.audioPlayer?.delegate = self
            DispatchQueue.main.async {
                guard let duration = self.audioPlayer?.duration else { return }
                self.endTimeLabel.text = self.formatTime(duration)
                self.slider.maximumValue = Float(duration)
                self.playPauseButton.setBackgroundImage(.init(systemName: "pause.circle.fill"), for: .normal)
                self.audioPlayer?.play()
                self.startTimer()
            }
        } catch {
            // TODO: Error handling
        }
    }
}

extension ResultViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopTimer()
        slider.value = 0
        startTimeLabel.text = "0:00"
        playPauseButton.setBackgroundImage(.init(systemName: "play.circle.fill"), for: .normal)
    }
}
