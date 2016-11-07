//
//  ULConstants.swift
//  ULCH
//
//  Created by Smitha on 06/10/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let appName = "ULCH"
let FCMTokenKey = "FCMKey"
let userEmailKey = "EmailID"

let userPhoneNumber = "PhoneNumber"

let userTokenKey = "token"
let isFirstTimeKey = "isFirstTime"

let apiErrorMessageKey = "errorMessage"
let apiErrorCodeKey = "errorCode"
let apiDeveloperFailureMessage = "developerMsg"

func changeTextFieldBorders(_ textFieldArray : NSArray, height:CGFloat)
{
    for textFieldCount in 0 ..< textFieldArray.count
    {
        (textFieldArray[textFieldCount] as AnyObject).layer.cornerRadius = 8.0
        (textFieldArray[textFieldCount] as AnyObject).layer.borderWidth = 1.0
        
        (textFieldArray[textFieldCount] as AnyObject).layer.borderColor = UIColor.white.cgColor;
        let border = CALayer()
        let borderWidth = CGFloat(3.0)
        border.borderColor = UIColor.lightGray.cgColor;
        border.frame = CGRect(x: 0, y: height - borderWidth, width: (textFieldArray[textFieldCount] as AnyObject).frame.size.width, height: height)
        border.borderWidth = borderWidth;
        (textFieldArray[textFieldCount] as AnyObject).layer.addSublayer(border)
        (textFieldArray[textFieldCount] as AnyObject).layer.masksToBounds = true
    }
}

func alert(_ title : String, message : String, parentView: UIViewController)
{
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    parentView.present(alertController, animated: true, completion: nil)
    let delay = 2.0 * Double(NSEC_PER_SEC)
    let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: time, execute: {
        alertController.dismiss(animated: true, completion: nil)
    })
}

func authenticationFailureHandler(_ error: NSError?, code: String, parentView: UIViewController)
{
    ULLoadingActivity.hide()
    print("Failure")
    print("message = \(code) andError = \(error?.localizedDescription) ")
    if !ULRequestManager.sharedInstance.validConnection() {
        ULErrorManager.sharedInstance.noNetworkConnection(parentView)
    }
//    else if code.isEmpty == false {
//        ULErrorManager.sharedInstance.mapErorMessageToErrorCode(code)
//    }
    else if code.isEmpty == true
    {
        alert("Error", message: "\(error?.localizedDescription) ", parentView: parentView)
    }
}

func returnButtonColor() -> UIColor
{
    var buttonColor : UIColor = UIColor()
    buttonColor = UIColor (red: 213.0/255.0, green: 222.0/255.0, blue: 80/255.0, alpha: 1.0)
    return buttonColor
}

func isEmail(_ email:String) -> Bool
{
    let regex = try? NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: .caseInsensitive)
    return regex?.firstMatch(in: email, options: [], range: NSMakeRange(0, email.characters.count)) != nil
}

func isPassword(password:String) -> Bool
{
    //    let regex = try? NSRegularExpression(pattern: "^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$", options: .caseInsensitive)
    
//    let regex = try? NSRegularExpression(pattern: "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{3}$", options: .caseInsensitive)
    
    let regex = try? NSRegularExpression(pattern: "(?=^.{4,}$)(?=.*[!@#$%^&*]+)(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$", options: .caseInsensitive)
    
    print(regex)
    
    print(password)

    return regex?.firstMatch(in: password, options: [], range: NSMakeRange(0, password.characters.count)) != nil
}

func isMobileNumber(mobileNumber:String) -> Bool
{
    let phoneRegex = "^\\d{10}$"
    //let phoneRegex = "^\\d[0 - 9] {1,5}$"
    print(phoneRegex)
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
    print(phoneTest)
    let result =  phoneTest.evaluate(with: mobileNumber)
    print(result)
    return result
}

func presentviewCommon(_ viewName : String, parentView: UIViewController)
{
    let storyboardobj = UIStoryboard(name:getStoryBoardName(viewName),bundle: nil)
    let vcobj = storyboardobj.instantiateViewController(withIdentifier: viewName) as UIViewController
    parentView.present(vcobj, animated: true, completion: nil)
    
}

func getStoryBoardName(_ viewName: String) -> String
{
    var storyBoardName : String = ""
    switch viewName {
    case ViewController.identifier, ULSignUpViewController.identifier,ULOTPViewController.identifier:
        storyBoardName = "Main"
        break
    case ULDashBoardViewController.identifier:
        storyBoardName = "Dashboard"
        break
        
    default:
        break;
    }
    return storyBoardName
}

func saveDefaultLocImageDetailsInDB()
{
    var locImgArray: [[String:AnyObject]] = [[String:AnyObject]]()
    var locName = "BedRoom"
    var imgName = "bedroom"
    
    locImgArray.append([ULCommon.sensorLocationKey : locName as AnyObject, ULCommon.locImgKey : imgName as AnyObject] )
    
    locName = "Dining"
    imgName = "dining"
    
    locImgArray.append([ULCommon.sensorLocationKey : locName as AnyObject, ULCommon.locImgKey : imgName as AnyObject] )
    
    locName = "Kitchen"
    imgName = "kitchen"
    
    locImgArray.append([ULCommon.sensorLocationKey : locName as AnyObject, ULCommon.locImgKey : imgName as AnyObject] )
    
    for count in 0  ..< locImgArray.count
    {
        let name = "\(locImgArray[count][ULCommon.sensorLocationKey]!)"
        let img = "\(locImgArray[count][ULCommon.locImgKey]!)"
        
        if #available(iOS 10.0, *)
        {
            let appDelegate =
                UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.coreDataStack.persistentContainer.viewContext
            
            let entityDes = NSEntityDescription.entity(forEntityName: "LocImageDetails", in: context)
            let entity = LocImageDetails(entity: entityDes!, insertInto: context)
            
            entity.sensorLocation = name
            entity.locImage = img
            
            do {
                try context.save()
            }catch{
                print("Could not save \(error)")
            }
        }
        else
        {
            let appDelegate =
                UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.coreDataStack.managedObjectContext
            let entity =  NSEntityDescription.entity(forEntityName:"LocImageDetails",
                                                     in:managedContext)
            
            let sensor = NSManagedObject(entity: entity!,
                                      insertInto: managedContext)
            
            sensor.setValue(name, forKey: ULCommon.sensorLocationKey)
            sensor.setValue(img, forKey: ULCommon.locImgKey)
            
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
}
