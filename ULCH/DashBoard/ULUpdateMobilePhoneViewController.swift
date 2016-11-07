//
//  ULUpdateMobilePhoneViewController.swift
//  ULCH
//
//  Created by Sreejesh on 11/4/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import UIKit

class ULUpdateMobilePhoneViewController: UIViewController,UIGestureRecognizerDelegate,CountryPhoneCodePickerDelegate {

    var countryName: String!
    var CountryPhoneCode: String!
    
    @IBOutlet weak var countryPickerBkGrndView: UIView!
    
//    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var countryPicker: CountryPicker!
    
    @IBOutlet weak var chooseCountrylabel: UILabel!
    @IBOutlet weak var countryPhoneCodeDisplayLabel: UILabel!
    @IBOutlet weak var countryPhoneCodeDisplayLabel2: UILabel!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var confirmMobileNumberTextField: UITextField!
    @IBOutlet weak var sendOtpButton: UIButton!
    @IBOutlet weak var reSendOtpLabel: UILabel!
    @IBOutlet weak var enterOtpTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendOtpButton.backgroundColor = returnButtonColor()
        sendOtpButton.layer.cornerRadius = 5
        changeTextFieldBorders([mobileNumberTextField,confirmMobileNumberTextField,enterOtpTextField], height:40.0)
        
        chooseCountrylabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(tapGesture:)))
        tapGesture.delegate = self
        tapGesture.numberOfTapsRequired = 1
        chooseCountrylabel?.addGestureRecognizer(tapGesture)
        
        let singletap = UITapGestureRecognizer (target: self, action: #selector(handleViewTap(handleTap:)))
        singletap.delegate = self
        singletap.numberOfTapsRequired = 1
        self.view .addGestureRecognizer(singletap)
        
        countryPickerBkGrndView.isHidden = true
        countryPicker.isHidden = true
        
        // Do any additional setup after loading the view.
    }

    @IBAction func onSendOtpButtonAction(_ sender: Any) {
        print("SendOtpButtonClicked!!")
    }
    @IBAction func onsubmitButtonaction(_ sender: Any) {
        print("SubmitButtonClicked!!")
    }
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer)
    {
            print("TapGestureDetected!!")
            countryPicker?.isHidden = false
            countryPickerBkGrndView.isHidden = false
            let locale = Locale.current
            let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String
        
            countryPicker!.countryPhoneCodeDelegate = self
            countryPicker!.setCountry(code)
        
            countryPicker.selectRow(232, inComponent: 0, animated: true)
            
            chooseCountrylabel.text! = "US" + " - " + "United States"
            CountryPhoneCode = "+1"
            countryPhoneCodeDisplayLabel.text = CountryPhoneCode!
            
            //        let transparentButton: UIButton = UIButton(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height-pickerBkgroundView.frame.size.height-120))
            //        transparentButton.backgroundColor = UIColor .clear
            //
            //        transparentButton.addTarget(self, action: #selector(onTransparentButtonClick), for: .touchUpInside)
            //        self.view .addSubview(transparentButton)
            
            //        let singletap = UITapGestureRecognizer (target: self, action: #selector(handleViewTap(handleTap:)))
            //        singletap.delegate = self
            //        singletap.numberOfTapsRequired = 1
            //        self.view .addGestureRecognizer(singletap)
            //self.view .bringSubview(toFront: transparentButton)
    }
    
    //    func onTransparentButtonClick(buttonAction: UIButton)
    //    {
    //        buttonAction.tag = 0
    //        let buttonAction: UIButton = buttonAction
    //        if buttonAction.tag == 0
    //        {
    //            pickerBkgroundView.isHidden = true
    //            countryPhoneCodePicker.isHidden = true
    //            buttonAction.tag = 1
    //            buttonAction .removeFromSuperview()
    //        }
    //    }
    
    
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryCountryWithName name: String, countryCode: String, phoneCode: String)
    {
        //        let singletap = UITapGestureRecognizer (target: self, action: #selector(handleViewTap(handleTap:)))
        //        singletap.delegate = self
        //        singletap.numberOfTapsRequired = 1
        //        self.view .addGestureRecognizer(singletap)
        
        //        selectedCountryLabel.text! = name + " " + countryCode + " " + phoneCode
        chooseCountrylabel.text! = countryCode + " - " + name
        
        
        CountryPhoneCode = phoneCode
        
        countryPhoneCodeDisplayLabel.text = CountryPhoneCode!
    }
    
    func handleViewTap(handleTap: UITapGestureRecognizer)
    {
        print("ViewTapDetected!!")
        countryPickerBkGrndView.isHidden = true
        countryPicker.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
