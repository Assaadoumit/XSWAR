//
//  NotificationDetailsVC.swift
//  XSWAR
//
//  Created by Jigar Kanani on 24/03/21.
//

import UIKit

class NotificationDetailsVC: UIViewController {

    @IBOutlet var lblTop : UILabel!
    @IBOutlet var imgCar : UIImageView!

    @IBOutlet var lblDesc : UILabel!
    @IBOutlet var lblSeller : UILabel!
    @IBOutlet var lblPrice : UILabel!

    @IBOutlet var lbltitleSeller : UILabel!
    @IBOutlet var lbltitleDesc : UILabel!

     @IBOutlet var btnOrder : UIButton!

    var notificationDic : NotificationList!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if notificationDic.dealerStatus == "Accept" && notificationDic.userStatus != "Accept"
        { 
            if notificationDic.partType == "Used"
            {
                self.btnOrder.isHidden = false
                
                self.lblDesc.text = notificationDic.descriptionByDealer
                self.lblSeller.text = notificationDic.guarantee != "" ? notificationDic.guarantee?.appending(" day's") : "No Guarantee"
                self.lblPrice.text = String(notificationDic.price!).appending("$")
                
                self.imgCar.sd_setImage(with: URL.init(string: BASE_PATH.appending(notificationDic.attachedFileByDealer ?? "")), placeholderImage: UIImage.init(named: "Logo"))
            }
            else
            {
                self.btnOrder.isHidden = true
                
                self.lbltitleDesc.text = "Part Name"
                self.lbltitleSeller.text = "Part Description"
                
                self.lblDesc.text = notificationDic.part?.name
                self.lblSeller.text = notificationDic.part?.partDescription
                self.lblPrice.text = String(notificationDic.part!.price!).appending("$")
                
                self.imgCar.sd_setImage(with: URL.init(string: BASE_PATH.appending(notificationDic.part?.image ?? "")), placeholderImage: UIImage.init(named: "Logo"))
            }
        }
        else if notificationDic.userStatus == "Accept" && notificationDic.dealerStatus == "Accept"
        {
            if notificationDic.partType == "New"
            {
                self.btnOrder.isHidden = true
                
                self.lbltitleDesc.text = "Part Name"
                self.lbltitleSeller.text = "Part Description"
                
                self.lblDesc.text = notificationDic.part?.name
                self.lblSeller.text = notificationDic.part?.partDescription
                self.lblPrice.text = String(notificationDic.part!.price!).appending("$")
                
                self.imgCar.sd_setImage(with: URL.init(string: BASE_PATH.appending(notificationDic.part?.image ?? "")), placeholderImage: UIImage.init(named: "Logo"))
            }
            else
            {
                self.btnOrder.isHidden = true
                
                self.lblDesc.text = notificationDic.descriptionByDealer
                self.lblSeller.text = notificationDic.guarantee != "" ? notificationDic.guarantee?.appending(" day's") : "No Guarantee"
                self.lblPrice.text = String(notificationDic.price!).appending("$")
                
                self.imgCar.sd_setImage(with: URL.init(string: BASE_PATH.appending(notificationDic.attachedFileByDealer ?? "")), placeholderImage: UIImage.init(named: "Logo"))
            }
        }
        else if notificationDic.partType == "New"
        {
            self.btnOrder.isHidden = true
            
            self.lbltitleDesc.text = "Part Name"
            self.lbltitleSeller.text = "Part Description"
            
            self.lblDesc.text = notificationDic.part?.name
            self.lblSeller.text = notificationDic.part?.partDescription
            self.lblPrice.text = String(notificationDic.part!.price!).appending("$")
            
            self.imgCar.sd_setImage(with: URL.init(string: BASE_PATH.appending(notificationDic.part?.image ?? "")), placeholderImage: UIImage.init(named: "Logo"))
        }
    }
    
    @IBAction func btnBackClick(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOrderClick(_ sender: UIButton)
    {
        let URL_API = BASE_URL.appending(API_CHANGE_REQUEST_STATUS_USER).appending("request_id=\(self.notificationDic.requestID ?? 0)&user_status=Accept")
        APIParser.dataWithURL(url: URL_API, requestType:.TYPE_PUT, bodyObject: [:], imageObject: [], isShowProgress: true, isHideProgress: true) { (response, data) in
            
            print(response)
            
            let responseData = try! ResponseData.init(data : data)
            
            let alert = UIAlertController(title: "", message: response["message"] as? String ?? "", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
                
                self.navigationController?.popViewController(animated: true)

                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
