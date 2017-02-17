//
//  SWReqeust.swift
//  SkyWite
//
//  Created by Saman kumara on 1/3/17.
//  Copyright © 2016 Saman Kumara. All rights reserved.
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
#if os(iOS) || os(watchOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import Cocoa
#endif
import Foundation

/// Task type emun
///
/// - data: URLSessionDataTask
/// - download: URLSessionDownloadTask
/// - upload: URLSessionUploadTask
enum TaskType:Int {
    case data = 0
    case download = 1
    case upload = 2
}

/// SWRequest created for handle send multiple type request (eg: GET, POST, DELETE, etc). It sub class for NSObject.. It will help to create task.
class SWReqeust: NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate,NSCoding {
    
    /// THis is genareted task
    private(set) var sessiontask: URLSessionTask?
    /// This property will you to assing task type
    var taskType: TaskType?
    /// The reqeust used by the task
    private(set) var reqeust: NSMutableURLRequest

    /// The user can pass custom object to apped response
    var userOjbect: AnyObject?
    
    /// Response will store to the this object
    private(set) var response: HTTPURLResponse?
    /// Response will append to the response object
    private(set) var responseData: NSMutableData
    /// Response statuscdoe
    private(set) var statusCode: Int?
    /// This is tag. Can assing int value
    var tag: Int?
    
    /// The error, if any, that occurred in the lifecycle of the request.
    private(set) var error: Error?
    
    /// Using this paramter user can send request automatically when connection awailable.
    var sendRequestLaterWhenOnline: Bool
    
    /// Response data type
    var responseDataType: SWResponseDataType
    
    #if os(iOS) || os(watchOS) || os(tvOS)
    /// This is only use for add loading view
    private(set) var parentView: UIView?
    /// THis is private and use for add loading view for parenetview
    private(set) var backgroudView: UIView?
    #elseif os(OSX)
    /// This is only use for add loading view
    private(set) var parentView: NSView?
    /// THis is private and use for add loading view for parenetview
    private(set) var backgroudView: NSView?
    #endif
    
    /// This time will use to save reqeuest send time
    var requestSavedDate: NSDate?
    /// Set custom time out (seconds) default 60 seconds
    var timeOut: Int
    /// Bool value need to set YES if some one want to use queue
    var wantToUseQueue: Bool
    /// This one need to set for generate request body
    var requestDataType: SWRequestDataType
    
    /// URLConnection that use to send reqeust
    private var connection: NSURLConnection?
    
    /// HTTP method
    var method: String?
    /// Multipart status
    var isMultipart: Bool
    /// Availble URL method
    var availableURLMethods: NSSet
    /// Files array
    var files = NSArray.init()
    /// This will be use session task
    private var sessionTask: URLSessionTask?
    
    /// cache block. This will call when cache is avaible
    var cacheBlock: ((CachedURLResponse, AnyObject) -> Void)?
    /// data success block. This wil call when data task success
    var dataSuccessBlock: ((URLSessionDataTask, AnyObject) -> Void)?
    /// upload success block. This will call when upload task success
    var uploadSuccessBlock: ((URLSessionUploadTask, AnyObject) -> Void)?
    /// download success block. This will call when download task success
    var downloadSuccessBlock: ((URLSessionDownloadTask, URL) -> Void)?
    /// failure block. This will call when fail task
    var failBlock: ((URLSessionTask?, Error) -> Void)?
    /// donwlaod progress block. this will call untill download complete
    var downloadPrgressBlock: ((Int64, Int64) -> Void)?
    /// upload progress blcok. this will call untill upload complete
    var uploadPrgressBlock: ((Int64, Int64) -> Void)?
    /// public init method
    override init() {
        self.reqeust                = NSMutableURLRequest.init()
        self.responseData           = NSMutableData.init()
        self.availableURLMethods    = NSSet.init(objects: "GET", "HEAD", "DELETE")
        self.requestDataType        = SWRequestFormData()
        self.responseDataType       = SWResponseStringDataType()
        self.isMultipart            = false
        self.sendRequestLaterWhenOnline = false
        self.timeOut                = 10
        self.wantToUseQueue         =  false
    }
    
