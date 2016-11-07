//
//  ULSignUpViewController.swift
//  ULCH
//
//  Created by Smitha on 06/10/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import UIKit


class ULSignUpViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate,UIGestureRecognizerDelegate, CountryPhoneCodePickerDelegate
{
    static let identifier = "ULSignUpViewController"
    
    var globalCheckFlag : Bool = false
    
    
    var countryName: String!
    var CountryPhoneCode: String!
    
    @IBOutlet weak var pickerBkgroundView: UIView!
    @IBOutlet weak var selectedCountryLabel: UILabel!
    @IBOutlet weak var countryPhoneCodePicker: CountryPicker!
    
    
    @IBOutlet weak var countryCodeLabel: UILabel!
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var confirmEmailTxtField: UITextField!
    @IBOutlet weak var pswdTxtField: UITextField!
    @IBOutlet weak var confirmPswdTxtField: UITextField!
    @IBOutlet weak var mobileTxtField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
//    @IBOutlet weak var chooseCountryLabel: UILabel!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    //PRAGMA MARK:-  Initialize
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        countryPhoneCodePicker?.isHidden = true
        pickerBkgroundView.isHidden = true
        
        continueBtn.backgroundColor = returnButtonColor()
        continueBtn.layer.cornerRadius = 5
        changeTextFieldBorders([emailTxtField,confirmEmailTxtField,pswdTxtField,confirmPswdTxtField,mobileTxtField], height:40.0)
        
        selectedCountryLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(tapGesture:)))
        tapGesture.delegate = self
        tapGesture.numberOfTapsRequired = 1
        selectedCountryLabel?.addGestureRecognizer(tapGesture)
        
        let singletap = UITapGestureRecognizer (target: self, action: #selector(handleViewTap(handleTap:)))
        singletap.delegate = self
        singletap.numberOfTapsRequired = 1
        self.view .addGestureRecognizer(singletap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ULSignUpViewController.KeyboardDidShow), name:NSNotification.Name.UIKeyboardDidShow , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ULSignUpViewController.KeyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
    }
        
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func KeyboardDidShow()
    {
        globalCheckFlag = true
    }
    func KeyboardDidHide()
    {
        globalCheckFlag = false
    }
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer)
    {
        print(globalCheckFlag)
        
        if(!(globalCheckFlag == true))
        {
            print("TapGestureDetected!!")
            countryPhoneCodePicker?.isHidden = false
            pickerBkgroundView.isHidden = false
            let locale = Locale.current
            let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String
            
            countryPhoneCodePicker!.countryPhoneCodeDelegate = self
            countryPhoneCodePicker!.setCountry(code)
            
            countryPhoneCodePicker.selectRow(232, inComponent: 0, animated: true)
            
            selectedCountryLabel.text! = "US" + " - " + "United States"
            CountryPhoneCode = "+1"
            countryCodeLabel.text = CountryPhoneCode!
            
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
        selectedCountryLabel.text! = countryCode + " - " + name
        
        
        CountryPhoneCode = phoneCode 
        
        countryCodeLabel.text = CountryPhoneCode!
    }
    
    func handleViewTap(handleTap: UITapGestureRecognizer)
    {
        pickerBkgroundView.isHidden = true
        countryPhoneCodePicker.isHidden = true
    }
    
    func resignAllResponsers()
    {
        if emailTxtField.isFirstResponder
        {
            emailTxtField.resignFirstResponder()
        }
        else if confirmEmailTxtField.isFirstResponder
        {
            confirmEmailTxtField.resignFirstResponder()
        }
        else if pswdTxtField.isFirstResponder
        {
            pswdTxtField.resignFirstResponder()
        }
        else if confirmPswdTxtField.isFirstResponder
        {
            confirmPswdTxtField.resignFirstResponder()
        }
        else if mobileTxtField.isFirstResponder
        {
            mobileTxtField.resignFirstResponder()
        }
        
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
    }

//    func scrollViewDidScroll(_ scrollView: UIScrollView)
//    {
//        if scrollView.contentOffset.x > 0
//        {
//            scrollView.setContentOffset(CGPoint(x: 0,y:0), animated: false)
//        }
//    }
    
    //PRAGMA MARK:-  UIButton Actions
    
    @IBAction func onBackBtnClicked(_ sender: AnyObject)
    {
        resignAllResponsers()
        
        guard (navigationController?.popViewController(animated:true)) != nil
            else
        {
                dismiss(animated: true, completion: nil)
                return
        }
    }
    @IBAction func onContinueBtnClicked(_ sender: AnyObject)
    {
        resignAllResponsers()
        callRegisterUserAPI()
    }
    
    //PRAGMA MARK:-  API Call and Validation
    
    func callRegisterUserAPI()
    {
        let emailID  = emailTxtField.text! as String
        let confirmEmail = confirmEmailTxtField.text! as String
        let pswd =  pswdTxtField.text! as String
        let confirmPswd = confirmPswdTxtField.text! as String
        let mobile = mobileTxtField.text! as String
        
        let isEmailEqual = (emailID == confirmEmail)
        let isPswdEqual = (pswd == confirmPswd)

        if emailID.isEmpty
        {
            alert(appName, message: "Please enter Email.", parentView: self)
            emailTxtField.becomeFirstResponder()
        }
        else if confirmEmail.isEmpty
        {
            alert(appName, message: "Please confirm Email.", parentView: self)
            confirmEmailTxtField.becomeFirstResponder()
        }
        else if isEmailEqual == false
        {
            alert(appName, message: "The email and confirm Email IDs should be same.", parentView: self)
            confirmEmailTxtField.becomeFirstResponder()
        }
        else if pswd.isEmpty
        {
            alert(appName, message: "Please confirm Email.", parentView: self)
            pswdTxtField.becomeFirstResponder()
        }
        else if confirmPswd.isEmpty
        {
            alert(appName, message: "Please confirm Email.", parentView: self)
            confirmPswdTxtField.becomeFirstResponder()
        }
        else if isPswdEqual == false
        {
            alert(appName, message: "The password and confirm password should be same.", parentView: self)
            confirmEmailTxtField.becomeFirstResponder()
        }
        else if mobile.isEmpty
        {
            alert(appName, message: "Please confirm Email.", parentView: self)
            mobileTxtField.becomeFirstResponder()
        }
        else
        {
//            if isEmail(emailID)
//            {
//                ULLoadingActivity.show("Please wait.....", disableUI: true)
//                
//                ULCHManager.sharedInstance.registerUser(emailID, password: pswd, mobile: mobile, success: { (response) in
//                    self.authenticationSuccessHandler(response)
//                }) { (error, message) in
//                    authenticationFailureHandler(error, code: message, parentView: self)
//                }
//            }
//            else
//            {
//                alert(appName, message: "Please enter a valid Email.", parentView: self)
//                emailTxtField.becomeFirstResponder()
//            }
            
            if !(isEmail(emailID))
            {
                alert(appName, message: "Please enter a valid Email.", parentView: self)
                emailTxtField.becomeFirstResponder()
            }
                
            else if !(isPassword(password:pswd))
            {
                alert(appName, message: "Password should contain one special character and at least one letter and number.", parentView: self)
                pswdTxtField.becomeFirstResponder()
            }
                
            else if !(isMobileNumber(mobileNumber: mobile))
            {
                alert(appName, message: "Mobile number should have at least 10 digits.", parentView: self)
                mobileTxtField.becomeFirstResponder()
            }
            else
            {
                UserDefaults.standard.set(mobile, forKey: userPhoneNumber)
                
                UserDefaults.standard.set(emailID, forKey: userEmailKey)
                
                ULLoadingActivity.show("Please wait.....", disableUI: true)
                
                ULCHManager.sharedInstance.registerUser(emailID, password: pswd, mobile: mobile, success:{ (response) in
                    self.authenticationSuccessHandler(response)
                }) { (error, message) in
                    authenticationFailureHandler(error, code: message, parentView: self)
                }
            }
            
        }
    }

    func authenticationSuccessHandler(_ response:AnyObject?)
    {
        let json = response as? [String: AnyObject]
        print(json)
        ULLoadingActivity.hide()
        
        UserDefaults.standard.set(emailTxtField.text! as String, forKey: userEmailKey)
        
        let storyboardobj = UIStoryboard(name:"Main" , bundle: nil)
        let vcobj = storyboardobj.instantiateViewController(withIdentifier: "ULOTPViewController") as! ULOTPViewController
        vcobj.mobileNumber = mobileTxtField.text! as String
        navigationController?.pushViewController(vcobj, animated: true)
    }
    
    //PRAGMA MARK:-  UITextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        pickerBkgroundView.isHidden = true
        countryPhoneCodePicker.isHidden = true
        
        switch textField.tag
        {
        case 0:
            scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
            break
        case 1:
            scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
            break
        case 2:
            scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
            break
        case 3:
            scrollView.setContentOffset(CGPoint(x: 0,y: 30), animated: true)
            break
        case 4:
            scrollView.setContentOffset(CGPoint(x: 0,y: 100), animated: true)
            break
        default:
            scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
            break
        }
    }

 
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        emailTxtField.resignFirstResponder()
        confirmEmailTxtField.resignFirstResponder()
        pswdTxtField.resignFirstResponder()
        confirmPswdTxtField.resignFirstResponder()
        mobileTxtField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        textField.resignFirstResponder();
        return true;
    }
}

