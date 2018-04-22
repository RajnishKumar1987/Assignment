//
//  DescriptionTableViewCell.swift
//  Assignment
//
//  Created by Test on 4/22/18.
//  Copyright © 2018 hungama. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var lblKey: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    func configureCell(with model: HeaderDescriptionCellViewModel) {
        
        lblKey.text = model.headerText
        lblValue.text = model.descriptionText
    }}