    // MARK: NSCorderingn
    /// Decoded init method
    required convenience init(coder decorder: NSCoder) {
        self.init()
        self.reqeust            = decorder.decodeObject(forKey: "request") as! NSMutableURLRequest
        self.timeOut            = Int(decorder.decodeInt32(forKey: "timeOut"))
        self.method             = decorder.decodeObject(forKey: "method") as! String?
        self.availableURLMethods = decorder.decodeObject(forKey: "availableInURLMethods") as! NSSet
        self.isMultipart        = decorder.decodeBool(forKey: "isMultipart")
        self.requestSavedDate   = decorder.decodeObject(forKey: "requestSavedDate") as! NSDate?
        self.sendRequestLaterWhenOnline = decorder.decodeBool(forKey: "sendRequestLaterWhenOnline")
        self.responseDataType   = decorder.decodeObject(forKey: "responseDataType") as! SWResponseDataType
        self.userOjbect         = decorder.decodeObject(forKey: "userOjbect") as AnyObject?
        self.requestDataType   = decorder.decodeObject(forKey: "requestDataType") as! SWRequestDataType
        self.taskType           = TaskType(rawValue: Int(decorder.decodeInt32(forKey: "taskType")))
        self.sessionTask        = decorder.decodeObject(forKey: "sessionTask") as! URLSessionTask?
    }
    
