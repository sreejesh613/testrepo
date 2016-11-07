//
//  ULAlertDisplay.swift
//  ULCH
//
//  Created by Sreejesh on 10/26/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import UIKit

class ULAlertDisplay: UIViewController {

    @IBOutlet weak var roomNameLabel: UILabel!
    
    @IBOutlet weak var roomImageView: UIImageView!
    
    @IBOutlet weak var alertImageView: UIImageView!
    
    @IBOutlet weak var roomNameSublabel: UILabel!
    
    @IBOutlet weak var alertDescriptionLabel: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onConfirmBtnClick(_ sender: AnyObject)
    {
        print("ConfirmBtnClicked!")
    }
    
    @IBAction func onBackBtnClick(_ sender: AnyObject)
    {
        print("BackBtnClicked!")
        
        guard (navigationController?.popViewController(animated:true)) != nil
            else
        {
            dismiss(animated: true, completion: nil)
            return
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
