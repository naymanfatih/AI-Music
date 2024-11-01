//
//  VoiceCollectionViewCell.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 1.11.2024.
//

import UIKit
import SDWebImage

class VoiceCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var voiceImageView: UIImageView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(viewModel: VoiceSelection.Voice.ViewModel) {
        voiceImageView.sd_setImage(with: viewModel.imageURL)
        
        selectedImageView.isHidden = !viewModel.isSelected
        selectedImageView.layer.borderColor = UIColor.primary.cgColor
        selectedImageView.layer.borderWidth = 1
        
        titleLabel.text = viewModel.title
    }
}