    /// public encode method
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(reqeust, forKey: "request")
        aCoder.encode(timeOut, forKey: "timeOut")
        aCoder.encode(method, forKey: "method")
        aCoder.encode(availableURLMethods, forKey: "availableInURLMethods")
        aCoder.encode(isMultipart, forKey: "isMultipart")
        aCoder.encode(requestSavedDate, forKey: "requestSavedDate")
        aCoder.encode(sendRequestLaterWhenOnline, forKey: "sendRequestLaterWhenOnline")
        aCoder.encode(responseDataType, forKey: "responseDataType")
        aCoder.encode(userOjbect, forKey: "userOjbect")
        aCoder.encode(requestDataType, forKey: "requestDataType")
        aCoder.encode(Int((taskType?.rawValue)!), forKey: "taskType")
        aCoder.encode(sessionTask, forKey: "sessionTask")
    }
    
    /// Using this method user can get the response as a String
    ///
    /// - Returns: Response as a String
    func responseString() -> String {
        return String(data: self.responseData as Data, encoding: .utf8)!
    }

    // MARK: request method
    
    /// This method will show/hide network indicator
    ///
    /// - Parameter show: bool value to show hide status
    private func showNetworkActivityIdicator(show: Bool) {
        #if os(iOS) || os(watchOS)
        UIApplication.shared.isNetworkActivityIndicatorVisible = show
        #endif
    }
    
    /// This method will use to create a session when need. This no need for users.
    func createSession() {
        showNetworkActivityIdicator(show: true)
        
        let manager = SharedManger.sharedmanager()
        let cofiguration = URLSessionConfiguration.default
        if (manager.session == nil) {
            manager.session = URLSession(configuration: cofiguration, delegate: self, delegateQueue: manager.operationQueue)
        }
        
        if (self.taskType == TaskType.upload) {
            self.sessionTask = manager.session?.uploadTask(with: self.reqeust as URLRequest, from: self.requestDataType.getRequestBodyData() as Data)
        }else if (self.taskType == TaskType.download) {
            self.sessionTask = manager.session?.downloadTask(with: self.reqeust as URLRequest)
        }else {
            self.sessionTask = manager.session?.dataTask(with: self.reqeust as URLRequest)
        }
        
        self.sessionTask?.swRequest = self
        self.sessionTask?.resume()
        manager.runningTasks?.setObject(self.sessionTask!, forKey: "\(String(describing: self.sessionTask?.taskIdentifier))" as NSCopying)
    }
    
    /// This will add loading view for the given parent view
    private func addLoadingView() {
        
    #if os(iOS) || os(watchOS) || os(tvOS)
        self.backgroudView                  = UIView.init(frame :(self.parentView?.frame)!)
        self.backgroudView?.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
        
        var roundedView             = UIView.init(frame: CGRect(x:0, y:0, width:100, height:100))
        roundedView.backgroundColor = UIColor.black
        
        roundedView.layer.cornerRadius  = 5.0
        roundedView.layer.masksToBounds = true
        roundedView.layer.borderWidth   = 1.0
        roundedView.layer.borderColor   = UIColor.white.cgColor
        
        let indicator   = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        indicator.startAnimating()
        indicator.center = CGPoint(x: roundedView.frame.size.width / 2 , y: roundedView.frame.size.width / 2)

        if Bundle.main.path(forResource: "sw_loadingView", ofType: "nib") != nil {
            let array = Bundle.main.loadNibNamed("sw_loadingView", owner: nil, options: nil)
            roundedView = array?[0] as! UIView
            self.backgroudView?.center = (self.parentView?.center)!
        }else {
            roundedView.addSubview(indicator)
        }
        roundedView.center = (self.parentView?.center)!
        self.backgroudView?.addSubview(roundedView)
        self.parentView?.insertSubview(self.backgroudView!, at: 1000)
        
        #elseif os(OSX)
        self.backgroudView                  = NSView.init(frame :(self.parentView?.frame)!)
        self.backgroudView?.wantsLayer      = true
        self.backgroudView?.layer?.backgroundColor = NSColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        
        let roundedView             = NSView.init(frame: CGRect(x:((self.backgroudView?.frame.size.width)! / 2 - 50), y: ((self.backgroudView?.frame.size.height)! / 2 - 50) , width:100, height:100))
        roundedView.wantsLayer = true
        roundedView.layer?.backgroundColor = NSColor.gray.cgColor
        
        roundedView.layer?.cornerRadius  = 5.0
        roundedView.layer?.masksToBounds = true
        roundedView.layer?.borderWidth   = 1.0
        roundedView.layer?.borderColor   = NSColor.white.cgColor
        
        let indicator   = NSProgressIndicator.init(frame:  CGRect(x: ((roundedView.frame.size.width/2) - 15), y:((roundedView.frame.size.height/2) - 15), width:30, height:30))
        indicator.wantsLayer = true
        indicator.style = NSProgressIndicatorStyle.spinningStyle
        indicator.startAnimation(nil)
        roundedView.addSubview(indicator)
        self.backgroudView?.addSubview(roundedView)
        self.parentView?.addSubview(self.backgroudView!)
        #endif
    }
    
    /// Calling this method request task will start
    ///
    /// - Parameters:
    ///   - url: The url that user need to request
    ///   - params: the param this will be NSDictionary or String
    func start(url: String, params: AnyObject?) {
        self.reqeust.httpMethod = self.method!
        
        if (url.characters.count > 0) {
            self.reqeust.url = NSURL(string: url) as URL?
        }else {
            assert(url.characters.count == 0, "url is null value")
        }
        
        self.requestDataType.dataWithFiles(files: self.files as! [SWMedia], parameters: params ?? "")
        
        if (!self.availableURLMethods.contains(self.reqeust.httpMethod.uppercased())) {
            if ((self.reqeust.value(forHTTPHeaderField: "Content-Type")) == nil) {
                self.reqeust.setValue(self.requestDataType.getContentType(), forHTTPHeaderField: "Content-Type")
            }
            self.reqeust.httpBody = self.requestDataType.getRequestBodyData() as Data
            self.reqeust.setValue("\(self.requestDataType.getRequestBodyData().length)", forHTTPHeaderField: "Content-Length")
        }else {
            let quaryString = self.requestDataType.getQueryString()
            if (quaryString.characters.count > 0) {
                if (url.range(of:"?") != nil) {
                    self.reqeust.url = URL(string: "\(url)&\(quaryString)")
                }else {
                    print("-->>> \(url)?\(quaryString)")
                    self.reqeust.url = URL(string: "\(url)?\(quaryString)")
                }
            }
        }
        
        self.reqeust.cachePolicy = .reloadIgnoringCacheData
        self.reqeust.timeoutInterval = TimeInterval(self.timeOut)
        
        if (self.cacheBlock != nil) {
            let cachedResponse = URLCache.shared.cachedResponse(for: self.reqeust as URLRequest)
            if (cachedResponse != nil) {
                self.cacheBlock?(cachedResponse!, self.responseDataType.responseOjbectFromdData(data: (cachedResponse?.data)!) as AnyObject)
            }
        }
        
        if (!SWReachability.connected()) {
            if(self.sendRequestLaterWhenOnline) {
                _ = SWOfflineManager.sharedInstance.addRequestForSendLater(operation: self)
            }
            self.error = NSError(domain: "Connection not available", code: NSURLErrorNotConnectedToInternet, userInfo: [:])
            if (self.failBlock != nil){
                self.failBlock!(nil, self.error!)
            }
            return;
        }else {
            
        }
        
        if (self.parentView != nil) {
            self.addLoadingView()
        }
        
        if (!self.wantToUseQueue) {
            self.createSession()
        }
    }
    
    /// calling this method task will cancel
    func cancel() {
        if (self.sessionTask?.state == URLSessionTask.State.running) {
            self.sessionTask?.cancel()
        }
    }
    
    /// calling this method can get the upload progress inside the block
    ///
    /// - Parameter progress: upload progress
    func setUploadProgress(progress: ((Int64, Int64) -> ())? = nil) {
        self.sessionTask?.swRequest.uploadPrgressBlock = progress
    }
    
    /// calling this method can get the download progress inside the block
    ///
    /// - Parameter progress: download progress
    func setDownloadProgress(progress: ((Int64, Int64) -> ())? = nil) {
        self.sessionTask?.swRequest.downloadPrgressBlock = progress
    }
    
    /// calling this method can get the upload task success/ failiure status inside the block
    ///
    /// - Parameters:
    ///   - succuess: this block will call when request success
    ///   - failure: this block will call when request fail
    func setUpload(succuess: @escaping ((URLSessionUploadTask, AnyObject) -> ()), failure: @escaping ((URLSessionTask? ,Error) -> ()) ) {
        self.uploadSuccessBlock     = succuess
        self.failBlock              = failure
    }

    /// calling this method can get the data task success/ failiure status inside the block
    ///
    /// - Parameters:
    ///   - succuess: this block will call when request success
    ///   - failure: this block will call when request fail
    func setData(succuess: @escaping ((URLSessionDataTask, AnyObject) -> ()), failure: @escaping ((URLSessionTask? ,Error) -> ()) ) {
        self.dataSuccessBlock   = succuess
        self.failBlock          = failure
    }
    
    /// calling this method can get the download task success/ failiure status inside the block
    ///
    /// - Parameters:
    ///   - succuess: this block will call when request success
    ///   - failure: this block will call when request fail
    func setDownload(succuess: @escaping ((URLSessionDownloadTask, URL) -> ()), failure: @escaping ((URLSessionTask? ,Error) -> ())) {
        self.downloadSuccessBlock   = succuess
        self.failBlock              = failure
    }
    
    
    // MARK: Starting Download task

    ///  This method will help to generate request with download task different parameters
    ///
    /// - Parameters:
    ///   - url: The request URL
    ///   - params: The parameters. This should be NSDictionray or String.
    ///   - success: success block
    ///   - failure: failure block
    func startDownloadTask(url: String, params: AnyObject, success: @escaping ((URLSessionDownloadTask, URL) -> ()), failure: @escaping ((URLSessionTask?, Error) -> ())) {
        self.setDownload(succuess: success, failure: failure)
        self.taskType = TaskType.download
        self.start(url: url, params: params)
    }
    
    ///  This method will help to generate request with download task different parameters
    ///
    /// - Parameters:
    ///   - url: The request URL
    ///   - params: The parameters. This should be NSDictionray or String.
    ///   - parentView: parent view. This will help to add loading view.
    ///   - success: success block
    ///   - failure: failure block
    func startDownloadTask(url: String, params: AnyObject?, parentView: NSObject?, success: @escaping ((URLSessionDownloadTask, URL) -> ()), failure: @escaping ((URLSessionTask?, Error) -> ())) {
        #if os(iOS) || os(watchOS) || os(tvOS)
        self.parentView = parentView as? UIView
        #elseif os(OSX)
        self.parentView = parentView as? NSView
        #endif
        self.startDownloadTask(url: url, params: params!, success: success, failure: failure)
    }
    
    ///  This method will help to generate request with download task different parameters
    ///
    /// - Parameters:
    ///   - url: The request URL
    ///   - params: The parameters. This should be NSDictionray or String.
    ///   - parentView: parent view. This will help to add loading view.
    ///   - cache: Cache response block.
    ///   - success: success block
    ///   - failure: failure block
    func startDownloadTask(url: String, params: AnyObject?,  parentView: NSObject? ,  cache: @escaping ((CachedURLResponse, AnyObject) -> ()) , success: @escaping ((URLSessionDownloadTask, URL) -> ()), failure: @escaping ((URLSessionTask?, Error) -> ())) {
        self.cacheBlock = cache
        self.startDownloadTask(url: url, params: params!, parentView: parentView, success: success, failure: failure)
    }
    
    ///  This method will help to generate request with download task different parameters
    ///
    /// - Parameters:
    ///   - url: The request URL
    ///   - params: The parameters. This should be NSDictionray or String.
    ///   - parentView: parent view. This will help to add loading view.
    ///   - sendLaterIfOffline: To send offline request, User need to set YES.
    ///   - cache: Cache response block.
    ///   - success: success block
    ///   - failure: failure block
    func startDownloadTask(url: String, params: AnyObject? ,  parentView: NSObject?  , sendLaterIfOffline: Bool ,  cache: @escaping ((CachedURLResponse, AnyObject) -> ()) , success: @escaping((URLSessionDownloadTask, URL) -> ()), failure: @escaping ((URLSessionTask?, Error) -> ())) {
        self.sendRequestLaterWhenOnline = sendLaterIfOffline
        self.startDownloadTask(url: url, params: params!, parentView: parentView, cache:cache, success: success, failure: failure)
    }
    
    // MARK: Starting Data task
    
    ///  This method will help to generate request with data task different parameters
    ///
    /// - Parameters:
    ///   - url: The request URL
    ///   - params: The parameters. This should be NSDictionray or String.
    ///   - success: success block
    ///   - failure: failure block
    func startDataTask(url: String, params: AnyObject?, success: @escaping ((URLSessionDataTask, AnyObject) -> ()), failure: @escaping ((URLSessionTask?, Error) -> ())) {
        self.setData(succuess: success, failure: failure)
        self.taskType = TaskType.data
        self.start(url: url, params: params)
    }
    
    ///  This method will help to generate request with data task different parameters
    ///
    /// - Parameters:
    ///   - url: The request URL
    ///   - params: The parameters. This should be NSDictionray or String.
    ///   - parentView: parent view. This will help to add loading view.
    ///   - success: success block
    ///   - failure: failure block
    func startDataTask(url: String, params: AnyObject?, parentView: NSObject?, success: @escaping ((URLSessionDataTask, AnyObject) -> ()), failure: @escaping ((URLSessionTask?, Error) -> ())) {
        #if os(iOS) || os(watchOS) || os(tvOS)
            self.parentView = parentView as? UIView
        #elseif os(OSX)
            self.parentView = parentView as? NSView
        #endif
        self.startDataTask(url: url, params: params, success: success, failure: failure)
    }
    
    ///  This method will help to generate request with data task different parameters
    ///
    /// - Parameters:
    ///   - url: The request URL
    ///   - params: The parameters. This should be NSDictionray or String.
    ///   - parentView: parent view. This will help to add loading view.
    ///   - cache: Cache response block.
    ///   - success: success block
    ///   - failure: failure block
    func startDataTask(url: String, params: AnyObject?,  parentView: NSObject? ,  cache: @escaping ((CachedURLResponse, AnyObject) -> ()) , success: @escaping ((URLSessionDataTask, AnyObject) -> ()), failure: @escaping ((URLSessionTask?, Error) -> ())) {
        self.cacheBlock = cache
        self.startDataTask(url: url, params: params, parentView: parentView, success: success, failure: failure)
    }
    
    ///  This method will help to generate request with data task different parameters
    ///
    /// - Parameters:
    ///   - url: The request URL
    ///   - params: The parameters. This should be NSDictionray or String.
    ///   - parentView: parent view. This will help to add loading view.
    ///   - sendLaterIfOffline: To send offline request, User need to set YES.
    ///   - cache: Cache response block.
    ///   - success: success block
    ///   - failure: failure block
    func startDataTask(url: String, params: AnyObject?,  parentView: NSObject? , sendLaterIfOffline: Bool ,  cache: @escaping ((CachedURLResponse, AnyObject) -> ()) , success: @escaping ((URLSessionDataTask, AnyObject) -> ()), failure: @escaping ((URLSessionTask?, Error) -> ())) {
        self.sendRequestLaterWhenOnline = sendLaterIfOffline
        self.startDataTask(url: url, params: params, parentView: parentView, cache:cache, success: success, failure: failure)
    }
    
    // MARK NSURLSessionDownloadTask delegate
    
    public func urlSession(_ session: URLSession,
                           downloadTask: URLSessionDownloadTask,
                           didFinishDownloadingTo location: URL) {
        if (downloadTask.swRequest.downloadSuccessBlock != nil) {
            SharedManger.sharedmanager().runningTasks?.removeObject(forKey: "\(downloadTask.taskIdentifier)")
            downloadTask.swRequest.downloadSuccessBlock!(downloadTask, location)
            downloadTask.swRequest.showNetworkActivityIdicator(show: false)
        }
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didResumeAtOffset fileOffset: Int64,
                    expectedTotalBytes: Int64) {
        if(downloadTask.swRequest.downloadPrgressBlock != nil) {
            downloadTask.swRequest.downloadPrgressBlock!(fileOffset, expectedTotalBytes)
        }
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        if(downloadTask.swRequest.downloadPrgressBlock != nil) {
            downloadTask.swRequest.downloadPrgressBlock!(bytesWritten, totalBytesExpectedToWrite)
        }
    }
    
    
    // MARK NSURLSessionDataTask delegate
    
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive data: Data) {
        dataTask.swRequest.responseData .append(data)
    }
    
    // MARK NSURLSessionUploadTask delegate

    func urlSession(_ session: URLSession,
                             task: URLSessionTask,
                             didSendBodyData bytesSent: Int64,
                             totalBytesSent: Int64,
                             totalBytesExpectedToSend: Int64){
        if (task.swRequest.uploadPrgressBlock != nil) {
            task.swRequest.uploadPrgressBlock!(totalBytesSent, totalBytesExpectedToSend)
        }
    }
    
    // MARK NSURLSessionTaskDelegate
    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        
        DispatchQueue.main.async {
            let manager = SharedManger.sharedmanager()
            manager.runningTasks?.removeObject(forKey: "\(task.taskIdentifier)")
            task.swRequest.backgroudView?.removeFromSuperview()
            task.swRequest.showNetworkActivityIdicator(show: false)

            if ((error) != nil) {
                task.swRequest.failBlock!(task,error!)
            }else {
                let urlCache = URLCache.shared
                
                if (task.response != nil) {
                    urlCache.storeCachedResponse(CachedURLResponse.init(response: task.response!, data: task.swRequest.responseData as Data), for: task.swRequest.reqeust as URLRequest)
                }
                if (task.swRequest.dataSuccessBlock != nil) {
                    task.swRequest.dataSuccessBlock!(task as! URLSessionDataTask, task.swRequest.responseDataType.responseOjbectFromdData(data: task.swRequest.responseData as Data) as AnyObject)
                    task.swRequest.dataSuccessBlock = nil
                }
                
                if (task.swRequest.uploadSuccessBlock != nil) {
                    task.swRequest.uploadSuccessBlock!(task as!URLSessionUploadTask, task.swRequest.responseDataType.responseOjbectFromdData(data: task.swRequest.responseData as Data) as AnyObject)
                    task.swRequest.uploadSuccessBlock = nil
                }
                
            }
        }
    }
}


