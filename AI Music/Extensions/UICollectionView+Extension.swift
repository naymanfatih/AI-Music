//
//  UICollectionView+Extension.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 1.11.2024.
//

import UIKit

extension UICollectionView {
    func register(_ type: UICollectionViewCell.Type) {
        let nib = UINib(nibName: String(describing: type.self), bundle: nil)
        register(nib, forCellWithReuseIdentifier: String(describing: type.self))
    }
    
    func dequeueCell<CellType: UICollectionViewCell>(indexPath: IndexPath) -> CellType {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: CellType.self), for: indexPath) as? CellType
        else {
            fatalError("Wrong type of cell \(CellType.Type.self)")
        }
        return cell
    }
}

