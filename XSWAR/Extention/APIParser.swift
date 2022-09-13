//
//  WebParserWS.swift
//  MyPetCredential
//
//  Created by Jigar Kanani on 1/1/16.
//  Copyright © 2016 Jigar Kanani LLC. All rights reserved.
//

import UIKit
import QuartzCore
import CoreGraphics
import SystemConfiguration

public class ImageData: Codable
{
    public var name: String?
    public var image: Data?
    public var filename: String?

    enum CodingKeys: String, CodingKey {
        case name
        case image
        case filename
    }

    public init(name: String?, image: Data?, filename: String?) {
        self.name = name
        self.image = image
        self.filename = filename
    }
}


let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
let appDelegate = UIApplication.shared.delegate as! AppDelegate

@available(iOS 13.0, *)
let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate  as! SceneDelegate

var bottomPadding: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0
var topPadding: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0.0


enum RequestType : String
{
    case TYPE_GET = "TYPE_GET",
         TYPE_POST = "TYPE_POST",
         TYPE_DELETE = "TYPE_DELETE",
         TYPE_PATCH = "TYPE_PATCH",
         TYPE_PUT = "TYPE_PUT"
}

var urlRequest : NSMutableURLRequest!
var session = URLSession()

/**
 * Add this method in ViewDidAppear for better use.
 * It helps you to check network connectivity and error handling automatically.
 *
 * @param dataWithURL
 */

class APIParser: NSObject
{
    class func dataWithURL(url:String,requestType:RequestType,bodyObject:[String :Any],imageObject:[ImageData],isShowProgress:Bool,isHideProgress:Bool, completion: @escaping ([String : Any], Data) -> Void)
    {
        let sessionConfig = URLSessionConfiguration.default
        session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        let strUrl = NSString(format:"%@",url).addingPercentEscapes(using: String.Encoding.utf8.rawValue)
        let URL = NSURL(string:strUrl! as String)
        urlRequest = NSMutableURLRequest(url: URL! as URL)
        urlRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
        print("URL:-> %@ %@", url, bodyObject)
        
        if url.contains(API_GET_NOTIFICATIONS_DEALER) || url.contains(API_CHANGE_REQUEST_STATUS_DELEAR) || url.contains(API_READ_NOTIFICATION)
        {
            if appDelegate.dealerLoginData != nil
            {
                let accessToken = "Bearer " + appDelegate.dealerLoginData.token!
                urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
                urlRequest.addValue(accessToken, forHTTPHeaderField: "Authorization")
            }
            else
            {
                if appDelegate.userSignUpData != nil
                {
                    let accessToken = "Bearer " + appDelegate.userSignUpData.token!
                    urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
                    urlRequest.addValue(accessToken, forHTTPHeaderField: "Authorization")
                }
            }
        }
        else
        {
            if appDelegate.userSignUpData != nil
            {
                let accessToken = "Bearer " + appDelegate.userSignUpData.token!
                urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
                urlRequest.addValue(accessToken, forHTTPHeaderField: "Authorization")
            }
        }
        