// MARK: All the request types

class SWGet: SWReqeust {
    
    /// Using this overrride fuction for Get request
    ///
    /// - Parameters:
    ///   - url: the request
    ///   - params: The parameters. This should be NSDictionray or String.
    override func start(url: String, params: AnyObject?) {
        self.method = "GET"
        super.start(url: url, params: params)
    }
}

class SWMultipart: SWReqeust {
    
    /// Using this overrride fuction for Multipart request
    ///
    /// - Parameters:
    ///   - url: the request
    ///   - params: The parameters. This should be NSDictionray or String.
    override func start(url: String, params: AnyObject?) {
        super.start(url: url, params: params)
    }
    
    ///  This method will help to generate request with upload task different parameters
    ///
    /// - Parameters:
    ///   - url: The request URL
    ///   - params: The parameters. This should be NSDictionray or String.
    ///   - parentView: parent view. This will help to add loading view.
    ///   - success: success block
    ///   - failure: failure block
    func startUploadTask(url: String,
                         files: NSArray,
                         params: AnyObject?,
                         success: @escaping ((URLSessionUploadTask, AnyObject) -> ()),
                         failure: @escaping ((URLSessionTask?, Error) -> ())) {
        self.uploadSuccessBlock = success
        self.failBlock          = failure
        self.isMultipart        = true
        self.files              = files
        self.requestDataType    = SWRequestMulitFormData()
        self.taskType           = TaskType.upload
        
        self.start(url: url, params: params)
    }
    
