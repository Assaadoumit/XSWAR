//
//  WebParserWS.swift
//
//  Created by Jigar on 01/12/18.
//  Copyright © 2018 Jigar. All rights reserved.
//

import UIKit

enum ServiceType: String {
    
    case TYPE_GET = "TYPE_GET", TYPE_POST = "TYPE_POST", TYPE_POST_KEY = "TYPE_POST_KEY", TYPE_DELETE = "TYPE_DELETE", TYPE_POST_RAWDATA = "TYPE_POST_RAWDATA", TYPE_POST_IMAGE = "TYPE_POST_IMAGE", TYPE_POST_DATA_IMAGE = "TYPE_POST_DATA_IMAGE"
    
}

protocol responseDelegate {
    func didFinishWithSuccess(ServiceName: String, Response: [String: Any])
}

var Delegate: responseDelegate?

class WebParserWS: NSObject {
    
    class func fetchDataWithURL(url: String, type: ServiceType, ServiceName: String, bodyObject: [String :Any], delegate: responseDelegate, isShowProgress: Bool, isHideProgress: Bool) {
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        let URL = NSURL(string: url)
        let request = NSMutableURLRequest(url: URL! as URL)
        
        print("URL:- \(request)")
        print("Body:- \(bodyObject)")
        
        if GlobalFunction.iSinternetConnection() {
            
            DispatchQueue.main.async {
                
                if(isShowProgress) {
                    
                    var config : SwiftLoader.Config = SwiftLoader.Config()
                    config.size = 100
                    config.backgroundColor = UIColor.white
                    config.spinnerColor = THEME_COLOR
                    config.titleTextColor = THEME_COLOR
                    config.spinnerLineWidth = 1.0
                    config.foregroundColor = UIColor.black
                    config.foregroundAlpha = 0.5
                    SwiftLoader.setConfig(config: config)
                    SwiftLoader.show(animated: true)
                    SwiftLoader.show(title: "Loading...", animated: true)
                    
                } else {
                    
                    var config : SwiftLoader.Config = SwiftLoader.Config()
                    config.size = 100
                    config.backgroundColor = UIColor.white
                    config.spinnerColor = THEME_COLOR
                    config.titleTextColor = THEME_COLOR
                    config.spinnerLineWidth = 1.0
                    config.foregroundColor = UIColor.black
                    config.foregroundAlpha = 0.5
                    SwiftLoader.setConfig(config: config)
                    
                }
            }
            
            if appDelegate.dealerLoginData != nil
            {
                let accessToken = "Bearer " + appDelegate.dealerLoginData.token!
                request.addValue(accessToken, forHTTPHeaderField: "Authorization")
            }
            else
            {
                if appDelegate.userSignUpData != nil
                {
                    let accessToken = "Bearer " + appDelegate.userSignUpData.token!
                    request.addValue(accessToken, forHTTPHeaderField: "Authorization")
                }
            }
                        
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if type == ServiceType.TYPE_POST {
                
                var parameters = ""
                
                for data in bodyObject {
                    
                    let key  = data.key
                    let value = data.value
                    
                    parameters.append(contentsOf: "&\(key)=\(value)")
                    
                }
                
                parameters.remove(at: parameters.startIndex)
                
                request.httpMethod = "POST";
                request.httpBody = Data((parameters.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))!.utf8)
                
            } else if type == ServiceType.TYPE_POST_DATA_IMAGE {
                
                let boundary: String = "---------------------------14737809831466499882746641449"
                let contentType: String = "multipart/form-data; boundary=\(boundary)"
                
                request.addValue(contentType, forHTTPHeaderField: "Content-Type")
                request.addValue("Content-Disposition:form-data", forHTTPHeaderField: "Accept")
                
                let postbody: NSMutableData = NSMutableData()
                
                for data in bodyObject {
                    
                    let key  = data.key
                    let value = data.value
                    
                    if key == "theFiles" {
                        
                        let filename = "Img.jpg"
                        
                        postbody.append("\r\n--\(boundary)\r\n".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
                        postbody.append("\r\n--\(boundary)\r\n".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
                        postbody.append("Content-Disposition: form-data; name=\"\(key)\"; fileName=\"\(filename)\"\r\n".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
                        postbody.append(NSString(string: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue).rawValue)!)
                        
                    } else {
                        
                        postbody.append("\r\n--\(boundary)\r\n".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
                        postbody.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
                        postbody.append((value as AnyObject).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue).rawValue)!)
                        postbody.append("\r\n--\(boundary)--\r\n".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
                    }
                }
                
                request.httpMethod = "POST";
                request.httpBody = postbody as Data
                
            } else if type == ServiceType.TYPE_POST_RAWDATA {
                
                request.httpMethod = "POST"
                
                do {
                    
                    let arr = bodyObject
                    
                    let data = try JSONSerialization.data(withJSONObject: arr, options: JSONSerialization.WritingOptions(rawValue: UInt(0)))
                    
                    request.httpBody = data
                    
                } catch {
                    
                    print("Error is \(error)")
                    
                }
                
            } else if type == ServiceType.TYPE_POST_KEY {
                
                request.httpMethod = "POST"
                request.httpBody = (url.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSData) as Data
                
            } else if type == ServiceType.TYPE_GET {
                
                request.httpMethod = "GET"
                
            } else if type == ServiceType.TYPE_DELETE {
                
                request.httpMethod = "DELETE"
                
            } else if type == ServiceType.TYPE_POST_IMAGE {
                
                let filename = "Img.jpg"
                
                let boundary: String = "---------------------------14737809831466499882746641449"
                let contentType: String = "multipart/form-data; boundary=\(boundary)"
                
                request.addValue(contentType, forHTTPHeaderField: "Content-Type")
                
                let postbody: NSMutableData = NSMutableData()
                
                postbody.append("\r\n--\(boundary)\r\n".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
                postbody.append("\r\n--\(boundary)\r\n".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
                postbody.append("Content-Disposition: form-data; name=\"image\"; fileName=\"\(filename)\"\r\n".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
                postbody.append(NSString(string: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue).rawValue)!)
                
                let imageData = (bodyObject["image"] as? UIImage ?? UIImage()).jpegData(compressionQuality: 0.75)
                postbody.append(imageData! as Data)
                
                postbody.append("\r\n--\(boundary)--\r\n".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
                
                request.httpMethod = "POST";
                request.httpBody = postbody as Data
                
            }
            
            let task =  session.dataTask(with: request as URLRequest, completionHandler: {(data,response, error) -> Void in
                
                DispatchQueue.main.sync() {
                    
                    if isHideProgress {
                        
                        self.hideProgressHud()
                        
                    }
                }
                
                if (error == nil) {
                    
                    let responseString = String(data: data!, encoding: String.Encoding.utf8) ?? ""
                    
                    do {
                        
                        if let dicResonseData = try JSONSerialization.jsonObject(with: responseString.data(using: .utf8) ?? Data(), options:JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any], dicResonseData.count > 0 {
                            
                            delegate.didFinishWithSuccess(ServiceName: ServiceName, Response:dicResonseData)
                            
                        } else if let dicResonseData = try JSONSerialization.jsonObject(with: responseString.data(using: .utf8) ?? Data(), options:JSONSerialization.ReadingOptions.mutableContainers) as? [[String: Any]], dicResonseData.count > 0 {
                            
                            let nullDic: [String: Any] = ["arrDic": dicResonseData]
                            delegate.didFinishWithSuccess(ServiceName: ServiceName, Response: nullDic)
                            
                        } else {
                            
                            let nullDic: [String: Any] = [:]
                            delegate.didFinishWithSuccess(ServiceName: ServiceName, Response: nullDic)
                            
                        }
                        
                    } catch {
                        
                        let nullDic: [String: Any] = [:]
                        delegate.didFinishWithSuccess(ServiceName: ServiceName, Response: nullDic)
                        SwiftLoader.hide()
                        
                    }
                    
                } else {
                    
                   
                    
                    SwiftLoader.hide()
                    
                }
            })
            
            task.resume()
            
        } else {
            
          

        }
    }
    
    class func hideProgressHud() {
        
        SwiftLoader.hide()
    }
}
