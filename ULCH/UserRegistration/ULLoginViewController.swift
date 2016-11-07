//
//  ULLoginViewController.swift
//  
//
//  Created by Sreejesh on 10/10/16.
//
//

import UIKit

class ULLoginViewController: UIViewController,UITextFieldDelegate,UIGestureRecognizerDelegate
{
    static let identifier = "ULLoginViewController"
    
    var emailId: String = String()
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwdTextField: UITextField!
    @IBOutlet var forgotPasswordLabel: UILabel!
    @IBOutlet var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBtn.backgroundColor = returnButtonColor()
        loginBtn.layer.cornerRadius = 5
        
        changeTextFieldBorders([emailTextField,passwdTextField], height: 40.0)
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(ULLoginViewController.forgotPasswordLabelTapped))
        
        labelTap.numberOfTapsRequired = 1
        
        forgotPasswordLabel.addGestureRecognizer(labelTap)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func forgotPasswordLabelTapped()
    {
        //print("LabelTapDetected!")
        //presentviewCommon(ULForgotPasswordViewController.identifier, parentView:self)
        
        guard let VC = storyboard?.instantiateViewController(withIdentifier: "ULForgotPasswordViewController") else
        {
            print("ForgotPasswordVC Not Found!")
            return
        }
        //navigationController?.pushViewController(VC, animated: true)
        navigationController?.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func onLoginBtnClick(_ sender: AnyObject)
    {
        resignAllResponders()
        
        if (emailTextField.text?.isEmpty)!
        {
            alert(appName, message: "Please enter a valid email address.", parentView: self)
        }
        else if (passwdTextField.text?.isEmpty)!
        {
            alert(appName, message: "Please enter password.", parentView: self)
        }
        else
        {
            callLoginUserApi()
        }
    }
    
    @IBAction func onBackBtnClick(_ sender: AnyObject)
    {
        resignAllResponders()
        
        guard (navigationController?.popViewController(animated:true)) != nil
            else
        {
            dismiss(animated: true, completion: nil)
            return
        }
    }
    
    //PRAGMA MARK:-  API Call and Validation
    
    func callLoginUserApi()
    {
        ULLoadingActivity.show("Please wait.....", disableUI: true)
        
        emailId = emailTextField.text! as String
        let password = passwdTextField.text! as String
        
        var FCMKey = String()
        
        if UserDefaults.standard.object(forKey: FCMTokenKey) != nil
        {
            FCMKey = UserDefaults.standard.object(forKey: FCMTokenKey) as! String
            print(FCMKey)
        }
        else
        {
            FCMKey = "testKey"
        }
        
        if FCMKey.isEmpty
        {
            FCMKey = "testKey"
        }
        
        ULCHManager.sharedInstance.loginUser(emailId, password: password, snsId: FCMKey, success: { (response) in self.authenticationSuccessHandler(response)}) { (error, message)in authenticationFailureHandler(error, code: message, parentView: self) }

    }
    
        func authenticationSuccessHandler(_ response:AnyObject?)
        {
            let json = response as? [String: AnyObject]
            
            print("json response received: \(json)")
            
            let tokenString = json![ULCommon.tokenKey] as! String
            
            print("tokenString: \(tokenString)")
            
            UserDefaults.standard.set(emailId, forKey: userEmailKey)
            
            UserDefaults.standard.set(tokenString, forKey: userTokenKey)
            
            ULLoadingActivity.hide()
            
            let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DashboardVCNavigation")
            self.present(vc, animated: true, completion: nil)
        }

    
    func resignAllResponders()
    {
        if emailTextField.isFirstResponder
        {
            emailTextField.resignFirstResponder()
        }
        if passwdTextField.isFirstResponder
        {
            passwdTextField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        emailTextField.keyboardType = UIKeyboardType.emailAddress
        passwdTextField.keyboardType = UIKeyboardType.asciiCapable
    }
}
