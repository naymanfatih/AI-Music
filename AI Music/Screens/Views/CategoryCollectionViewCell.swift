//
//  CategoryCollectionViewCell.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 1.11.2024.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(viewModel: VoiceSelection.Category.ViewModel) {
        titleLabel.text = viewModel.title
        
        containerView.layer.cornerRadius = 8
        containerView.layer.borderColor = UIColor.primary.cgColor
        containerView.layer.borderWidth = viewModel.isSelected ? 1 : 0
    }
}
