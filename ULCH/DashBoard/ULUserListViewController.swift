//
//  ULUserListViewController.swift
//  ULCH
//
//  Created by Sreejesh on 10/20/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import UIKit

class ULUserListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate
{

    //@IBOutlet weak var testTxtFld: UITextField!
    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var addUserBtn: UIButton!
    
    let TestData: [String] = ["User1","User2","User3","User4"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        userListTableView.delegate = self
        
        userListTableView.isHidden = true
        
        addUserBtn.backgroundColor = returnButtonColor()
        addUserBtn.layer.cornerRadius = 5
        changeTextFieldBorders([nameTxtField,emailTxtField,phoneTxtField], height:40.0)
    }

//    override func viewDidLayoutSubviews() {
//        changeTextFieldBorders([nameTxtField,emailTxtField,phoneTxtField], height:40.0)
//        
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CountryPhoneCodePicker Delegate
    
    
//    @IBAction func OnShowPickerBtnClick(_ sender: AnyObject)
//    {
//        print("PickerBtnClicked!!!")
//        
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TestData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Existing Users"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userListtableViewCell = tableView.dequeueReusableCell(withIdentifier: "ULUserListTableViewCell")as! ULUserListTableViewCell
        userListtableViewCell.selectionStyle = UITableViewCellSelectionStyle.none
        userListtableViewCell.userListLabel?.text = TestData[indexPath.row]
        return userListtableViewCell
    }
    
    @IBAction func onAddUserBtnClick(_ sender: AnyObject)
    {
        print("Add User button clicked!!")
        
        alert(appName, message: "This is a future implementation", parentView: self)
        
        //adduserApi()
        
    }
    
    @IBAction func onBackBtnClick(_ sender: AnyObject)
    {
        guard navigationController?.popViewController(animated: true) != nil else
        {
            dismiss(animated: true, completion: nil)
            return
        }
    }

    //PRAGMA MARK:-  API Call and Validation
    
//    func adduserApi()
//    {
//        <#function body#>
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
