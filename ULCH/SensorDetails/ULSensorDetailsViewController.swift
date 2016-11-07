//
//  ULSensorDetailsViewController.swift
//  ULCH
//
//  Created by Smitha on 14/10/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import UIKit
import CoreData

@objc protocol ULSensorDetailsViewControllerDelegate
{
    @objc optional func didChangedDetails(_ locName:String, sensorName:String, indexPath:IndexPath)
}

class ULSensorDetailsViewController: UIViewController, UIAlertViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var editBtn: UIButton!
    var sensorDetails = [NSManagedObject]()
    var editBtnStatus : Bool = Bool()
    var sensorLoc : String = String()
    var sensorName : String = String()
    var delegate:ULSensorDetailsViewControllerDelegate! = nil
    var indexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        editBtnStatus = true
        
        sensorName = (sensorDetails[0].value(forKey: ULCommon.sensorNameKey) as? String)!
        sensorLoc = (sensorDetails[0].value(forKey: ULCommon.sensorLocationKey) as? String)!
        titleLabel.text = sensorLoc
        
        deleteBtn.backgroundColor = returnButtonColor()
        deleteBtn.layer.cornerRadius = 5

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onEditBtnClicked(_ sender: AnyObject)
    {
        if editBtnStatus == true
        {
            self.editBtnStatus = false
            self.editBtn.setImage(UIImage(named: "doneBtn.png"), for: UIControlState.normal)
            self.listTableView.reloadData()

        }
        else
        {
            let indexPath1 = IndexPath(row: 0, section: 0)
            let cell1 = self.listTableView.cellForRow(at: indexPath1 as IndexPath) as! ULSensorDetailTableViewCell!
            
            let indexPath2 = IndexPath(row: 2, section: 0)
            let cell2 = self.listTableView.cellForRow(at: indexPath2 as IndexPath) as! ULSensorDetailTableViewCell!
            
            if sensorName == (cell1?.valueTxtField.text!)! as String && sensorLoc == (cell2?.valueTxtField.text!)! as String
            {
                //alert(appName, message: "Please change the current sensor information.", parentView: self)
                
                self.editBtnStatus = true
                self.editBtn.setImage(UIImage(named: "edit.png"), for: UIControlState.normal)
                self.listTableView.reloadData()
            }
            else
            {
                let alertView = UIAlertView(title: appName, message: "Do you want to save the changes?", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes")
                
                alertView.tag = 1
                alertView.show()
            }
        }

    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int){
        if alertView.tag == 1
        {
            if buttonIndex == 1 //Yes
            {
                print("Yes")
                
                self.editBtnStatus = true
                self.editBtn.setImage(UIImage(named: "edit.png"), for: UIControlState.normal)
                
                alertView.dismiss(withClickedButtonIndex: -1, animated: true)
                performAfterDelay()
            }
            else
            {
                //cancel
                print("No")
                
                self.editBtnStatus = true
                self.editBtn.setImage(UIImage(named: "edit.png"), for: UIControlState.normal)
                self.listTableView.reloadData()
            }
        }
    }

    
    func performAfterDelay()
    {
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            self.updateSensorDetailsToDB()
        })
    }

    func updateSensorDetailsToDB()
    {
        ULLoadingActivity.show("Please wait.....", disableUI: true)
        
        let indexPath1 = IndexPath(row: 0, section: 0)
        let cell1 = self.listTableView.cellForRow(at: indexPath1 as IndexPath) as! ULSensorDetailTableViewCell!
        
        let indexPath2 = IndexPath(row: 2, section: 0)
        let cell2 = self.listTableView.cellForRow(at: indexPath2 as IndexPath) as! ULSensorDetailTableViewCell!
        
        let hubId = sensorDetails[0].value(forKey: ULCommon.hubIdKey) as? String
        let sensorId = sensorDetails[0].value(forKey: ULCommon.sensorIdKey) as? String
        let sensorName = (cell1?.valueTxtField.text!)! as String
        let sensorLoc = (cell2?.valueTxtField.text!)! as String
        
        ULCHManager.sharedInstance.updateSensorDetails(hubId!, sensorId: sensorId!, sensorName: sensorName, sensorLocation: sensorLoc, success: { (response) in
            self.authenticationSuccessHandler(response)
        }) { (error, message) in
            authenticationFailureHandler(error, code: message, parentView: self)
        }
    }
    
    func authenticationSuccessHandler(_ response:AnyObject?)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let json = response as? [String: AnyObject]
        print(json)
        
        let indexPath1 = IndexPath(row: 0, section: 0)
        let cell1 = self.listTableView.cellForRow(at: indexPath1 as IndexPath) as! ULSensorDetailTableViewCell!
        
        let indexPath2 = IndexPath(row: 2, section: 0)
        let cell2 = self.listTableView.cellForRow(at: indexPath2 as IndexPath) as! ULSensorDetailTableViewCell!
        
        sensorName = (cell1?.valueTxtField.text!)! as String
        sensorLoc = (cell2?.valueTxtField.text!)! as String

        if #available(iOS 10.0, *)
        {
            let context = appDelegate.coreDataStack.persistentContainer.viewContext
            
            sensorDetails[0].setValue(sensorName, forKey: ULCommon.sensorNameKey)
            sensorDetails[0].setValue(sensorLoc, forKey: ULCommon.sensorLocationKey)
            
            do {
                try context.save()
            }catch{
                print("Could not save \(error)")
            }
        }
        else
        {
            let managedContext = appDelegate.coreDataStack.managedObjectContext
            
            sensorDetails[0].setValue(sensorName, forKey: ULCommon.sensorNameKey)
            sensorDetails[0].setValue(sensorLoc, forKey: ULCommon.sensorLocationKey)
            
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
        titleLabel.text = sensorLoc
        self.listTableView.reloadData()
        ULLoadingActivity.hide()
    }

    
    @IBAction func onBackBtnClicked(_ sender: AnyObject)
    {
        delegate!.didChangedDetails!(sensorLoc, sensorName: sensorName, indexPath: indexPath)
        
        guard (navigationController?.popViewController(animated:true)) != nil
            else
        {
            dismiss(animated: true, completion: nil)
            return
        }

    }

    @IBAction func onDeleteBtnClicked(_ sender: AnyObject) {
    }
}

