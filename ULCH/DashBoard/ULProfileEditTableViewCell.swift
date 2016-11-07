//
//  ULProfileEditTableViewCell.swift
//  ULCH
//
//  Created by Sreejesh on 10/27/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import UIKit

class ULProfileEditTableViewCell: UITableViewCell
{

    @IBOutlet weak var cellContentNameLabel: UILabel!
    @IBOutlet weak var editProfileContentDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
