//
//  ImageAndDescriptionCell.swift
//  Assignment
//
//  Created by Test on 4/22/18.
//  Copyright © 2018 hungama. All rights reserved.
//

import UIKit

class ImageAndDescriptionCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblPopularity: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblShowFull: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(with model: ImageCellViewModel) {

        lblTitle.text = model.title
        lblPopularity.text = model.popularity
        lblDuration.text = model.duration
        
        if let desc = model.overVeiw {

            switch model.cellHeight {
            case .expended:
                lblDescription.text = desc
                lblShowFull.text = "Show less"
                
            case .collapsed:

                lblDescription.text = String(desc.prefix(150))
                //str[str.index(after: str.index(str.startIndex, offsetBy: 4))]

                lblShowFull.text = "Show full.."
            case .noraml:
                lblShowFull.text = ""
                lblDescription.text = desc

                
            }
        }
        
        
        imgView.__sd_setImage(with:model.imageUrl, placeholderImage: UIImage(named: "placeholderImage"), completed: nil)
}
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