//PRAGMA MARK:- Tableview Delegates
extension ULSensorDetailsViewController:UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.listTableView.dequeueReusableCell(withIdentifier: ULSensorDetailTableViewCell.identifier, for:indexPath) as! ULSensorDetailTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.tag = indexPath.row

        cell.valueTxtField.isHidden = true
        cell.valueLbl.isHidden = false
        
        switch indexPath.row {
        case 0:
            cell.titleLbl.text = "Name:"
            cell.valueLbl.text = sensorDetails[0].value(forKey: ULCommon.sensorNameKey) as? String

            if editBtnStatus == true
            {
                cell.valueTxtField.isHidden = true
                cell.valueLbl.isHidden = false
            }
            else
            {
                cell.valueTxtField.isHidden = false
                cell.valueTxtField.text = cell.valueLbl.text
                cell.valueLbl.isHidden = true
            }
            break
        case 1:
            cell.titleLbl.text = "Type:"
            cell.valueLbl.text = sensorDetails[0].value(forKey: ULCommon.sensorTypeKey) as? String
            break
        case 2:
            cell.titleLbl.text = "Location:"
            cell.valueLbl.text = sensorDetails[0].value(forKey: ULCommon.sensorLocationKey) as? String
            if editBtnStatus == true
            {
                cell.valueTxtField.isHidden = true
                cell.valueLbl.isHidden = false
            }
            else
            {
                cell.valueTxtField.isHidden = false
                cell.valueTxtField.text = cell.valueLbl.text
                cell.valueLbl.isHidden = true
            }
            break
        case 3:
            cell.titleLbl.text = "Battery Status:"
            cell.valueLbl.text = sensorDetails[0].value(forKey: ULCommon.batteryStatusKey) as? String
            break
        case 4:
            cell.titleLbl.text = "State:"
            cell.valueLbl.text = sensorDetails[0].value(forKey: ULCommon.sensorStateKey) as? String
            break
        case 5:
            cell.titleLbl.text = "Status:"
            cell.valueLbl.text = sensorDetails[0].value(forKey: ULCommon.sensorStatusKey) as? String
            break

        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    
}
