//
//  ULForgotPasswordViewController.swift
//  ULCH
//
//  Created by Sreejesh on 10/10/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import UIKit

class ULForgotPasswordViewController: UIViewController,UITextFieldDelegate
{
    static let identifier = "ULForgotPasswordViewController"
    
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var mobileNumberTextField: UITextField!
    
    @IBOutlet var otpSendButton: UIButton!
    
    @IBOutlet weak var reSendOtpButton: UIButton!
    
    
    @IBOutlet weak var enterOtpTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        otpSendButton.backgroundColor = returnButtonColor()
        otpSendButton.layer.cornerRadius = 5
        
        submitButton.backgroundColor = returnButtonColor()
        submitButton.layer.cornerRadius = 5
        
        changeTextFieldBorders([newPasswordTextField,confirmPasswordTextField,mobileNumberTextField,enterOtpTextField], height: 40.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onOtpsendButtonClick(_ sender: AnyObject)
    {
        print("OTP to reset your password has sent to the moile number you are given")
    }
    
    @IBAction func onResentOtpButtonClick(_ sender: AnyObject)
    {
        print("Resend OtpButtonClicked!!")
    }
    
    @IBAction func onsubmitButtonClick(_ sender: AnyObject)
    {
        print("Submit button clicked to reset the password")
    }
    
    @IBAction func onBackBtnClick(_ sender: AnyObject)
    {
        resignAllResponders()
        
        guard (navigationController?.popViewController(animated: true)) != nil else
        {
            dismiss(animated: true, completion: nil)
            return
        }
    }
    
    func resignAllResponders()
    {
        if newPasswordTextField.isFirstResponder
        {
            newPasswordTextField.resignFirstResponder()
        }
        else if confirmPasswordTextField.isFirstResponder
        {
            confirmPasswordTextField.resignFirstResponder()
        }
        else if mobileNumberTextField.isFirstResponder
        {
            mobileNumberTextField.resignFirstResponder()
        }
        else if enterOtpTextField.isFirstResponder
        {
            enterOtpTextField.resignFirstResponder()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        newPasswordTextField.keyboardType = UIKeyboardType.default
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
