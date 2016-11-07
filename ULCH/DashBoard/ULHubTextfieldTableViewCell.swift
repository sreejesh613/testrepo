//
//  ULHubTextfieldTableViewCell.swift
//  ULCH
//
//  Created by Sreejesh on 10/19/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import UIKit

class ULHubTextfieldTableViewCell: UITableViewCell {

    @IBOutlet var cellTextfield: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    open func textFromTextfield(_ text: String)
    {
        
        print(text)
        
        cellTextfield.text = text
        cellTextfield.accessibilityValue = text
    }
    

}
