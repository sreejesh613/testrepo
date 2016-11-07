//
//  ULDashBoardViewController.swift
//  ULCH
//
//  Created by Smitha on 07/10/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import UIKit
import SideMenu
import CoreData

class ULDashBoardViewController: UIViewController
{
    static let identifier = "ULDashBoardViewController"
    
    @IBOutlet weak var tableView: UITableView!
    var hubDetails = [NSManagedObject]()
    
    //PRAGMA MARK:-  Initialize
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let menuLeftNavigationController = UISideMenuNavigationController()
        menuLeftNavigationController.leftSide = true
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController

        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuBlurEffectStyle = .dark
        
        SideMenuManager.menuAnimationFadeStrength = 0.1
        SideMenuManager.menuShadowOpacity = 0.5
        SideMenuManager.menuAnimationTransformScaleFactor = 0.9
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        ULLoadingActivity.show("Please wait.....", disableUI: true)
        
        if #available(iOS 10.0, *)
        {
            let context = appDelegate.coreDataStack.persistentContainer.viewContext

            let request: NSFetchRequest<NSFetchRequestResult> = HubDetails.fetchRequest()
            
            do {
                let results =
                    try context.fetch(request)
                hubDetails = results as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        else
        {
            let managedContext = appDelegate.coreDataStack.managedObjectContext
            
            let request = NSFetchRequest<HubDetails>(entityName: "HubDetails")

            do {
                let results =
                    try managedContext.fetch(request as! NSFetchRequest<NSFetchRequestResult>)
                hubDetails = results as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }

        }
        
        if hubDetails.count <= 0
        {
            ULCHManager.sharedInstance.getHubPerUser({ (response) in
                self.authenticationSuccessHandler(response)
            }) { (error, message) in
                authenticationFailureHandler(error, code: message, parentView: self)
            }
        }
        else
        {
            ULLoadingActivity.hide()
            self.tableView.reloadData()
        }
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
    
    //PRAGMA MARK:-  API Calls
    func authenticationSuccessHandler(_ response:AnyObject?)
    {
        let json = response as? [String: AnyObject]
        print(json)
        
        let status = json![ULCommon.statusKey] as! Int
        
        if status == 1
        {
            let responseArrResult = json![ULCommon.hubDetailsKey] as! [AnyObject]
            
            for hubCount in 0  ..< responseArrResult.count
            {
                let adminIndicator = responseArrResult[hubCount].value(forKey: ULCommon.adminIndicatorKey) as! String
                let firmware = responseArrResult[hubCount].value(forKey: ULCommon.firmwareKey) as? String
                let hubId = responseArrResult[hubCount].value(forKey: ULCommon.hubIdKey) as? String
                let hubLoc = responseArrResult[hubCount].value(forKey: ULCommon.hubLocKey) as? String
                let hubRegStatus = responseArrResult[hubCount].value(forKey: ULCommon.hubRegStatusKey) as? String
                let hubStatus = responseArrResult[hubCount].value(forKey: ULCommon.hubStatusKey) as? String
                let zwaveInd = responseArrResult[hubCount].value(forKey: ULCommon.zWaveIndKey) as! String

                if #available(iOS 10.0, *)
                {
                    let appDelegate =
                        UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.coreDataStack.persistentContainer.viewContext

                    let entityDes = NSEntityDescription.entity(forEntityName: "HubDetails", in: context)
                    let entity = HubDetails(entity: entityDes!, insertInto: context)
                    
                    entity.adminIndicator = adminIndicator
                    entity.firmware = firmware
                    entity.hubId = hubId
                    entity.hubLoc = hubLoc
                    entity.hubRegStatus = hubRegStatus
                    entity.hubStatus = hubStatus
                    entity.zWaveInd = zwaveInd
                    
                    do {
                        try context.save()
                        hubDetails.append(entity)
                    }catch{
                        print("Could not save \(error)")
                    }
                }
                else
                {
                    let appDelegate =
                        UIApplication.shared.delegate as! AppDelegate
                    let managedContext = appDelegate.coreDataStack.managedObjectContext
                    let entity =  NSEntityDescription.entity(forEntityName:"HubDetails",
                                                             in:managedContext)
                    
                    let hub = NSManagedObject(entity: entity!,
                                              insertInto: managedContext)
                    
                    hub.setValue(adminIndicator, forKey: ULCommon.adminIndicatorKey)
                    hub.setValue(firmware, forKey: ULCommon.firmwareKey)
                    hub.setValue(hubId, forKey: ULCommon.hubIdKey)
                    hub.setValue(hubLoc, forKey: ULCommon.hubLocKey)
                    hub.setValue(hubRegStatus, forKey: ULCommon.hubRegStatusKey)
                    hub.setValue(hubStatus, forKey: ULCommon.hubStatusKey)
                    hub.setValue(zwaveInd, forKey: ULCommon.zWaveIndKey)
                    
                    do {
                        try managedContext.save()
                        hubDetails.append(hub)
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                }
            }
        
            if self.hubDetails.count > 0
            {
                self.tableView.reloadData()
            }
        }
        else
        {
            let errMsg = json![ULCommon.errorMessageKey] as! String
            
            alert("Error", message: errMsg, parentView: self)
        }
        
        ULLoadingActivity.hide()
    }
    
    //PRAGMA MARK:-  UIButton Actions
    @IBAction func onMenuBtnClicked(_ sender: AnyObject)
    {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
}

//PRAGMA MARK:- Tableview Delegates
extension ULDashBoardViewController:UITableViewDelegate,UITableViewDataSource
{

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var height : CGFloat = CGFloat()
        switch self.hubDetails.count
        {
            case 1:
                height = self.tableView.frame.size.height
                break;
            case 2:
                height = self.tableView.frame.size.height / 2
                break;
            default:
                height = self.tableView.frame.size.height / 2
        }
        return  height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.hubDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ULDashBoardTableViewCell.identifier, for:indexPath) as! ULDashBoardTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let hub = hubDetails[indexPath.row]
        
        cell.hubName.text = hub.value(forKey: ULCommon.hubIdKey) as? String
        
        let hubStatus = hub.value(forKey: ULCommon.hubStatusKey) as? String

        var image: UIImage = UIImage()
        if( hubStatus == "Green")
        {
            image = UIImage(named: "hubGreen")!
        }
        else if( hubStatus == "Red")
        {
            image = UIImage(named: "hubRed")!
        }
        else //( hubStatus == "Green")
        {
            image = UIImage(named: "hubYellow")!
        }
        
        cell.hubImage.image = image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let hub = hubDetails[indexPath.row]
        let hubName = hub.value(forKey: ULCommon.hubIdKey) as? String
        
        let storyboardobj = UIStoryboard(name:"Dashboard" , bundle: nil)
        let vcobj = storyboardobj.instantiateViewController(withIdentifier: "ULHubListViewController") as! ULHubListViewController
        vcobj.hubName = hubName!
        navigationController?.pushViewController(vcobj, animated: true)
    }
}
