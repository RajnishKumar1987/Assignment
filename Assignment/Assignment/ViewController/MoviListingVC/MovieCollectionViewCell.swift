//
//  MovieCollectionViewCell.swift
//  Assignment
//
//  Created by Test on 4/21/18.
//  Copyright © 2018 hungama. All rights reserved.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(with model: MoviewCellViewModel) {
        
        imgView.__sd_setImage(with:model.imageUrl, placeholderImage: UIImage(named: "placeHolder"), completed: nil)
        
    }
}