    ///  This method will help to generate request with upload task different parameters
    ///
    /// - Parameters:
    ///   - url: The request URL
    ///   - params: The parameters. This should be NSDictionray or String.
    ///   - parentView: parent view. This will help to add loading view.
    ///   - success: success block
    ///   - failure: failure block
    func startUploadTask(url: String,
                         files: NSArray,
                         params: AnyObject?,
                         parentView: NSObject??,
                         success: @escaping ((URLSessionUploadTask, AnyObject) -> ()),
                         failure: @escaping ((URLSessionTask?, Error) -> ())) {
        self.startUploadTask(url: url, files: files, params: params, success: success, failure: failure)
    }
    
    ///  This method will help to generate request with upload task different parameters
    ///
    /// - Parameters:
    ///   - url: The request URL
    ///   - params: The parameters. This should be NSDictionray or String.
    ///   - parentView: parent view. This will help to add loading view.
    ///   - cache: Cache response block.
    ///   - success: success block
    ///   - failure: failure block
    func startUploadTask(url: String,
                         files: NSArray,
                         params: AnyObject?,
                         parentView: NSObject?,
                         cache: @escaping ((CachedURLResponse, AnyObject) -> ()),
                         success: @escaping ((URLSessionUploadTask, AnyObject) -> ()),
                         failure: @escaping ((URLSessionTask?, Error) -> ())) {
        self.cacheBlock = cache
        self.startUploadTask(url: url, files: files, params: params, success: success, failure: failure)
    }
    
