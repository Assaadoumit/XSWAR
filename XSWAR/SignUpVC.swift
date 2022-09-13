//
//  SignUpVC.swift
//  XSWAR
//
//  Created by Jigar Kanani on 05/02/21.
//

import UIKit
import DropDown
import Firebase

struct Country: Decodable {
    
    var name : String
    var dial_code : String
    var code : String
    
}

class SignUpVC: UIViewController {

    @IBOutlet var imgFlag : UIImageView!
    @IBOutlet var lblCode : UILabel!

    @IBOutlet var txtUserName : UITextField!
    @IBOutlet var txtMobile : UITextField!
    @IBOutlet var txtEmail : UITextField!
    @IBOutlet var txtAddress : UITextField!

    @IBOutlet var txtOTP : UITextField!

    @IBOutlet var viewOTP : UIView!
    @IBOutlet var viewMobile : UIView!

    
    @IBOutlet var btnResend : UIButton!
    
    @IBOutlet var btnSignUp : UIButton!

    var count = 60
    var completion: CompletionToGetDataBack = {_   in }
    let dropDown = DropDown()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if appDelegate.userSignUpData != nil
        {
            self.txtUserName.text = appDelegate.userSignUpData.data!.name
            self.txtMobile.text = appDelegate.userSignUpData.data!.mobile
            self.txtEmail.text = appDelegate.userSignUpData.data!.email
            self.txtAddress.text = appDelegate.userSignUpData.data!.deliveryAddress
            
            self.txtUserName.textColor = .lightGray
            self.txtMobile.textColor = .lightGray
            self.txtEmail.textColor = .lightGray
            
            self.txtUserName.isEnabled = false
            self.txtMobile.isEnabled = false
            self.txtEmail.isEnabled = false
            
            btnSignUp.setTitle("Sign In", for: .normal)
        }
        
        self.imgFlag.image = UIImage.init(named: String.init(format: "CountryPicker.bundle/%@", "IN"))
        
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.red
        DropDown.appearance().textFont = UIFont.init(name: "LiberationSans-Bold", size: 17.0)!
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.white
        DropDown.appearance().cellHeight = 40
        DropDown.appearance().setupCornerRadius(8)
        
