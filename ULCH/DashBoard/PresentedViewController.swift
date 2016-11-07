//
//  PresentedViewController.swift
//
//  Created by Jon Kent on 12/14/15.
//  Copyright © 2015 Jon Kent. All rights reserved.
//

import UIKit

class PresentedViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print("Registered Email: \(UserDefaults.standard .object(forKey: userEmailKey))")
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction fileprivate func close()
    {
        guard (navigationController?.popViewController(animated:true)) != nil
            else
        {
            dismiss(animated: true, completion: nil)
            return
        }
    }
}

extension PresentedViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 20
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let editProfileCell = tableView.dequeueReusableCell(withIdentifier: "ULProfileEditTableViewCell")as! ULProfileEditTableViewCell
        
        var email: String?
        //var phoneNumber: String!
        if (UserDefaults.standard .object(forKey: userEmailKey) as! String) != nil
        {
        email = UserDefaults.standard .object(forKey: userEmailKey) as? String
        }
        else
        {
            email = "Email Not In System"
        }
        //if UserDefaults.standard.object(forKey: )
        
        editProfileCell.selectionStyle = .none
        
        switch indexPath.row
        {
        case 0:
            editProfileCell.cellContentNameLabel?.text = "Email Id"
            editProfileCell.editProfileContentDetailLabel?.text = email
            break
        case 1:
            editProfileCell.cellContentNameLabel?.text = "Mobile phone number"
            editProfileCell.editProfileContentDetailLabel?.text = "1234567890"
            break
        case 2:
            editProfileCell.cellContentNameLabel?.text = "Password"
            editProfileCell.editProfileContentDetailLabel?.text = "*******"
            break
        default:
            break
        }
        return editProfileCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath.row
        {
        case 0:
            print("Tapped On email field")
            break
        case 1:
            print("Tapped On Mobile field")
            break
        case 2:
            print("Tapped On password field")
            
            guard let VC = storyboard?.instantiateViewController(withIdentifier: "ULChangePasswordViewController") else
            {
                print("ULChangePasswordViewController not found")
                return
            }
            navigationController?.pushViewController(VC, animated: true)
            break
        default:
            break
        }

    }
}
