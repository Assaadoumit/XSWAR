//
//  OrderVc.swift
//  XSWAR
//
//  Created by Jigar Kanani on 02/12/21.
//

import UIKit

class OrderVc: UIViewController {

    @IBOutlet weak var imgOrder: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var lblQuanitity: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblType1: UILabel!
    @IBOutlet weak var typeTopHeight: NSLayoutConstraint!
    @IBOutlet weak var priceTopHeight: NSLayoutConstraint!
    
    var orderDic : [String:Any] = [:]
    var currentindex : Int = 1
    var isFromOilOrder : Bool = false
    var isFromTire : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFromOilOrder {
            
            lblPrice.text = "$ \(orderDic["price"] as? Int ?? 0) USD"
            lblDescription.text = orderDic["description"] as? String ?? ""
            lblQuanitity.text = "1"
            
            lblType1.isHidden = false
            lblType.isHidden = false
            typeTopHeight.constant = 32

            let type = orderDic["type"] as? [String: Any] ?? [:]
            lblType.text = type["name"] as? String ?? ""
            
            imgOrder.sd_setImage(with: URL.init(string: "\(BASE_PATH)\(orderDic["image"] as? String ?? "")"))
            
        } else if isFromTire {
            
            lblPrice.text = "$ \(orderDic["price"] as? Int ?? 0) USD"
            lblDescription.text = orderDic["description"] as? String ?? ""
            lblQuanitity.text = "1"
            imgOrder.sd_setImage(with: URL.init(string: "\(BASE_PATH)\(orderDic["image"] as? String ?? "")"))
            
            lblType1.isHidden = true
            lblType.isHidden = true
            typeTopHeight.constant = 0.0
            priceTopHeight.constant = 0.0
            
        } else {
            
            lblPrice.text = "$ \(orderDic["price"] as? Int ?? 0) USD"
            lblDescription.text = orderDic["description"] as? String ?? ""
            lblQuanitity.text = "1"
            
            imgOrder.sd_setImage(with: URL.init(string: "\(BASE_PATH)\(orderDic["image"] as? String ?? "")"))
            
        }
    }
    
}

//MARK:- API Response
extension OrderVc: responseDelegate {
    
    func didFinishWithSuccess(ServiceName: String, Response: [String : Any]) {
        
        DispatchQueue.main.async {
            
            print(Response)
            
            if (Response["success"] as? String ?? "") == "1" || (Response["success"] as? Int ?? 0) == 1 {
                
                if ServiceName == ORDER_OLIS {
                    
                    ALToastView.toast(in: self.view, withText: "Order placed successfully")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        
                        if #available(iOS 13.0, *) {
                            sceneDelegate.setRoot()
                        } else {
                            appDelegate.setRoot()
                        }
                        
                    })

                    
                } else if ServiceName == ORDER_TIRES {
                    
                    ALToastView.toast(in: self.view, withText: "Order placed successfully")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        
                        if #available(iOS 13.0, *) {
                            sceneDelegate.setRoot()
                        } else {
                            appDelegate.setRoot()
                        }
                        
                    })
                    
                }
                
            } else {
                
                if ServiceName == ORDER_OLIS {
                    
                    
                } else if ServiceName == ORDER_TIRES {
                    
                }
            }
        }
    }
}

//MARK:- Button Click
extension OrderVc {
    
    @IBAction func btnBackClick(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        
        currentindex = currentindex + 1
        lblQuanitity.text = "\(currentindex)"
        
        
    }
    
    @IBAction func removeTapped(_ sender: UIButton) {
        
        if currentindex > 1 {
            
            currentindex = currentindex - 1
            lblQuanitity.text = "\(currentindex)"
        }
        
    }
    
    @IBAction func orderTapped(_ sender: UIButton) {
        
        if appDelegate.userSignUpData == nil
        {
            let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
            self.navigationController?.pushViewController(signUpVC, animated: true)
            
            signUpVC.completion  = { (data) -> Void in
                                
                if self.isFromOilOrder {
                    
                    let parameter: [String: Any] = ["oil_id": self.orderDic["oil_id"] as? Int ?? 0,
                                                    "delivery_address": appDelegate.userSignUpData.data!.deliveryAddress ?? "",
                                                    "quantity": "\(self.currentindex)"]
                    
                    let apiURL = "\(BASE_URL)\(ORDER_OLIS)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    WebParserWS.fetchDataWithURL(url: apiURL!, type: .TYPE_POST_RAWDATA, ServiceName: ORDER_OLIS, bodyObject: parameter, delegate: self, isShowProgress: true, isHideProgress: true)
                    
                } else {
                    
                    let parameter: [String: Any] = ["tire_id": self.orderDic["tire_id"] as? Int ?? 0,
                                                    "delivery_address": appDelegate.userSignUpData.data!.deliveryAddress ?? "",
                                                    "quantity": "\(self.currentindex)"]
                    
                    let apiURL = "\(BASE_URL)\(ORDER_TIRES)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    WebParserWS.fetchDataWithURL(url: apiURL!, type: .TYPE_POST_RAWDATA, ServiceName: ORDER_TIRES, bodyObject: parameter, delegate: self, isShowProgress: true, isHideProgress: true)
                    
                }
            }
        }
        else
        {
            let deliveryAdressVC = self.storyboard?.instantiateViewController(withIdentifier: "DeliveryAdressVC") as! DeliveryAdressVC
            
            orderDic.updateValue("\(self.currentindex)", forKey: "quantity")
            
            deliveryAdressVC.deliveryDic = orderDic
            deliveryAdressVC.isFromOilOrder = self.isFromOilOrder
            deliveryAdressVC.isFromOrder = true
            deliveryAdressVC.isFromUsedPart = false
            self.navigationController?.pushViewController(deliveryAdressVC, animated: true)
        }
        
//        if isFromOilOrder {
//
//            let parameter: [String: Any] = ["oil_id" : self.orderDic["oil_id"] as? Int ?? 0,
//                                            "delivery_address" : appDelegate.userSignUpData.data!.deliveryAddress ?? "",
//                                            "quantity": "\(self.currentindex)"]
//
//            let apiURL = "\(BASE_URL)\(ORDER_OLIS)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
//            WebParserWS.fetchDataWithURL(url: apiURL!, type: .TYPE_POST_RAWDATA, ServiceName: ORDER_OLIS, bodyObject: parameter, delegate: self, isShowProgress: true, isHideProgress: true)
//
//        } else {
//
//
//            let parameter: [String: Any] = ["tire_id" : self.orderDic["tire_id"] as? Int ?? 0,
//                                            "delivery_address" : appDelegate.userSignUpData.data!.deliveryAddress ?? "",
//                                            "quantity": "\(self.currentindex)"]
//
//            let apiURL = "\(BASE_URL)\(ORDER_TIRES)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
//            WebParserWS.fetchDataWithURL(url: apiURL!, type: .TYPE_POST_RAWDATA, ServiceName: ORDER_TIRES, bodyObject: parameter, delegate: self, isShowProgress: true, isHideProgress: true)
//
//        }
        
    }
}