        DropDown.startListeningToKeyboard()
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 36, y: viewMobile.frame.origin.y + topPadding + 20)

        dropDown.width = SCREEN_WIDTH - 72
        dropDown.anchorView = view
        
        var country : [String] = []
        var sCountry : Country!
        var indexC = Int()

        for name in self.getCountries()
        {
            if name.code == "LB"
            {
                sCountry = name
                indexC = self.getCountries().firstIndex(where: {$0.code == name.code})!
            }
            country.append(name.name)
        }
        
        dropDown.dataSource = country
            
        dropDown.cellNib = UINib(nibName: "MyDDCell", bundle: nil)
        dropDown.selectRow(indexC, scrollPosition: .top)
        
        self.lblCode.text = sCountry?.dial_code
        self.imgFlag.image = UIImage.init(named: String.init(format: "CountryPicker.bundle/%@", sCountry!.code))
        
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
           guard let cell = cell as? MyDDCell else { return }
            
            let object = self.getCountries()[index]
            cell.lblNumber.isHidden = true
            cell.logoImageView.image = UIImage.init(named: String.init(format: "CountryPicker.bundle/%@", object.code))
            cell.optionLabel.text = object.name
            cell.lblCode.text = object.dial_code
        }
        
        dropDown.dismissMode = .onTap
    }
    
    @IBAction func btnCountryCodeTapped(_ sender : UIButton)
    {
        self.view.endEditing(true)
        
        dropDown.show()
        
        dropDown.selectionAction = { [weak self] (index, item) in
            
            let selCountry = self?.getCountries()[index]
            self!.lblCode.text = selCountry?.dial_code
            self!.imgFlag.image = UIImage.init(named: String.init(format: "CountryPicker.bundle/%@", selCountry!.code))
        }
    }
    
    func getCountries()->[Country]{
        
        var source = [Country]()
        
        if let data = NSData(contentsOfFile: Bundle.main.path(forResource: "countryCodes", ofType: "json") ?? "") as Data? {
            do{
                source = try JSONDecoder().decode([Country].self, from: data)
                
            } catch let err {
                print(err.localizedDescription)
            }
        }
        return source
    }
    
    @IBAction func btnBackClick(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnResendClick(_ sender: UIButton)
    {
        count = 60
        
        let mobileNumber = self.lblCode.text?.appending(self.txtMobile.text ?? "")
        
        PhoneAuthProvider.provider().verifyPhoneNumber(mobileNumber!, uiDelegate: nil) { (verificationID, error) in
           
            if let error = error
            {
                self.showAlertWithTitle(alertTitle: "", msg: error.localizedDescription)
                return
            }
            
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
        }
    }
    
    @IBAction func btnProcessClick(_ sender: UIButton)
    {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID ?? "", verificationCode: self.txtOTP.text ?? "")
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            
            if let error = error
            {
                self.showAlertWithTitle(alertTitle: "", msg: error.localizedDescription)
                return
            }
            
            //SUCCESS
            let dicSignUp = ["mobile" : self.txtMobile.text ?? "",
                             "email" : self.txtEmail.text ?? "",
                             "password" : "123456",
                             "name" : self.txtUserName.text ?? "",
                             "device_type" : DEVICE_TYPE,
                             "fcm_token" : appDelegate.deviceToken,
                             "delivery_address" : self.txtAddress.text ?? ""]

            let URL_API = BASE_URL.appending(API_REGISTER)
            
            APIParser.dataWithURL(url: URL_API, requestType:.TYPE_DELETE, bodyObject: dicSignUp, imageObject: [], isShowProgress: true, isHideProgress: true) { (response, data) in

                let userSignUpData = try! UserSignUpData.init(data: data)

                if userSignUpData.success!
                {
                    appDelegate.userSignUpData = userSignUpData

                    UserDefaults.standard.setValue(data, forKey: "UserData")
                    UserDefaults.standard.synchronize()
                    
                    self.completion(data)
                    
                    if #available(iOS 13.0, *) {
                        sceneDelegate.setRoot()
                    } else {
                        appDelegate.setRoot()
                    }

                }
                else
                {
                    self.showAlertWithTitle(alertTitle: "", msg: userSignUpData.message!)
                }
            }
            
            self.view.endEditing(true)
            
        }
    }
    
    @IBAction func btnSignUpClick(_ sender: UIButton)
    {
        if appDelegate.userSignUpData != nil
        {
            let URL_API = BASE_URL.appending(UPDATE_ADDRESS).appending("?delivery_address=\(txtAddress.text ?? "")")
                        
            APIParser.dataWithURL(url: URL_API, requestType:.TYPE_PATCH, bodyObject: [:], imageObject: [], isShowProgress: false, isHideProgress: true) { (response, data) in
                   
                let data = (UserDefaults.standard.value(forKey: "UserData"))

                appDelegate.userSignUpData.data?.deliveryAddress = self.txtAddress.text ?? ""
                
                self.completion(data as! Data)
                
                if #available(iOS 13.0, *) {
                    sceneDelegate.setRoot()
                } else {
                    appDelegate.setRoot()
                }
            }
        }
        else
        {
            
            if self.txtMobile.text == "" {
                
                self.showAlertWithTitle(alertTitle: "", msg: "Enter Mobile number.")
                return
            }
            else if self.txtUserName.text == ""
            {
                self.showAlertWithTitle(alertTitle: "", msg: "Please enter username.")
                return
            }
            else if self.txtAddress.text == ""
            {
                self.showAlertWithTitle(alertTitle: "", msg: "Please enter address.")
                return
            }
            
            viewOTP.isHidden = false
            
            Auth.auth().languageCode = "en";
            
            let mobileNumber = self.lblCode.text?.appending(self.txtMobile.text ?? "")

            PhoneAuthProvider.provider().verifyPhoneNumber(mobileNumber!, uiDelegate: nil) { (verificationID, error) in
               
                if let error = error
                {
                    self.showAlertWithTitle(alertTitle: "", msg: error.localizedDescription)
                    return
                }
                
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            }
            
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
                if self.count > 0
                {
                    self.count -= 1
                    self.btnResend.isUserInteractionEnabled = false
                    self.btnResend.setTitle(String.init(format: "Resend in %d", self.count), for: .normal)
                }
                else
                {
                    Timer.invalidate()
                    self.btnResend.isUserInteractionEnabled = true
                    self.btnResend.setTitle("Resend Code", for: .normal)
                }
            }
        }
    }
    
    @IBAction func btnloginDealerClick(_ sender: UIButton)
    {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(loginVC, animated: true)
        
    }
}


extension SignUpVC : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
