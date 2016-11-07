//
//  ULSensorListTableViewCell.swift
//  ULCH
//
//  Created by Smitha on 12/10/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import UIKit

class ULSensorListTableViewCell: UITableViewCell {

    static let identifier = "ULSensorListTableViewCell"
    
    @IBOutlet weak var sensorStatus: UIImageView!
    @IBOutlet weak var sensorImg: UIImageView!
    @IBOutlet weak var sensorType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
