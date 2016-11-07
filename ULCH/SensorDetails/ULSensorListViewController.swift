//
//  ULSensorListViewController.swift
//  ULCH
//
//  Created by Smitha on 12/10/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import UIKit
import CoreData

@objc protocol ULSensorListViewControllerDelegate
{
    @objc optional func didChangedLocation(_ locName:String, indexPath:IndexPath)
}


class ULSensorListViewController: UIViewController, UIAlertViewDelegate, ULSensorDetailsViewControllerDelegate,ULLocListTableViewCellDelegate {

    static let identifier = "ULSensorListViewController"
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var holderViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var locationListTableView: UITableView!
    @IBOutlet weak var sensorLocationNameLbl: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    var sensorDetails = [NSManagedObject]()
    var sensorLocDetails = [NSManagedObject]()//: [[String:AnyObject]] = [[String:AnyObject]]()
    
    var hubId : String = String()
    var sensorLoc : String = String()
    var editBtnStatus : Bool = Bool()
    var count : Int = Int()
    var delegate:ULSensorListViewControllerDelegate! = nil
    var indexPath = IndexPath(row: 0, section: 0)
    var selectedIndex = Int()
    var selectedLocationName : String = String()
    
    //PRAGMA MARK:-  Initialize
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sensorLocationNameLbl.text = sensorLoc
        count = 0
        selectedIndex = -1
        selectedLocationName = ""
        editBtnStatus = true
        holderViewHeightConstraint.constant = 0
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        ULLoadingActivity.show("Please wait.....", disableUI: true)
        
