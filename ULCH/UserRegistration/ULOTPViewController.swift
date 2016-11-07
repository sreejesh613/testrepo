//
//  ULOTPViewController.swift
//  ULCH
//
//  Created by Smitha on 07/10/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import UIKit

class ULOTPViewController: UIViewController,UITextFieldDelegate
{
    static let identifier = "ULOTPViewController"
    
    @IBOutlet weak var OTPTextField: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    var mobileNumber : String = String()
    
    //PRAGMA MARK:-  Initialize
    override func viewDidLoad() {
        super.viewDidLoad()

        doneBtn.backgroundColor = returnButtonColor()
        doneBtn.layer.cornerRadius = 5
        
        changeTextFieldBorders([OTPTextField], height:40.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resignAllResponsers()
    {
        if OTPTextField.isFirstResponder
        {
            OTPTextField.resignFirstResponder()
        }
    }
    
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

    @IBAction func onDoneBtnClicked(_ sender: AnyObject)
    {
        resignAllResponsers()
        callConfirmRegistrationAPI()
    }
    
    @IBAction func onReSendOTPClicked(_ sender: AnyObject)
    {
        ULLoadingActivity.show("Please wait.....", disableUI: true)
        
        ULCHManager.sharedInstance.resendOTP(ULCommon.getEmail(),mobile : mobileNumber, success: { (response) in
            self.authenticationSuccessHandlerResendOTP(response)
        }) { (error, message) in
            authenticationFailureHandler(error, code: message, parentView: self)
        }

    }

    //PRAGMA MARK:-  API Call and Validation
    func callConfirmRegistrationAPI()
    {
        let OTPCode  = OTPTextField.text! as String
        
        if OTPCode.isEmpty
        {
            alert(appName, message: "Please enter OTP recevied via text message/sms.", parentView: self)
            OTPTextField.becomeFirstResponder()
        }
        else
        {
            ULLoadingActivity.show("Please wait.....", disableUI: true)
            
            var FCMKey = String()
            if (UserDefaults.standard.object(forKey: FCMTokenKey) != nil)
            {
                FCMKey = UserDefaults.standard.object(forKey: FCMTokenKey) as! String
            }
            else
            {
                FCMKey = "testKey"
            }
                
            if FCMKey.isEmpty
            {
                FCMKey = "testKey"
            }
            
            ULCHManager.sharedInstance.confirmUserRegistration(OTPCode, snsId : FCMKey, mobile : mobileNumber, success: { (response) in
                self.authenticationSuccessHandler(response)
            }) { (error, message) in
                authenticationFailureHandler(error, code: message, parentView: self)
            }
        }
    }
    
    func authenticationSuccessHandler(_ response:AnyObject?)
    {
        let json = response as? [String: AnyObject]
        print(json)
        ULLoadingActivity.hide()
        
        let tokenString = json![ULCommon.tokenKey] as! String
        UserDefaults.standard.set(tokenString, forKey: userTokenKey)
        
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DashboardVCNavigation")
        self.present(vc, animated: true, completion: nil)
    }
    
    func authenticationSuccessHandlerResendOTP(_ response:AnyObject?)
    {
        let json = response as? [String: AnyObject]
        print(json)
        ULLoadingActivity.hide()
        
    }
    
    //PRAGMA MARK:-  UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder();
        return true;
    }

}