        if(isShowProgress)
        {
            DispatchQueue.main.async()
            {
                var config : ProcessLoader.Config = ProcessLoader.Config()
                config.size = 100
                config.backgroundColor = UIColor.black
                config.spinnerColor = UIColor.white
                config.titleTextColor = UIColor.white
                config.spinnerLineWidth = 1.0
                config.foregroundColor = UIColor.black
                config.foregroundAlpha = 0.5
                ProcessLoader.setConfig(config: config)
                ProcessLoader.show(animated: true)
                ProcessLoader.show(title: "Loading...", animated: true)
            }
        }
        
        
        if (requestType == RequestType.TYPE_GET)
        {
            urlRequest.httpMethod = "GET"
        }
        else if (requestType == RequestType.TYPE_PATCH)
        {
            urlRequest.httpMethod = "PATCH"
        }
        else if(requestType == RequestType.TYPE_DELETE)
        {
            
            let boundary: String = "Boundary-\(UUID().uuidString)"
            let contentType = "multipart/form-data; boundary="+boundary
            urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
            
            let postbody: NSMutableData = NSMutableData()
            
            for data in bodyObject {
                
                let key  = data.key
                let value = data.value
                
                if key == "theFiles" {
                    
                    let imageArr = value as! [UIImage]
                    
                    for i in 0..<imageArr.count {
                                              
                        let filename = "Img.jpg"
                        
                        print("ImageName:-", filename)
                        
                        postbody.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                        postbody.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\(filename)\r\n".data(using: String.Encoding.utf8)!)
                        postbody.append("Content-Type: image/jpg\r\n\r\n".data(using: String.Encoding.utf8)!)
                        postbody.append((imageArr[i]).jpegData(compressionQuality: 1.0)!)
                        
                    }
                    
                } else {
                    
                    postbody.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                    postbody.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".data(using: String.Encoding.utf8)!)
                    
                }
            }
            
            postbody.append("\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            
            urlRequest.httpMethod = "POST";
            urlRequest.httpBody = postbody as Data
            
        }
        else if (requestType == RequestType.TYPE_PUT)
        {
            urlRequest.httpMethod = "PUT"
        }
        else if(requestType == RequestType.TYPE_POST)
        {

            let boundary: String = "Boundary-\(UUID().uuidString)"
            let contentType = "multipart/form-data; boundary="+boundary
            urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
            
            var postbody = Data()
                
            for (key, value) in bodyObject
            {
                postbody.appendString(string: "--\(boundary)\r\n")
                postbody.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                postbody.appendString(string: "\(value)\r\n")
            }
                            
            for imageData in imageObject
            {
                print("Uploading Image...")
                let filename = imageData.filename
                postbody.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
                postbody.append("Content-Disposition: form-data; name=\"\(imageData.name ?? "")\"; filename=\"\(filename ?? "")\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                postbody.append(imageData.image!)
                postbody.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
            }
            
            postbody.append("\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            
            urlRequest.httpMethod = "POST";
            urlRequest.httpBody = postbody as Data
        }
                
        if !InternetConnectionManager.isConnectedToNetwork()
        {
            DispatchQueue.main.async()
            {
                self.hideProgressHud()
            }
            if let topController = UIApplication.topViewController()
            {
                let noConnection = NoConnection()
                noConnection.modalPresentationStyle = .fullScreen
                topController.present(noConnection, animated: true, completion: nil)
            }
            else if let topController = UIApplication.getTopViewController()
            {
                let noConnection = NoConnection()
                noConnection.modalPresentationStyle = .fullScreen
                topController.present(noConnection, animated: true, completion: nil)
            }
            
            return
        }
        
        session.dataTask(with: urlRequest as URLRequest, completionHandler: {(data,response, error) -> Void in
            if (error == nil)
            {
                DispatchQueue.main.async()
                {
                    if isHideProgress
                    {
                        self.hideProgressHud()
                    }
                    
                    let responseString = String(data: data!, encoding: String.Encoding.utf8) ?? ""
                    let json = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("=====================", json!)
                    do{
                        if let dicResonseData = TEZFunc().convertToDictionary(text: responseString), dicResonseData.count > 0
                        {
                            completion(dicResonseData, data!)
                        }
                        else if let dicResonseData = TEZFunc().convertToArray(text: responseString), dicResonseData.count > 0, dicResonseData.count > 0
                        {
                            completion(["responseArray" : dicResonseData], data!)
                        }
                        else
                        {
                            completion([:], data!)
                        }
                    }
                    catch
                    {
                        print("Error is \(error)")
                        self.hideProgressHud()
                    }
                }
            }
            else
            {
                print("URL Session Task Failed: %@", error!.localizedDescription);
                self.hideProgressHud()
            }
        }).resume()
    }
    
    class func showAlertWithTitle( alertTitle : String , msg:String )
    {
        if let topController = UIApplication.topViewController()
        {
            let alert = UIAlertController(title:alertTitle, message: msg, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            topController.present(alert, animated: true, completion: nil)
        }
        else if let topVC = UIApplication.getTopViewController()
        {
            let alert = UIAlertController(title:alertTitle, message: msg, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            topVC.present(alert, animated: true, completion: nil)
        }
    }
    
    class func removeNSNull(from dict: [String: Any]) -> [String: Any]
    {
        var mutableDict = dict
        let keysWithEmptString = dict.filter { $0.1 is NSNull }.map { $0.0 }
        
        for key in keysWithEmptString {
            mutableDict[key] = ""
        }
        
        return mutableDict
    }
    
    class func hideProgressHud()
    {
        ProcessLoader.hide()
    }
    
    class func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}


extension Data {
    mutating func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}


class NoConnection: UIViewController {
    
    var mainView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView = UIView.init(frame: self.view.bounds)
        mainView.backgroundColor = .white
        let imgNoConnection = UIImageView.init(frame: mainView.bounds)
        imgNoConnection.backgroundColor = .white
        imgNoConnection.image = TEZFunc().convertBase64ToImage(imageString: base64ImageString)
        imgNoConnection.contentMode = .scaleAspectFit
        imgNoConnection.backgroundColor = .white
        let btnRetry = UIButton.init(frame: CGRect.init(x: (SCREEN_WIDTH / 2) - 70, y: SCREEN_HEIGHT - 90, width: 140, height: 46))
        btnRetry.backgroundColor = .black
        btnRetry.cornerRadiuss = 8.0
        btnRetry.setTitle("Retry", for: .normal)
        btnRetry.setTitleColor(.white, for: .normal)
        btnRetry.titleLabel?.font = UIFont.init(name: "Avenir Next", size: 17.0)
        btnRetry.addTarget(self, action: #selector(self.btnRetryPress(_:)), for: .touchUpInside)
        mainView.addSubview(imgNoConnection)
        mainView.addSubview(btnRetry)

        self.view.addSubview(mainView)
    }
    
    @IBAction func btnRetryPress(_ sender : UIButton)
    {
        if InternetConnectionManager.isConnectedToNetwork()
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
