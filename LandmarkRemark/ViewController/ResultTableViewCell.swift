//
//  ResultTableViewCell.swift
//  LandmarkRemark
//
//  Created by Miley Liu on 10/12/18.
//  Copyright © 2018 Simeng Liu. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var placeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
      
        self.noteLabel.numberOfLines = 0
        self.noteLabel.lineBreakMode = .byWordWrapping
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
