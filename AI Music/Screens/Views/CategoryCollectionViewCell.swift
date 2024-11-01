//
//  CategoryCollectionViewCell.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 1.11.2024.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(viewModel: VoiceSelection.Category.ViewModel) {
        titleLabel.text = viewModel.title
        
        containerStackView.layer.cornerRadius = 8
        containerStackView.layer.borderColor = UIColor.primary.cgColor
        containerStackView.layer.borderWidth = viewModel.isSelected ? 1 : 0
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = .init(top: 0, left: 24, bottom: 24, right: 0)
    }
}
