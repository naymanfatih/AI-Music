//
//  GeneratingViewController.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 5.11.2024.
//

import UIKit
import AVKit

protocol GeneratingDisplayLogic: AnyObject {
    func displayVideoPlayer(viewModel: Generating.Video.ViewModel)
    func displayGradientView(viewModel: Generating.Gradient.ViewModel)
}

final class GeneratingViewController: UIViewController {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var videoView: UIView!
    private var playerLooper: AVPlayerLooper?
    
    var interactor: GeneratingBusinessLogic?
    var router: (GeneratingRoutingLogic & GeneratingDataPassing)?
    
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
        let interactor = GeneratingInteractor()
        let presenter = GeneratingPresenter()
        let router = GeneratingRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor?.fetchVideo()
        interactor?.setupGradientView()
    }
    
    @IBAction func close() {
        router?.dismiss()
    }
}

extension GeneratingViewController: GeneratingDisplayLogic {
    func displayVideoPlayer(viewModel: Generating.Video.ViewModel) {
        videoView.layer.cornerRadius = videoView.frame.height / 2
        videoView.clipsToBounds = true
        
        let videoURL = viewModel.videoURL
        let playerItem = AVPlayerItem(url: videoURL)
        
        let player = AVQueuePlayer(playerItem: playerItem)
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(playerLayer)
        
        player.play()
    }
    
    func displayGradientView(viewModel: Generating.Gradient.ViewModel) {
        gradientView.applyRadialGradient(
            leftColor: viewModel.leftColor,
            rightColor: viewModel.rightColor
        )
    }
}
