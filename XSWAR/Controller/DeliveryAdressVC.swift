//
//  DeliveryAdressVC.swift
//  XSWAR
//
//  Created by Jigar Kanani on 25/11/21.
//

import UIKit

class DeliveryAdressVC: UIViewController {
    
    @IBOutlet weak var txtDeliveryAddress: UITextField!
    
    var deliveryDic : [String:Any] = [:]
    var imgDic : [ImageData] = []
    var isFromOilOrder : Bool = false
    var isFromOrder : Bool = false
    var isFromUsedPart : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if appDelegate.userSignUpData == nil {
        
            
        } else {
            
            txtDeliveryAddress.text = appDelegate.userSignUpData.data!.deliveryAddress ?? ""
            
        }
    }
    
    @IBAction func btnDeliveryClick(_ sender : UIButton)
    {
        
        if isFromOrder {
            
            if isFromOilOrder == true {
                
                let parameter: [String: Any] = ["oil_id" : self.deliveryDic["oil_id"] as? Int ?? 0,
                                                "delivery_address" : self.txtDeliveryAddress.text!,
                                                "quantity": deliveryDic["quantity"] as? String ?? ""]
                
                let apiURL = "\(BASE_URL)\(ORDER_OLIS)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                WebParserWS.fetchDataWithURL(url: apiURL!, type: .TYPE_POST_RAWDATA, ServiceName: ORDER_OLIS, bodyObject: parameter, delegate: self, isShowProgress: true, isHideProgress: true)
                
            } else {
                
                
                let parameter: [String: Any] = ["tire_id" : self.deliveryDic["tire_id"] as? Int ?? 0,
                                                "delivery_address" : self.txtDeliveryAddress.text!,
                                                "quantity": deliveryDic["quantity"] as? String ?? ""]
                
                let apiURL = "\(BASE_URL)\(ORDER_TIRES)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                WebParserWS.fetchDataWithURL(url: apiURL!, type: .TYPE_POST_RAWDATA, ServiceName: ORDER_TIRES, bodyObject: parameter, delegate: self, isShowProgress: true, isHideProgress: true)
                
            }
            
        } else  if isFromUsedPart {
            
            DispatchQueue.main.async
            {
                
                let URL_API = BASE_URL.appending(SEND_USED_PART_REQUEST)
                
                APIParser.dataWithURL(url: URL_API, requestType:.TYPE_POST, bodyObject: self.deliveryDic, imageObject: self.imgDic, isShowProgress: true, isHideProgress: true) { (response, data) in
                    
                    print(response)
                    
                    let responseData = try! ResponseData.init(data : data)
                    
                    let alert = UIAlertController(title: "", message: "Your request was sent and we aim to find it and reply asap.لقد تم ارسال طلبك و نسعى لايجاده و الرد في اسرع وقت ممكن" , preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
                        
                        if #available(iOS 13.0, *) {
                            sceneDelegate.setRoot()
                        } else {
                            appDelegate.setRoot()
                        }
//                        Your request was sent and we aim to find it and reply asap. لقد تم ارسال طلبك و نسعى لايجاده و الرد في اسرع وقت ممكن
//
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        } else {
            
            DispatchQueue.main.async
            {
                
                let URL_API = BASE_URL.appending(SEND_SPECIAL_REQUEST)
                
                APIParser.dataWithURL(url: URL_API, requestType:.TYPE_DELETE, bodyObject: self.deliveryDic, imageObject: self.imgDic, isShowProgress: true, isHideProgress: true) { (response, data) in
                    
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
 
    }
 
    @IBAction func btnBackClick(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

}

//MARK:- API Response
extension DeliveryAdressVC: responseDelegate {
    
    func didFinishWithSuccess(ServiceName: String, Response: [String : Any]) {
        
        DispatchQueue.main.async {
            
            print(Response)
            
            if (Response["success"] as? String ?? "") == "1" || (Response["success"] as? Int ?? 0) == 1 {
                
                if ServiceName == ORDER_OLIS {
                    
                    let alert = UIAlertController.init(title: "", message: "Your request was sent and we aim to find it and reply asap.لقد تم ارسال طلبك و نسعى لايجاده و الرد في اسرع وقت ممكن", preferredStyle: .alert)
                    
                    let actionAction = UIAlertAction(title: "ok", style: .default) { (alertAction) in
                        
                        if #available(iOS 13.0, *) {
                            sceneDelegate.setRoot()
                        } else {
                            appDelegate.setRoot()
                        }
                        
                    }
                    
                    alert.addAction(actionAction)
                    self.present(alert, animated: true, completion: nil)

                    
                    
                } else if ServiceName == ORDER_TIRES {
                    
                    let alert = UIAlertController.init(title: "", message: "Your request was sent and we aim to find it and reply asap.لقد تم ارسال طلبك و نسعى لايجاده و الرد في اسرع وقت ممكن" , preferredStyle: .alert)
                                                       
                    
                    let actionAction = UIAlertAction(title: "ok", style: .default) { (alertAction) in
                        
                        if #available(iOS 13.0, *) {
                            
                            sceneDelegate.setRoot()
                            
                        } else {
                            
                            appDelegate.setRoot()
                        }
                        
                    }
                    
                    alert.addAction(actionAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            } else {
                
                if ServiceName == ORDER_OLIS {
                    
                    let alert = UIAlertController.init(title: "", message: Response["message"] as? String ?? "", preferredStyle: .alert)
                    
                    let actionAction = UIAlertAction(title: "ok", style: .default) { (alertAction) in
                        
                        if #available(iOS 13.0, *) {
                            sceneDelegate.setRoot()
                        } else {
                            appDelegate.setRoot()
                        }
                        
                    }
                    
                    alert.addAction(actionAction)
                    self.present(alert, animated: true, completion: nil)
                    
                } else if ServiceName == ORDER_TIRES {
                    
                    let alert = UIAlertController.init(title: "", message: Response["message"] as? String ?? "", preferredStyle: .alert)
                    
                    let actionAction = UIAlertAction(title: "ok", style: .default) { (alertAction) in
                        
                        if #available(iOS 13.0, *) {
                            sceneDelegate.setRoot()
                        } else {
                            appDelegate.setRoot()
                        }
                        
                    }
                    
                    alert.addAction(actionAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                    
            }
        }
    }
}
