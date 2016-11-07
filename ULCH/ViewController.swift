//
//  ViewController.swift
//  ULCH
//
//  Created by Smitha on 04/10/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    static let identifier = "ViewController"
    
    @IBOutlet weak var selectedCountryLabel: UILabel?
    @IBOutlet weak var countryPhoneCodePicker: CountryPicker?
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    //PRAGMA MARK:-  Initialize
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //PRAGMA MARK:-  UIButton Actions
    @IBAction func onLoginBtnClicked(_ sender: AnyObject)
    {
        guard let VC = storyboard?.instantiateViewController(withIdentifier: "ULLoginViewController") else
        {
            print("LoginVC Not Found!")
            return
        }
        //navigationController?.present(VC, animated: true, completion:nil)
        navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func onSignupBtnClicked(_ sender: AnyObject)
    {
        guard let VC = storyboard?.instantiateViewController(withIdentifier: "ULSignUpViewController")
            else
        {
            print("ViewController Not Found!")
            return
        }
        navigationController?.pushViewController(VC, animated: true)
    }

}

