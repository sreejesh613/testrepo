//
//  ULLocListTableViewCell.swift
//  ULCH
//
//  Created by Smitha on 17/10/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import UIKit

@objc protocol ULLocListTableViewCellDelegate
{
    @objc optional func didAddedOtherLocName(_ text : String)
}


class ULLocListTableViewCell: UITableViewCell {

    static let identifier = "ULLocListTableViewCell"
    
    @IBOutlet weak var locNameLbl: UILabel!
    @IBOutlet weak var locImageView: UIImageView!
    @IBOutlet weak var locTextField: UITextField!
    @IBOutlet weak var checkImgView: UIImageView!
    var delegate:ULLocListTableViewCellDelegate! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        delegate!.didAddedOtherLocName!(textField.text!)
        textField.resignFirstResponder()
        return true
    }

}