    ///  This method will help to generate request with upload task different parameters
    ///
    /// - Parameters:
    ///   - url: The request URL
    ///   - params: The parameters. This should be NSDictionray or String.
    ///   - parentView: parent view. This will help to add loading view.
    ///   - sendLaterIfOffline: To send offline request, User need to set YES.
    ///   - cache: Cache response block.
    ///   - success: success block
    ///   - failure: failure block
    func startUploadTask(url: String,
                         files: NSArray,
                         params: AnyObject?,
                         parentView: NSObject?,
                         sendLaterIfOffline: Bool,
                         cache: @escaping ((CachedURLResponse, AnyObject) -> ()),
                         success: @escaping ((URLSessionUploadTask, AnyObject) -> ()),
                         failure: @escaping ((URLSessionTask?, Error) -> ())){
        self.sendRequestLaterWhenOnline = sendLaterIfOffline
        self.startUploadTask(url: url, files: files, params: params, parentView: parentView, cache: cache, success: success, failure: failure)
    }
}

class SWPost: SWMultipart {
    /// Using this overrride fuction for Post request
    ///
    /// - Parameters:
    ///   - url: the request
    ///   - params: The parameters. This should be NSDictionray or String.
    override func start(url: String, params: AnyObject?) {
        self.method = "POST"
        super.start(url: url, params: params)
    }
}

