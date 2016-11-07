//
//  ULHubSettingsTableViewCell.swift
//  ULCH
//
//  Created by Sreejesh on 10/18/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import UIKit

class ULHubSettingsTableViewCell: UITableViewCell
{
    static let identifier = "ULHubSettingsTableViewCell"
    
    @IBOutlet weak var settingsLabel: UILabel?
    
    override func awakeFromNib(){
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
