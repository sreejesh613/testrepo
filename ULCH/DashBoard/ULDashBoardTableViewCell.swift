//
//  ULDashBoardTableViewCell.swift
//  ULCH
//
//  Created by Smitha on 10/10/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import UIKit

class ULDashBoardTableViewCell: UITableViewCell {

    static let identifier = "ULDashBoardTableViewCell"
    
    @IBOutlet weak var hubName: UILabel!
    @IBOutlet weak var hubImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