class SWPut: SWMultipart {
    /// Using this overrride fuction for Put request
    ///
    /// - Parameters:
    ///   - url: the request
    ///   - params: The parameters. This should be NSDictionray or String.
    override func start(url: String, params: AnyObject?) {
        self.method = "PUT"
        super.start(url: url, params: params)
    }
}

class SWPatch: SWMultipart {
    
    /// Using this overrride fuction for Patch request
    ///
    /// - Parameters:
    ///   - url: the request
    ///   - params: The parameters. This should be NSDictionray or String.
    override func start(url: String, params: AnyObject?) {
        self.method = "PATCH"
        super.start(url: url, params: params)
    }
}

class SWDelete: SWReqeust {
    
    /// Using this overrride fuction for Delete request
    ///
    /// - Parameters:
    ///   - url: the request
    ///   - params: The parameters. This should be NSDictionray or String.
    override func start(url: String, params: AnyObject?) {
        self.method = "DELETE"
        super.start(url: url, params: params)
    }
}

class SWHead: SWReqeust {
    
    /// Using this overrride fuction for Head request
    ///
    /// - Parameters:
    ///   - url: the request
    ///   - params: The parameters. This should be NSDictionray or String.
    override func start(url: String, params: AnyObject?) {
        self.method = "HEAD"
        super.start(url: url, params: params)
    }
}

