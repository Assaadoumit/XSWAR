//
//  Constant.swift
//  ALL PHOTO FRAMES
//
//  Created by Jigar Kanani on 02/12/19.
//  Copyright © 2019 Jigar Kanani. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import CoreLocation

typealias completionAddress = ([String : Any]) -> Void

//    Apple Developer Account:

//    johnny.elkhoury.xswar@hotmail.com
//    @AppDev(2021)#


//    xswarleb@gmail.com
//    Xswar@123

//   com.xswar

private var __maxLengths = [UITextField: Int]()

let DEVICE_TYPE = "2"

let THEME_COLOR = UIColor.init(red: 15.0/255.0, green: 126.0/255.0, blue: 155.0/255.0, alpha: 1.0)  // #7F69D4

//var BASE_URL = "https://api.appcodiz.com/Xswar/xswar-web/api/"
//var BASE_PATH = "https://api.appcodiz.com/Xswar/xswar-web/storage/"

var BASE_URL = "https://xswar.app/api/"
var BASE_PATH = "https://xswar.app/storage/"

let GMS_MAP_KEY = "AIzaSyCVCJ2MRBjF2FRTrqEX7Y2ozwZINUeIfG8"

let API_BRANDLIST = "brand_list"
let API_CATEGORY = "categories"
let API_GET_PARTS = "parts?"
let API_GET_PART_DELEARS = "part-dealers?"
let API_SERVICE_CATEGORY = "service_categories"
let API_GET_GARRAGES_LIST = "services?"
let API_REGISTER = "signup-ios"
let API_LOGIN = "login"
let API_LOGOUT = "logout"

let SEND_NEW_PARTS_REQUEST = "send_new_parts_request"
let UPDATE_ADDRESS = "update_delivery_address"
let SEND_USED_PART_REQUEST = "send_used_parts_request"
let API_GET_NOTIFICATIONS_DEALER = "dealer/requests"
let API_GET_NOTIFICATIONS_USER = "user/requests"
let GET_MODEL_DETAILS = "brand_models?"
let GET_OLICATEGORIES : String = "oil_categories"
let GET_OLIS : String = "oils?"
let ORDER_OLIS : String = "order/oil"
let GET_TIRE : String = "tires?"
let TIRE_CATAGORY : String = "tire_categories"
let ORDER_TIRES : String = "order/tire"
let SEND_SPECIAL_REQUEST : String = "send_special_request"

let API_CHANGE_REQUEST_STATUS_DELEAR = "dealer/request_change_status?"
let API_CHANGE_REQUEST_STATUS_USER = "user/request_change_status?"

let API_READ_NOTIFICATION = "request/read?"

class Constant: NSObject {
    
    //MARK:- Show Alert
    static func showAlert(title: String, message: String, btnTitle: String) {
        
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let actionAction = UIAlertAction(title: btnTitle, style: .default, handler: nil)
        alert.addAction(actionAction)
        
        if #available(iOS 13.0, *) {
            
            sceneDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
            
        } else {
            
            appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
            
        }
    }
}
