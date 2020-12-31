//
//  AFWrapper.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 03/05/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AFWrapper: NSObject {
    
//MARK: API URL
    
     //Live Base Url
     /*"https://skilex.in/apicustomer/"*/
    
     //Development Base Url
     /*"https://skilex.in/development/apicustomer/"*/
    
     //Live Base Url For PaymentGateway
     /*"https://skilex.in/"*/
    
     //Development Base Url For PaymentGateway
     /*"https://www.skilex.in/development"*/
     
    //static let BASE_URL = "https://skilex.in/development/apicustomer/"
    
static let BASE_URL = "https://skilex.in/development/apicustomerios/"
static let PaymentBaseUrl = "https://www.skilex.in/development/"
//
//static let BASE_URL = "https://skilex.in/apicustomerios/"
//static let PaymentBaseUrl = "https://skilex.in/"

    public static let sharedManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 0
        let manager = Alamofire.SessionManager(configuration: configuration, delegate: SessionManager.default.delegate)
        return manager
    }()
    
    public static let almosharedManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        let manager = Alamofire.SessionManager(configuration: configuration, delegate: SessionManager.default.delegate)
        return manager
    }()

    class func cancelAllRequests() {
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
    
    class func setTimerforPostRequest (_ strURL : String, params : [String:String]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void)
   throws {

    sharedManager.request(strURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
         
         print(responseObject)
  
         if responseObject.result.isSuccess
         {
             let resJson = JSON(responseObject.result.value!)
             success(resJson)
         }
 
         if responseObject.result.isFailure
         {
             let error : Error = responseObject.result.error!
             failure(error)
         }
     }
        
    }
    
    class func requestGETURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void)
    throws {
        Alamofire.request(strURL).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
             
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
                if error._code == NSURLErrorTimedOut {
                    print("Request timeout!")
                    self.cancelAllRequests()
                }
            }
        }
        
    }
    
    class func requestPOSTURL(_ strURL : String, params : [String:String]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void)
    throws {
        
        Alamofire.request(strURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess
            {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            
            if responseObject.result.isFailure
            {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
     
    class func uploadMultipartFormData(_ strURL : String, params : [String : AnyObject]?, imageDataArray: [Data],imageNamesArray: [String], headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (NSError) -> Void) throws {
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            var secondCounter = 0
            for data in imageDataArray {
                print(imageDataArray[secondCounter])
                MultipartFormData.append(data, withName: imageNamesArray[secondCounter], fileName: imageNamesArray[secondCounter] + "myImage.png", mimeType: "image/png")
                
                MultipartFormData.append(data, withName: imageNamesArray[secondCounter], fileName: imageNamesArray[secondCounter] + "myImage.png", mimeType: "image/png")
                secondCounter = secondCounter + 1
            }
            
              /* not in use */
//            let contentDict = params as? [String: String]
//            for (key, value) in contentDict! {
//                MultipartFormData.append(value.data(using: .utf8)!, withName: key)
//            }

        },  to: strURL, method: .post, headers: nil, encodingCompletion: { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (dataResponse) in
                    if dataResponse.result.error != nil {
                        failure(dataResponse.result.error! as NSError)
                    }
                    else {
                        if dataResponse.result.isSuccess {
                            let resJson = JSON(dataResponse.result.value!)
                            success(resJson)
                        }
                        if dataResponse.result.isFailure {
                            let error : Error = dataResponse.result.error!
                            failure(error as NSError)
                        }
                        print(dataResponse.result.value as Any)
                    }
                })
            case .failure(let encodingError):
                failure(encodingError as NSError)
            }
        })
    }
}

