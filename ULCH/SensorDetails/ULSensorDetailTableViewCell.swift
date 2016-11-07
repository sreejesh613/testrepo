//
//  ULSensorDetailTableViewCell.swift
//  ULCH
//
//  Created by Smitha on 14/10/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import UIKit

class ULSensorDetailTableViewCell: UITableViewCell {

    static let identifier = "ULSensorDetailTableViewCell"
    
    @IBOutlet weak var valueTxtField: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
