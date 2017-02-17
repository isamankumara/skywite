//
//  SWOfflineManager.swift
//  SkyWite
//
//  Created by Saman kumara on 1/27/17.
//  Copyright © 2017 Saman Kumara. All rights reserved.
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//https://github.com/skywite
//

import Foundation

private let USER_DEFAULT_KEY : String = "SWOfflineReqeustsOnUserDefault"


/// This class will handle all the offline request
class SWOfflineManager {
    
    private(set) var expireTime: Int64?
    private var successBlock : ((SWReqeust, AnyObject?) -> Void)?
    private var failureBlock : ((SWReqeust, Error) -> Void)?
    
    /// This is class function and it will help to create shared instance
    ///
    /// - Parameter seconds: expire time as seconds
    class func requestExpireTime(seconds: Int64) {
        let offlineManger = SWOfflineManager.sharedInstance
        offlineManger.expireTime = seconds
        offlineManger.startReachabilityStatus()
    }
    
    /// Static Shared instance. This will return SWOfflineManger object
    static let sharedInstance: SWOfflineManager = SWOfflineManager()

    /// When calling this method offline operation array will be return
    ///
    /// - Returns: offline operation array
    func offlineOparations() -> NSMutableArray {
        let array : NSMutableArray = []
        for data in getSaveArray() {
            do {
                let operation = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as! NSData) as? SWReqeust
                if (Int64((operation?.requestSavedDate?.timeIntervalSinceReferenceDate)!) > self.expireTime! ) {
                    array.add(operation!)
                }
            }
            catch {}
            
        }

        return array
    }
    
    /// Callling this method can save request
    ///
    /// - Parameter array: saved array will be return
    private func saveRequests(array: NSMutableArray) {
        let list : NSMutableArray = []
        for operation in array {
            let data = NSKeyedArchiver.archivedData(withRootObject: operation)
            list.add(data)
        }
        UserDefaults.standard.set(array, forKey: USER_DEFAULT_KEY)
        UserDefaults.standard.synchronize()
    }
    
    private func getSaveArray() -> NSMutableArray {
        if (UserDefaults.standard.object(forKey: USER_DEFAULT_KEY) != nil) {
            return NSMutableArray.init(array: UserDefaults.standard.object(forKey: USER_DEFAULT_KEY) as! NSArray)
        }
        return NSMutableArray()
    }
    
    private func startReachabilityStatus() {
        SWReachability.checkNetowrk(currentNetworkStatus: { (status) in
            if (status != SWReachabilityStatus.NotReachable) {
                self.createOperations()
            }
        }) { (status) in
            if (status != SWReachabilityStatus.NotReachable) {
                self.createOperations()
            }
        }
    }
    
    /// Calling this method operataion will be add to the saved list to send request later
    ///
    /// - Parameter operation: SWreqeust object
    /// - Returns: Bool value for the save status
    func addRequestForSendLater(operation: SWReqeust) -> Bool {
        operation.requestSavedDate = NSDate()
        let list : NSMutableArray = getSaveArray()
        let data = NSKeyedArchiver.archivedData(withRootObject: operation)
        list.add(data)
        
        UserDefaults.standard.set(list, forKey: USER_DEFAULT_KEY)
        return UserDefaults.standard.synchronize()
    }
    
    private init() { }

    
    /// This method will use to remove complete task or saved list.
    ///
    /// - Parameter operation: SWRequest object
    func removeRequest(operation: SWReqeust) {
        var selectedData: NSData?
        var found : Bool = false
        for data in getSaveArray() {
            do {
                let savedOperation = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as! NSData) as? SWReqeust
                if (Int64((operation.requestSavedDate?.timeIntervalSinceReferenceDate)!) == Int64((savedOperation?.requestSavedDate?.timeIntervalSinceReferenceDate)!) ) {
                    selectedData = data as? NSData
                    found = true
                    break
                }
            }
            catch {}
        }
        
        if (found) {
            let array = getSaveArray()
            array.remove(selectedData!)
            UserDefaults.standard.set(array, forKey: USER_DEFAULT_KEY)
            UserDefaults.standard.synchronize()
        }
    }
    
    /// Calling this method remove all the saved requests
    func removeAllOperations() {
        let array: NSMutableArray = []
        saveRequests(array: array)
    }
    
    /// This method will use to create opration from saved request
    private func createOperations() {
        for operation in offlineOparations() {
            let swRequest = operation as! SWReqeust
            swRequest.createSession()
            
            if (swRequest.taskType == TaskType.upload) {
                swRequest.setUpload(succuess: { (task, responseObject) in
                    if (self.successBlock != nil) {
                        self.successBlock!(task.swRequest, responseObject)
                    }
                    self.removeRequest(operation: swRequest)
                }, failure: { (task, error) in
                    if (self.failureBlock != nil) {
                        self.failureBlock!((task?.swRequest)!, error)
                    }
                })
            }else if (swRequest.taskType == TaskType.download) {
                swRequest.setDownload(succuess: { (task, url) in
                    if (self.successBlock != nil) {
                        self.successBlock!(task.swRequest, nil)
                    }
                    self.removeRequest(operation: swRequest)

                }, failure: { (task, error) in
                    if (self.failureBlock != nil) {
                        self.failureBlock!((task?.swRequest)!, error)
                    }
                })
            }else if (swRequest.taskType == TaskType.data) {
                swRequest.setData(succuess: { (task, responseObject) in
                    if (self.successBlock != nil) {
                        self.successBlock!(task.swRequest, responseObject)
                    }
                    self.removeRequest(operation: swRequest)

                }, failure: { (task, error) in
                    if (self.failureBlock != nil) {
                        self.failureBlock!((task?.swRequest)!, error)
                    }
                })
            }
        }
    }
    
    /// This method will use to set the block to catch the success or failure status
    ///
    /// - Parameters:
    ///   - success: Success block
    ///   - failure: Failure block
    func request(success: @escaping((SWReqeust, AnyObject?)-> ()), failure: @escaping((SWReqeust, Error) -> ())) {
        successBlock = success
        failureBlock = failure
    }
}
