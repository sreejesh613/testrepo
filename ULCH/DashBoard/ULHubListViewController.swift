//
//  ULHubListViewController.swift
//  ULCH
//
//  Created by Smitha on 11/10/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import UIKit
import CoreData

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}


class ULHubListViewController: UIViewController, ULSensorListViewControllerDelegate
{
    static let identifier = "ULHubListViewController"
    var sensorDetails = [NSManagedObject]()
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var hubCollectionView: UICollectionView!
    var locationArr = [String]()
    var hubName : String = String()
    
    //PRAGMA MARK:-  Initialize
    override func viewDidLoad()
    {
        super.viewDidLoad()

        titleLbl.text = hubName

        locationArr.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        ULLoadingActivity.show("Please wait.....", disableUI: true)
        
        if #available(iOS 10.0, *)
        {
            let context = appDelegate.coreDataStack.persistentContainer.viewContext
            
            let request: NSFetchRequest<NSFetchRequestResult> = SensorDetails.fetchRequest()
            
            request.predicate = NSPredicate(format: "hubId == %@", hubName)
            
            do {
                let results =
                    try context.fetch(request)
                sensorDetails = results as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        else
        {
            let managedContext = appDelegate.coreDataStack.managedObjectContext
            
            let request = NSFetchRequest<HubDetails>(entityName: "SensorDetails")
            
            request.predicate = NSPredicate(format: "hubId == %@", hubName)
            
            do {
                let results =
                    try managedContext.fetch(request as! NSFetchRequest<NSFetchRequestResult>)
                sensorDetails = results as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
        }
        
        if sensorDetails.count <= 0
        {
            ULCHManager.sharedInstance.getSensorDetailsByHubId(hubName, success: { (response) in
                self.authenticationSuccessHandler(response)
            }) { (error, message) in
                authenticationFailureHandler(error, code: message, parentView: self)
            }
        }
        else
        {
            for sensorCount in 0  ..< sensorDetails.count
            {
                 let sensorLocation = sensorDetails[sensorCount].value(forKey: ULCommon.sensorLocationKey) as? String
                
                locationArr.append(sensorLocation!)
            }
            
            locationArr = locationArr.removeDuplicates()
            ULLoadingActivity.hide()
            self.hubCollectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //PRAGMA MARK:-  UIButton Actions
    @IBAction func onSettingsBtnClicked(_ sender: AnyObject)
    {
        guard let VC = storyboard?.instantiateViewController(withIdentifier: "ULHubSettingsViewController")else
        {
            print("HubSettingsVC not found!")
            return
        }
        navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func onBackBtnClicked(_ sender: AnyObject)
    {
        guard (navigationController?.popViewController(animated:true)) != nil
            else
        {
            dismiss(animated: true, completion: nil)
            return
        }

    }
    
    //PRAGMA MARK:-  ULSensorListViewControllerDelegate method
    func didChangedLocation(_ locName:String, indexPath:IndexPath)
    {
        let cell = hubCollectionView.cellForItem(at: indexPath as IndexPath) as! ULHubCollectionViewCell
        
        cell.sensorLocNameLbl.text = locName
        
        let locImgName = getLocImage(locName)
        var image: UIImage = UIImage()
        image = UIImage(named: locImgName)!
        
        cell.sensorImg.image = image
    }
    
    //PRAGMA MARK:-  API Call Response handler
    func authenticationSuccessHandler(_ response:AnyObject?)
    {
        let json = response as? [String: AnyObject]
        print(json)
        
        let status = json![ULCommon.statusKey] as! Int
        
        if status == 1
        {
            let responseArrResult = json![ULCommon.sensorDetailsKey] as! [AnyObject]
            
            for sensorCount in 0  ..< responseArrResult.count
            {
                let sensorLocation = responseArrResult[sensorCount].value(forKey: ULCommon.sensorLocationKey) as? String

                locationArr.append(sensorLocation!)
            }
            
            for sensorCount in 0  ..< responseArrResult.count
            {
                let batteryStatus = responseArrResult[sensorCount].value(forKey: ULCommon.batteryStatusKey) as? String
                let sensorId = responseArrResult[sensorCount].value(forKey: ULCommon.sensorIdKey) as? String
                let sensorLocation = responseArrResult[sensorCount].value(forKey: ULCommon.sensorLocationKey) as? String
                let sensorName = responseArrResult[sensorCount].value(forKey: ULCommon.sensorNameKey) as? String
                let sensorState = responseArrResult[sensorCount].value(forKey: ULCommon.sensorStateKey) as? String
                let sensorStatus = responseArrResult[sensorCount].value(forKey: ULCommon.sensorStatusKey) as? String
                let sensorType = responseArrResult[sensorCount].value(forKey: ULCommon.sensorTypeKey) as? String
                let zwaveInd = responseArrResult[sensorCount].value(forKey: ULCommon.zWaveIndKey) as? String
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                if #available(iOS 10.0, *)
                {
                    let context = appDelegate.coreDataStack.persistentContainer.viewContext
                    
                    let entityDes = NSEntityDescription.entity(forEntityName: "SensorDetails", in: context)
                    let entity = SensorDetails(entity: entityDes!, insertInto: context)
                    
                    entity.batteryStatus = batteryStatus
                    entity.sensorId = sensorId
                    entity.sensorLocation = sensorLocation
                    entity.sensorName = sensorName
                    entity.sensorState = sensorState
                    entity.sensorStatus = sensorStatus
                    entity.sensorType = sensorType
                    entity.zWaveInd = zwaveInd
                    entity.hubId = hubName
                    
                    do {
                        try context.save()
                        sensorDetails.append(entity)
                    }catch{
                        print("Could not save \(error)")
                    }
                }
                else
                {
                    let managedContext = appDelegate.coreDataStack.managedObjectContext
                    let entity =  NSEntityDescription.entity(forEntityName:"SensorDetails", in:managedContext)
                    
                    let sensor = NSManagedObject(entity: entity!,
                                                 insertInto: managedContext)
                    
                    sensor.setValue(batteryStatus, forKey: ULCommon.batteryStatusKey)
                    sensor.setValue(sensorId, forKey: ULCommon.sensorIdKey)
                    sensor.setValue(sensorLocation, forKey: ULCommon.sensorLocationKey)
                    sensor.setValue(sensorName, forKey: ULCommon.sensorNameKey)
                    sensor.setValue(sensorState, forKey: ULCommon.sensorStateKey)
                    sensor.setValue(sensorStatus, forKey: ULCommon.sensorStatusKey)
                    sensor.setValue(sensorType, forKey: ULCommon.sensorTypeKey)
                    sensor.setValue(zwaveInd, forKey: ULCommon.zWaveIndKey)
                    sensor.setValue(hubName, forKey: ULCommon.hubIdKey)
                    
                    do {
                        try managedContext.save()
                        sensorDetails.append(sensor)
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                }
            }
                
            locationArr = locationArr.removeDuplicates()
            
            if locationArr.count > 0
            {
                self.hubCollectionView.reloadData()
            }

        }
        else
        {
            let errMsg = json![ULCommon.errorMessageKey] as! String
            
            alert("Error", message: errMsg, parentView: self)
        }
        
        
        ULLoadingActivity.hide()
    }

    func getLocImage(_ locName : String) -> String
    {
        var imgName = String()
        if locName == "BedRoom"
        {
            imgName = "bedroom"
        }
        else if locName == "Dining"
        {
            imgName = "dining"
        }
        else if locName == "Kitchen"
        {
            imgName = "kitchen"
        }
        else
        {
            imgName = "Unknown"
        }

        return imgName
    }
}


extension ULHubListViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    //PRAGMA MARK:-  Collection View Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if locationArr.count > 0
        {
            return locationArr.count
        }
        else
        {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let screenSize: CGRect = UIScreen.main.bounds
        let cellWidth = (screenSize.width/3)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ULHubCollectionViewCell", for: indexPath) as! ULHubCollectionViewCell
        
        cell.sensorLocNameLbl.text = locationArr[indexPath.row]
        
        let locImgName = getLocImage(locationArr[indexPath.row])
        
        var image: UIImage = UIImage()
        image = UIImage(named: locImgName)!
        
        cell.sensorImg.image = image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(1, 1, 0, 1)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let sensor = sensorDetails[indexPath.row]
        let hubId = sensor.value(forKey: ULCommon.hubIdKey) as? String
        let sensorLoc = sensor.value(forKey: ULCommon.sensorLocationKey) as? String
        
        let storyboardobj = UIStoryboard(name:"Sensor" , bundle: nil)
        let vcobj = storyboardobj.instantiateViewController(withIdentifier: "ULSensorListViewController") as! ULSensorListViewController
        vcobj.hubId = hubId!
        vcobj.sensorLoc = sensorLoc!
        vcobj.indexPath = (indexPath as NSIndexPath) as IndexPath
        vcobj.delegate = self
        
        navigationController?.pushViewController(vcobj, animated: true)

    }

}
