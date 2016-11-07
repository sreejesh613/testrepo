//
//  ULHubSettingsViewController.swift
//  ULCH
//
//  Created by Sreejesh on 10/18/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import UIKit

class ULHubSettingsViewController: UIViewController {
    
    static let identifier = "ULHubSettingsViewController"
    
    @IBOutlet var hubSettingsTableView: UITableView!
    @IBOutlet var hubSettingsScrollView: UIScrollView!
    
    let hubsettingsLabels : [String] = ["Hub Name","Users","Hub Status"]
    
    var cellText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hubSettingsTableView.delegate = self
        hubSettingsTableView.dataSource = self
        hubSettingsScrollView.delegate = self
        navigationController?.isNavigationBarHidden = true
        hubSettingsScrollView.isScrollEnabled = true
        hubSettingsScrollView.contentSize = CGSize(width: 100, height: 400)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onBackBtnClick(_ sender: AnyObject)
    {
        guard navigationController?.popViewController(animated: true) != nil
        else
        {
            dismiss(animated: true, completion: nil)
            return
        }
    }
    
    @IBAction func onDeRegisterBtnClick(_ sender: AnyObject)
    {
//        guard let VC = storyboard?.instantiateViewController(withIdentifier: "ULAlertDisplay") else
//        {
//            print("ULAlertDisplay VC Not Found")
//            return
//        }
//        navigationController?.pushViewController(VC, animated: true)
        
        let storyboardobj = UIStoryboard(name:"ULAlertDisplayStoryboard" , bundle: nil)
        let vcobj = storyboardobj.instantiateViewController(withIdentifier: "ULAlertDisplay") as! ULAlertDisplay
        navigationController?.pushViewController(vcobj, animated: true)
    }
    
}

extension ULHubSettingsViewController : UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 1
        {
            return 10
        }
        else
        {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return hubsettingsLabels.count
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let textFieldCell = tableView.dequeueReusableCell(withIdentifier: "ULHubTextfieldTableViewCell")as! ULHubTextfieldTableViewCell
        
        if indexPath.section == 0
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: ULHubSettingsTableViewCell.identifier, for:indexPath) as! ULHubSettingsTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.settingsLabel?.text = hubsettingsLabels[indexPath.row]
        
        return cell
        }
        else if indexPath.section == 1
        {
            let textFieldCell = tableView.dequeueReusableCell(withIdentifier: "ULHubTextfieldTableViewCell")as! ULHubTextfieldTableViewCell
            
            textFieldCell.textFromTextfield("")
            
            print(textFieldCell.textFromTextfield(""))
            
            //textFieldCell.cellTextfield.delegate = self
            
            return textFieldCell
        }
        else
        {
            return textFieldCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Tapped At cell: \(indexPath.row)")
        
        if indexPath.row == 1
        {
            guard let VC = storyboard?.instantiateViewController(withIdentifier: "ULUserListViewController") else
            {
                print("ULUserListViewController Not Found")
                return
            }
            navigationController?.pushViewController(VC, animated: true)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
//        cellText.append(textField.text!)
//        print("TextFetched from field: \(cellText)")
        print("TextFetched from field: \(textField.text)")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField .resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        print("TextFetched from field: \(textField.text)")
        
        if string == nil
        {
            return false
        }
        else
        {
            let userEnteredString = textField.text
            
            let newString = (userEnteredString! as NSString).replacingCharacters(in: range, with: string) as NSString
            
            print(newString)
            
            return true
        }
        
    }
    
}
