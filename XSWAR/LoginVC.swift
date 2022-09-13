//
//  ViewController.swift
//  XSWAR
//
//  Created by Jigar Kanani on 05/02/21.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet var txtUserName : UITextField!
    @IBOutlet var txtPassword : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    @IBAction func btnBackClick(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSignInClick(_ sender: UIButton)
    {
        if appDelegate.userSignUpData != nil
        {
            let alert = UIAlertController(title: "", message: "Buyer is already Loggedin please Logout buyer first." , preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .default, handler: { (action) in
                
            }))
            alert.addAction(UIAlertAction.init(title: "Logout", style: .default, handler: { (action) in
                
                let URL_API = BASE_URL.appending(API_LOGOUT)
                
                APIParser.dataWithURL(url: URL_API, requestType:.TYPE_GET, bodyObject: [:], imageObject: [], isShowProgress: true, isHideProgress: true) { (response, data) in
                    
                    appDelegate.userSignUpData = nil
                    appDelegate.dealerLoginData = nil
                    
                    UserDefaults.standard.removeObject(forKey: "UserData")
                    UserDefaults.standard.synchronize()
                    
                    UserDefaults.standard.removeObject(forKey: "DUserData")
                    UserDefaults.standard.synchronize()
                }
            }))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        
        
        if !(self.txtUserName.text?.isEmail())!
        {
            self.showAlertWithTitle(alertTitle: "", msg: "Enter valid email address.")
            return
        }
        else if self.txtPassword.text == ""
        {
            self.showAlertWithTitle(alertTitle: "", msg: "Enter password to login.")
            return
        }
        
        let dicLogin = ["user_name" : txtUserName.text ?? "",
                         "password" : txtPassword.text ?? "",
                         "device_type" : DEVICE_TYPE,
                         "fcm_token" : appDelegate.deviceToken]
        
        let URL_API = BASE_URL.appending(API_LOGIN)
        APIParser.dataWithURL(url: URL_API, requestType:.TYPE_DELETE, bodyObject: dicLogin, imageObject: [], isShowProgress: true, isHideProgress: true) { (response, data) in
            
            let dealerLoginData = try! newJSONDecoder().decode(DealerLoginData.self, from: data)
                        
            if dealerLoginData.success!
            {
                appDelegate.dealerLoginData = dealerLoginData
                
                UserDefaults.standard.setValue(data, forKey: "DUserData")
                UserDefaults.standard.synchronize()
                                
                if #available(iOS 13.0, *) {
                    sceneDelegate.setRoot()
                } else {
                    appDelegate.setRoot()
                }
            }
            else
            {
                self.showAlertWithTitle(alertTitle: "", msg: dealerLoginData.message!)
            }
        }
    }
}

extension LoginVC : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
