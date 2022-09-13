//
//  SendRequestVC.swift
//  XSWAR
//
//  Created by Jigar Kanani on 05/02/21.
//

import UIKit

class SendRequestVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var txtDescription : UITextView!
    @IBOutlet var txtPartName : UITextField!
    @IBOutlet var txtAttachments : UITextField!
    @IBOutlet var imgPart : UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var btnSend : UIButton!
    @IBOutlet weak var imgView: UIView!
    @IBOutlet weak var imgPartZ: UIImageView!
    
    var selectedPart : PartsList!
    var selectedBrand : Brand!
    var selectedmodels : MakingYear!
    var selectedmakingYears : MakingYear!
    var selectedCategory : CategoryList!
    var selectedService : ServiceCatList!
    var partType = String()
    var partImage : UIImage!
    var pathDic : [String:Any] = [:]
    var catID : Int = 0
    var isfromservice : Bool = false

    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: "Select part image to attach with request.", preferredStyle: .actionSheet)
    var viewController: UIViewController?
    
    var pickImageCallback : ((UIImage) -> ())?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgPart.isUserInteractionEnabled = true
        self.imgPart.isMultipleTouchEnabled = true
        
        self.btnSend.titleLabel!.textAlignment = NSTextAlignment.center
        self.txtAttachments.inputView = nil
        
        self.hideKeyboardWhenTappedAround()
        
        if isfromservice {
            
            lblTitle.text = "Your request/طلبك"

        } else {
            
            lblTitle.text = "SEND REQUEST"
        }
        
        self.txtDescription.text = "Description"
        
        let tapgesture = UITapGestureRecognizer.init(target: self, action: #selector(self.imgTapped(_sender:)))
        tapgesture.delegate = self
        self.imgPart.addGestureRecognizer(tapgesture)
        
     }
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func imgTapped( _sender : UITapGestureRecognizer) {
        
        imgView.isHidden = false
        imgPartZ.image = partImage
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func btnBackClick(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeClick(_ sender: UIButton)
    {
        imgView.isHidden = true
        
    }
    
    @IBAction func btnSubmitClick(_ sender: UIButton)
    {
        if isfromservice {
            
            if txtDescription.text == "" || txtDescription.text == "Description"
            {
                self.showAlertWithTitle(alertTitle: "", msg: "Enter description to send request.")
                return
            }
            if txtPartName.text == ""
            {
                self.showAlertWithTitle(alertTitle: "", msg: "Enter Part Name to send request.")
                return
            }
//            if appDelegate.userSignUpData == nil
//            {
//                let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
//                self.navigationController?.pushViewController(signUpVC, animated: true)
//
//                signUpVC.completion  = { (data) -> Void in
//
//                    self.navigationController?.popViewController(animated: true)
//                }
//            }
            DispatchQueue.main.async
            {
                let partsDic = ["part_name" : self.txtPartName.text!,
                                "description_by_user" : self.txtDescription.text!
                ] as [String : Any]
                
                var imageDic : [ImageData] = []
                
                if self.partImage != nil
                {
                    imageDic.append(ImageData.init(name: "attached_file_by_user", image: self.partImage.jpegData(compressionQuality: 0.4), filename: self.txtAttachments.text!))
                }
                
                
                if appDelegate.userSignUpData == nil
                {
                    let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
                    self.navigationController?.pushViewController(signUpVC, animated: true)
                    
                    signUpVC.completion  = { (data) -> Void in
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    let deliveryAdressVC = self.storyboard?.instantiateViewController(withIdentifier: "DeliveryAdressVC") as! DeliveryAdressVC
                    deliveryAdressVC.deliveryDic = partsDic
                    deliveryAdressVC.imgDic = imageDic
                    deliveryAdressVC.isFromOrder = false
                    deliveryAdressVC.isFromUsedPart = false
                    self.navigationController?.pushViewController(deliveryAdressVC, animated: true)
                }
            }
            
        } else {
            if txtDescription.text == "" || txtDescription.text == "Description"
            {
                self.showAlertWithTitle(alertTitle: "", msg: "Enter description to send request.")
                return
            }
            if txtPartName.text == ""
            {
                self.showAlertWithTitle(alertTitle: "", msg: "Enter Part Name to send request.")
                return
            }
            if appDelegate.userSignUpData == nil
            {
                let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
                self.navigationController?.pushViewController(signUpVC, animated: true)
                
                signUpVC.completion  = { (data) -> Void in
                    
                    DispatchQueue.main.async
                    {
                        
                        let partsDic = ["brand_id" : String(self.selectedBrand.brandID ?? 0),
                                        "category_id" : self.catID,
                                        "part_making_year" : self.selectedmakingYears.name ?? "",
                                        "model" : self.selectedmodels.name ?? "",
                                        "description_by_user" : self.txtDescription.text!,
                                        "part_type" : "\((self.pathDic["name"] as? String ?? "").replacingOccurrences(of: "Parts", with: ""))",
                                        "part_name" : self.txtPartName.text!,
                                        "delivery_address" : appDelegate.userSignUpData.data!.deliveryAddress ?? ""] as [String : Any] as [String : Any]
                        
                        var imageDic : [ImageData] = []
                        
                        if self.partImage != nil
                        {
                            imageDic.append(ImageData.init(name: "attached_file_by_user", image: self.partImage.jpegData(compressionQuality: 0.4), filename: self.txtAttachments.text!))
                        }
                        
                        let URL_API = BASE_URL.appending(SEND_USED_PART_REQUEST)
                        
                        APIParser.dataWithURL(url: URL_API, requestType:.TYPE_POST, bodyObject: partsDic, imageObject: imageDic, isShowProgress: true, isHideProgress: true) { (response, data) in
                            
                            print(response)
                            
                            let responseData = try! ResponseData.init(data : data)
                            
                            let alert = UIAlertController(title: "", message: "Your request was sent and we aim to find it and reply asap.لقد تم ارسال طلبك و نسعى لايجاده و الرد في اسرع وقت ممكن" , preferredStyle: UIAlertController.Style.alert)
                            
                            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
                                
                                if #available(iOS 13.0, *) {
                                    sceneDelegate.setRoot()
                                } else {
                                    appDelegate.setRoot()
                                }
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                }
            } else {
                DispatchQueue.main.async
                {
                    let partsDic = ["brand_id" : String(self.selectedBrand.brandID ?? 0),
                                    "category_id" : self.catID,
                                    "part_making_year" : self.selectedmakingYears.name ?? "",
                                    "model" : self.selectedmodels.name ?? "",
                                    "description_by_user" : self.txtDescription.text!,
                                    "part_type" : "\((self.pathDic["name"] as? String ?? "").replacingOccurrences(of: "Parts", with: ""))",
                                    "part_name" : self.txtPartName.text!,
                                    "delivery_address" : appDelegate.userSignUpData.data!.deliveryAddress ?? ""] as [String : Any] as [String : Any]
                    
                    var imageDic : [ImageData] = []
                    
                    if self.partImage != nil
                    {
                        imageDic.append(ImageData.init(name: "attached_file_by_user", image: self.partImage.jpegData(compressionQuality: 0.4), filename: self.txtAttachments.text!))
                    }
                    
                    let deliveryAdressVC = self.storyboard?.instantiateViewController(withIdentifier: "DeliveryAdressVC") as! DeliveryAdressVC
                    deliveryAdressVC.deliveryDic = partsDic
                    deliveryAdressVC.imgDic = imageDic
                    deliveryAdressVC.isFromOrder = false
                    deliveryAdressVC.isFromUsedPart = true
                    self.navigationController?.pushViewController(deliveryAdressVC, animated: true)
                    
                }
            }
        }
    }
}

extension SendRequestVC : UITextFieldDelegate, UISearchBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.txtAttachments
        {
            self.txtDescription.resignFirstResponder()
            self.view.endEditing(true)
            
            textField.resignFirstResponder()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool  {
        
        if textField == self.txtAttachments
        {
            self.txtDescription.resignFirstResponder()
            self.view.endEditing(true)
            
            textField.resignFirstResponder()
            
            ImagePickerManager().pickImage(self){ image in
                
                self.partImage = image
                self.imgPart.image = self.partImage
                self.txtAttachments.text = Date().description.appending(".png")
            }
        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView.text == "I want a used" {
            textView.text = ""
            textView.textColor = UIColor.init(red: 46.0/255.0, green: 137.0/255.0, blue: 167.0/255.0, alpha: 1.0)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if textView.text.isEmpty {
            textView.text = "I want a used"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if txtDescription.text == "Description" {
            
            self.txtDescription.text = ""
            
        }
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        if txtDescription.text == "" {
            
            self.txtDescription.text = "Description"
            
        }
        
        return true
    }
    
}

