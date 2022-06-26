//
//  CoverItemViewCell.swift
//  ScoresAPP
//
//  Created by Alberto Alegre Bravo on 26/6/22.
//

import UIKit

final class CoverItemViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cover: UIImageView!
    
    
    override func prepareForReuse() {
        cover.image = nil
    }
}