// MARK: Shared class

/// This class help to mange all the operations
class SharedManger: NSObject {
    var session: URLSession?
    var runningTasks: NSMutableDictionary?
    var operationQueue: OperationQueue?
    
    class func sharedmanager() -> SharedManger {
        let instance = SharedManger()
        return instance
    }
}

/**
 * NSURLSessionTask category for handle blocks
 */

/// associated ojbect handler
var AssociatedObjectHandle: UInt8 = 0

// MARK: - URLSessionTask extension
extension URLSessionTask {
    
    /// set SwReqest
    var swRequest: SWReqeust {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as! SWReqeust
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// This fuction will help to set falilure block for URLSessionTask
    ///
    /// - Parameter failure: failure block
    func setFailureBlock(failure: ((URLSessionTask?, Error) -> ())? = nil) {
        self.swRequest.failBlock = failure
    }
}

// MARK: - URLSessionDownloadTask extensiion
extension URLSessionDownloadTask {
    
    /// This fuction will hpet to set download progress for URLSessionDownloadTask
    ///
    /// - Parameter progress: download progress blcok
    func downloadProgress(progress: ((Int64, Int64) -> ())? = nil) {
        self.swRequest.downloadPrgressBlock  = progress
    }
    
    /// This fuction will hpet to set download success for URLSessionDownloadTask
    ///
    /// - Parameter progress: download success blcok
    func downloadSuccess(success: ((URLSessionDownloadTask, URL) -> ())? = nil) {
        self.swRequest.downloadSuccessBlock = success
    }
}

// MARK: - URLSessionDataTask extensiion
extension URLSessionDataTask {

    /// This fuction will hpet to set download success for URLSessionDownloadTask
    ///
    /// - Parameter progress: upload progess blcok
    func setDataSuccessBlock(success: ((URLSessionDataTask, AnyObject) -> ())? = nil) {
        self.swRequest.dataSuccessBlock = success
    }
}

// MARK: - URLSessionUploadTask extensiion
extension URLSessionUploadTask {
    
    /// This fuction will hpet to set download success for URLSessionDownloadTask
    ///
    /// - Parameter progress: upload progess blcok
    func setUploadProgress(progress: ((Int64, Int64) -> ())? = nil) {
        self.swRequest.uploadPrgressBlock = progress
    }
    
    /// This fuction will hpet to set upload success for URLSessionDownloadTask
    ///
    /// - Parameter progress: upload success blcok
    func uploadSuccess(success: ((URLSessionUploadTask, AnyObject) -> ())? = nil) {
        self.swRequest.uploadSuccessBlock = success
    }
}