        if #available(iOS 10.0, *)
        {
            let context = appDelegate.coreDataStack.persistentContainer.viewContext
            
            //fetch sensors in same location
            let request: NSFetchRequest<NSFetchRequestResult> = SensorDetails.fetchRequest()
            
            request.predicate = NSPredicate(format: "hubId == %@ AND sensorLocation == %@", hubId, sensorLoc)
            
            do {
                let results =
                    try context.fetch(request)
                sensorDetails = results as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
            //fetch loc details
            let locRequest: NSFetchRequest<NSFetchRequestResult> = LocImageDetails.fetchRequest()
            
            do {
                let results =
                    try context.fetch(locRequest)
                sensorLocDetails = results as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }

            
        }
        else
        {
            let managedContext = appDelegate.coreDataStack.managedObjectContext
            
            //fetch sensors in same location
            let request = NSFetchRequest<HubDetails>(entityName: "SensorDetails")
            
            request.predicate = NSPredicate(format: "hubId == %@ AND sensorLocation == %@", hubId, sensorLoc)
            
            do {
                let results =
                    try managedContext.fetch(request as! NSFetchRequest<NSFetchRequestResult>)
                sensorDetails = results as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
            //fetch loc details
            let locRequest = NSFetchRequest<HubDetails>(entityName: "LocImageDetails")

            do {
                let results =
                    try managedContext.fetch(locRequest as! NSFetchRequest<NSFetchRequestResult>)
                sensorLocDetails = results as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
        if sensorLocDetails.count > 0
        {
            for count in 0  ..< sensorLocDetails.count
            {
                let sensor = sensorLocDetails[count]
                
                let name = sensor.value(forKey: ULCommon.sensorLocationKey) as? String

                if name == sensorLocationNameLbl.text
                {
                    selectedIndex = count
                }
            }
            self.locationListTableView.reloadData()
        }
        
        if sensorDetails.count > 0
        {
            ULLoadingActivity.hide()
            self.listTableView.reloadData()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //PRAGMA MARK:-  ULSensorDetailsViewControllerDelegate method
    func didChangedDetails(_ locName:String, sensorName:String, indexPath:IndexPath)
    {
        let cell = listTableView.cellForRow(at: indexPath as IndexPath) as! ULSensorListTableViewCell
        
        cell.sensorType.text = sensorName
        sensorLoc = locName
        sensorLocationNameLbl.text = sensorLoc
    }
    
    //PRAGMA MARK:-  ULLocListTableViewCellDelegate method
    func didAddedOtherLocName(_ text : String)
    {
        selectedIndex = -1
        selectedLocationName = text
        self.locationListTableView.reloadData()
    }


    //PRAGMA MARK:-  UIButton Actions
    @IBAction func onBackBtnClicked(_ sender: AnyObject)
    {
        delegate!.didChangedLocation!(sensorLoc, indexPath: indexPath)
        
        guard (navigationController?.popViewController(animated:true)) != nil
            else
        {
            dismiss(animated: true, completion: nil)
            return
        }
    }

    @IBAction func onAddSensorBtnClicked(_ sender: UIButton)
    {
    }
    
    @IBAction func onEditBtnClicked(_ sender: AnyObject)
    {
        if editBtnStatus == true
        {
            UIView.animate(withDuration: 0.50, animations: {
                
                self.holderViewHeightConstraint.constant = 270
                self.editBtnStatus = false
                self.editBtn.setImage(UIImage(named: "doneBtn.png"), for: UIControlState.normal)
                self.view.layoutIfNeeded()
            })
        }
        else
        {
            if sensorLoc == selectedLocationName
            {
                //alert(appName, message: "Please enter a different Location.", parentView: self)
                
                UIView.animate(withDuration: 0.50, animations: {
                    self.holderViewHeightConstraint.constant = 0
                    self.editBtnStatus = true
                    self.editBtn.setImage(UIImage(named: "edit.png"), for: UIControlState.normal)
                    self.view.layoutIfNeeded()
                })
            }
            else
            {
                let alertView = UIAlertView(title: "Do you want to change the 'Location'?", message: "The associated sensor location(s) will be changed.", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes")
                
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
                UIView.animate(withDuration: 0.50, animations: {
                    self.holderViewHeightConstraint.constant = 0
                    self.editBtnStatus = true
                    self.editBtn.setImage(UIImage(named: "edit.png"), for: UIControlState.normal)
                    self.view.layoutIfNeeded()
                })
                
                alertView.dismiss(withClickedButtonIndex: -1, animated: true)
                performAfterDelay()
            }
            else
            {
                //cancel
                print("No")
                UIView.animate(withDuration: 0.50, animations: {
                    self.holderViewHeightConstraint.constant = 0
                    self.editBtnStatus = true
                    self.editBtn.setImage(UIImage(named: "edit.png"), for: UIControlState.normal)
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func performAfterDelay()
    {
        let delay = 1.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            self.updateSensorDetailsToDB()
        })
    }

    
    func updateSensorDetailsToDB()
    {
        ULLoadingActivity.show("Please wait.....", disableUI: true)
        
        for i in 0..<sensorDetails.count
        {
            let sensor = sensorDetails[i]
            
            let sensorId = sensor.value(forKey: ULCommon.sensorIdKey) as? String
            
            let sensorLoc = selectedLocationName

            let sensorName = sensor.value(forKey: ULCommon.sensorNameKey) as? String
            
            ULCHManager.sharedInstance.updateSensorDetails(hubId, sensorId: sensorId!, sensorName: sensorName!, sensorLocation: sensorLoc, success: { (response) in
                self.authenticationSuccessHandler(response)
            }) { (error, message) in
                authenticationFailureHandler(error, code: message, parentView: self)
            }
        }
    }
    
    func authenticationSuccessHandler(_ response:AnyObject?)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        count += 1
        let json = response as? [String: AnyObject]
        print(json)

        if sensorDetails.count == count
        {
            for i in 0..<sensorDetails.count
            {
                if #available(iOS 10.0, *)
                {
                    let context = appDelegate.coreDataStack.persistentContainer.viewContext
                    
                    sensorDetails[i].setValue(selectedLocationName, forKey: ULCommon.sensorLocationKey)
                    
                    do {
                        try context.save()
                    }catch{
                        print("Could not save \(error)")
                    }
                }
                else
                {
                    let managedContext = appDelegate.coreDataStack.managedObjectContext
                    
                    sensorDetails[i].setValue(selectedLocationName, forKey: ULCommon.sensorLocationKey)
                    
                    do {
                        try managedContext.save()
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                }
            }
        }
        
        sensorLoc = selectedLocationName
        sensorLocationNameLbl.text = sensorLoc
        ULLoadingActivity.hide()
    }
    
    
    //PRAGMA MARK:-  UITextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder();
        return true;
    }
}

//PRAGMA MARK:- Tableview Delegates
extension ULSensorListViewController:UITableViewDelegate,UITableViewDataSource
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
        var retValue = 0
        
        if tableView.tag == 0
        {
            retValue = 60
        }
        else
        {
            retValue = 50
        }
        return CGFloat(retValue)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView.tag == 0
        {
            return self.sensorDetails.count
        }
        else
        {
            return self.sensorLocDetails.count + 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView.tag == 0
        {
            let cell = self.listTableView.dequeueReusableCell(withIdentifier: ULSensorListTableViewCell.identifier, for:indexPath) as! ULSensorListTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let sensor = sensorDetails[indexPath.row]
            
            cell.sensorType.text = sensor.value(forKey: ULCommon.sensorNameKey) as? String
            
            let sensorStatus = sensor.value(forKey: ULCommon.sensorStatusKey) as? String
            
            var image: UIImage = UIImage()
            if( sensorStatus == "Online")
            {
                image = UIImage(named: "status_green")!
            }
                //        else if( sensorStatus == "Red")
                //        {
                //            image = UIImage(named: "hubRed")!
                //        }
            else //( sensorStatus == "Green")
            {
                image = UIImage(named: "status_alert")!
            }
            
            cell.sensorStatus.image = image
            
            let sensorType = sensor.value(forKey: ULCommon.sensorTypeKey) as? String
            
            var sensorImage: UIImage = UIImage()
            if( sensorType == "Fire")
            {
                sensorImage = UIImage(named: "fire_sensor")!
            }
            else if( sensorType == "FloodFreeze")
            {
                sensorImage = UIImage(named: "flood_freeze_sensor")!
            }
            else if( sensorType == "Thermostat")
            {
                sensorImage = UIImage(named: "thermostat")!
            }
            else
            {
                sensorImage = UIImage(named: "valve_sensor")!
            }
            
            cell.sensorImg.image = sensorImage
            
            return cell
        }
        else
        {
            let cell = self.locationListTableView.dequeueReusableCell(withIdentifier: ULLocListTableViewCell.identifier, for:indexPath) as! ULLocListTableViewCell
            
            cell.delegate = self
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            if indexPath.row == self.sensorLocDetails.count
            {
                cell.locNameLbl.text = "Other :"
                let image = UIImage(named: "Unknown")!
                cell.locImageView.image = image
                cell.locTextField.isHidden = false
                cell.checkImgView.isHidden = true
            }
            else
            {
                let sensor = sensorLocDetails[indexPath.row]
                
                cell.locNameLbl.text = sensor.value(forKey: ULCommon.sensorLocationKey) as? String

                if selectedIndex == indexPath.row
                {
                    var chkImg: UIImage = UIImage()
                    chkImg = UIImage(named: "check")!
                    cell.checkImgView.image = chkImg
                    selectedLocationName = cell.locNameLbl.text!
                }
                else
                {
                    var chkImg: UIImage = UIImage()
                    chkImg = UIImage(named: "uncheck")!
                    cell.checkImgView.image = chkImg
                }
                
                let locImgName = sensor.value(forKey: ULCommon.locImgKey) as? String
                
                var image: UIImage = UIImage()
                image = UIImage(named: locImgName!)!
                
                cell.locImageView.image = image
                cell.locTextField.isHidden = true
                cell.checkImgView.isHidden = false
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView.tag == 0
        {
            let storyboardobj = UIStoryboard(name:"Sensor" , bundle: nil)
            let vcobj = storyboardobj.instantiateViewController(withIdentifier: "ULSensorDetailsViewController") as! ULSensorDetailsViewController
            vcobj.sensorDetails = [sensorDetails[indexPath.row]]
            vcobj.delegate = self
            vcobj.indexPath = indexPath
            navigationController?.pushViewController(vcobj, animated: true)
        }
        else
        {
            selectedIndex = indexPath.row
            self.locationListTableView.reloadData()
        }
    }
    
    
}
