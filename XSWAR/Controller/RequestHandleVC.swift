//
//  RequestHandleVC.swift
//  XSWAR
//
//  Created by Jigar Kanani on 05/02/21.
//

import UIKit



class RequestHandleVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var txtPartName : UILabel!

    @IBOutlet var txtDescription : UILabel!
    @IBOutlet var txtAttachments : UILabel!

    @IBOutlet var viewAccept : UIView!
    @IBOutlet var imgPartImage : UIImageView!
    var imagePart : UIImage!
    
    @IBOutlet var txtDescription2 : UITextField!
    @IBOutlet var txtPrice : UITextField!
    @IBOutlet var txtGuarantee : UITextField!
    
    @IBOutlet var imgPart : UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
     @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblGurantee: UILabel!
    @IBOutlet weak var imgAtchView: UIView!
    @IBOutlet weak var imgAtchZ: UIImageView!
    var selectedNoti : NotificationList!
    var isFromDashboard = Bool()
    
     override func viewDidLoad() {
        super.viewDidLoad()

        self.viewAccept.isHidden = true

//        if self.txtAttachments.text != ""
//        {
//            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//            txtAttachments.addGestureRecognizer(tap)
//        }
        
        var urlforImage = ""
        
        if selectedNoti.partType == "Used"
        {
            self.txtPartName.text = selectedNoti.partName
            self.txtDescription.text = selectedNoti.descriptionByUser
            urlforImage = selectedNoti.attachedFileByUser ?? ""
        }
        else if selectedNoti.partType == "New"
        {
            self.txtPartName.text = selectedNoti.part?.name
            self.txtDescription.text = selectedNoti.part.debugDescription
            urlforImage = (selectedNoti.part?.image)!
        }
        
        self.imgPart.sd_setImage(with: URL.init(string: BASE_PATH.appending(urlforImage)))
        
        let tapgesture = UITapGestureRecognizer.init(target: self, action: #selector(self.imgTapped(_sender:)))
        tapgesture.delegate = self
        self.imgPart.addGestureRecognizer(tapgesture)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        var urlforImage = ""
        
        if selectedNoti.partType == "Used"
        {
            urlforImage = selectedNoti.attachedFileByUser ?? ""
        }
        else if selectedNoti.partType == "New"
        {
            urlforImage = (selectedNoti.part?.image)!
        }
        
        let imageInfo:JTSImageInfo = JTSImageInfo()
        imageInfo.imageURL = URL.init(string: BASE_PATH.appending(urlforImage as? String ?? ""))
        
        let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.image, backgroundStyle: JTSImageViewControllerBackgroundOptions.blurred)
        imageViewer?.modalPresentationStyle = .fullScreen
        imageViewer?.dismissalDelegate = self
        imageViewer?.show(from: self, transition: .fromOriginalPosition)

    }
    
    
    @IBAction func btnBackClick(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton)
    {
        viewAccept.isHidden = true
    }
    
    @objc func imgTapped( _sender : UITapGestureRecognizer) {
        
        imgAtchView.isHidden = false
        imgAtchZ.image = imgPart.image
    }
    
    @IBAction func closeClick(_ sender: UIButton)
    {
        imgAtchView.isHidden = true
     }
    
    @IBAction func btnImageClick(_ sender: UIButton)
    {
        ImagePickerManager().pickImage(self){ image in
            
            self.imagePart = image
            self.imgPartImage.image = self.imagePart
        }
    }
    
    @IBAction func btnAcceptClick(_ sender: UIButton)
    {
        if isFromDashboard
        {
            let URL_API = BASE_URL.appending(API_CHANGE_REQUEST_STATUS_USER).appending("request_id=\(self.selectedNoti.requestID ?? 0)&user_status=Accept")
            APIParser.dataWithURL(url: URL_API, requestType:.TYPE_PUT, bodyObject: [:], imageObject: [], isShowProgress: true, isHideProgress: true) { (response, data) in
                
                self.navigationController?.popViewController(animated: true)
            }
        }
        else
        {
            if self.selectedNoti.partType == "New"
            {
                let URL_API = BASE_URL.appending(API_CHANGE_REQUEST_STATUS_DELEAR)
                    
                let reqDic = ["request_id" : self.selectedNoti.requestID ?? 0, "dealer_status" : "Accept"] as [String : Any]
                
                APIParser.dataWithURL(url: URL_API, requestType:.TYPE_DELETE, bodyObject: reqDic, imageObject: [], isShowProgress: true, isHideProgress: true) { (response, data) in
                    
                    self.viewAccept.isHidden = true
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else
            {
                viewAccept.isHidden = false
                lblDescription.text = "Note ملحوظة"
                lblPrice.text = "Price السعر"
                lblGurantee.text = "Guarantee ملحوظة"
            }
        }
    }
    
    @IBAction func btnProcessAcceptClick(_ sender: UIButton)
    {
        if self.txtDescription2.text == ""
        {
            self.showAlertWithTitle(alertTitle: "", msg: "Please enter part description.")
            return
        }
        if self.txtPrice.text == ""
        {
            self.showAlertWithTitle(alertTitle: "", msg: "Please enter part price.")
            return
        }
        
        let URL_API = BASE_URL.appending(API_CHANGE_REQUEST_STATUS_DELEAR)
            
        let reqDic = ["request_id" : self.selectedNoti.requestID ?? 0,
                      "dealer_status" : "Accept",
                      "price" : self.txtPrice.text ?? "",
                      "description_by_dealer" : self.txtDescription2.text!,
                      "guarantee" : self.txtGuarantee.text ?? ""] as [String : Any]
        
        var imageDic : [ImageData] = []
        
        if self.imagePart != nil
        {
            imageDic.append(ImageData.init(name: "attached_file_by_dealer", image: self.imagePart.jpegData(compressionQuality: 0.4), filename: "image.png"))
        }
        
        APIParser.dataWithURL(url: URL_API, requestType:.TYPE_DELETE, bodyObject: reqDic, imageObject: imageDic, isShowProgress: true, isHideProgress: true) { (response, data) in
            
            self.viewAccept.isHidden = true
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnRejectClick(_ sender: UIButton)
    {
        if isFromDashboard
        {
            let URL_API = BASE_URL.appending(API_CHANGE_REQUEST_STATUS_USER).appending("request_id=\(self.selectedNoti.requestID ?? 0)&user_status=Reject")
            APIParser.dataWithURL(url: URL_API, requestType:.TYPE_PUT, bodyObject: [:], imageObject: [], isShowProgress: true, isHideProgress: true) { (response, data) in
                
                self.navigationController?.popViewController(animated: true)
            }
        }
        else
        {
            let reqDic = ["request_id" : self.selectedNoti.requestID ?? 0,
                          "dealer_status" : "Reject"] as [String : Any]
            
            let URL_API = BASE_URL.appending(API_CHANGE_REQUEST_STATUS_DELEAR)
            
            APIParser.dataWithURL(url: URL_API, requestType:.TYPE_DELETE, bodyObject: reqDic, imageObject: [], isShowProgress: true, isHideProgress: true) { (response, data) in
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension RequestHandleVC : UITextFieldDelegate, UISearchBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,JTSImageViewControllerDismissalDelegate
{
    func imageViewerDidDismiss(_ imageViewer: JTSImageViewController!) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.viewAccept.isHidden
        {
            textField.resignFirstResponder()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
