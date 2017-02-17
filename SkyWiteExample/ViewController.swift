//
//  ViewController.swift
//  SkyWiteExample
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

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    override func viewDidLoad() {
       // self.view.backgroundColor = UIColor.green
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor.clear
        
        //simplePost()
        
        WithMultiPart()
    }
    
    
    /// This method will use to update according to the selecction
    ///
    /// - Parameter indexPath: IndexPath
    func setDetailsItem(indexPath: IndexPath) {
        switch (indexPath.section) {
        case 0:
            
                switch (indexPath.row) {
                case 0:
                    
                         simpleGET()
                        break;
                    
                case 1:
                    
                        withResponseType()
                        break;
                    
                case 2:
                    
                        withLoadingView()
                        break;
                    
                case 3:
                    
                        withParameter()
                        break;
                    
                case 4:
                    
                        withCacheData()
                        break;
                    
                default:
                    break;
                }
                break;
            
        case 1:
            switch (indexPath.row) {
            case 0:
                    simplePost()
                    break;
                
            case 1:
                    WithMultiPart()
                    break;
            default:
                break;
            }
            break;
        case 2:
                simplePUT()
                break;
        case 3:
                simplePatch()
                break;
        case 4:
                simpleDELETE()
                break;
        case 5:
            
            simpleHEAD()
            break;
        case 6:
                switch (indexPath.row) {
                case 0:
                        autoLoadingView()
                        break;
                    
                case 1:
                    downloadProgress()
                    break;
                case 2:
                    uploaddProgress()
                    break;
                case 3:
                        customHeader()
                        break;
                case 4:
                        customContentType()
                        break;
                case 5:
                        customTimeOut()
                        break;
                case 6:
                        offlineRequest()
                        break;
                case 7:
                        responseEncoding()
                        break;
                case 8:
                        accessCacheData()
                        break;
                case 9:
                        uiImageViewWithURL()
                        break;
                case 10:
                        netWorkAvailibity()
                        break;
                case 11:
                    //multipleOperations()
                    break;
                case 12:
                    downloadProgressWithProgressView()
                    break;
                    
                case 13:
                    uploadProgressWithProgressView()
                    break;
                case 14:
                    //startdownloadSession()
                    break;
                    
                case 15:
                     //startUploadSession()
                    break;
                    
                default:
                    break;
                }
        default:
            break;
        }
    }
    
    private func simpleGET() {
        let s  = SWGet()
        s.startDataTask(url: "http://localhost:3000/api/v1/users/jobs", params:nil, success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    private func withResponseType() {
        let s  = SWGet()
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "https://maps.googleapis.com/maps/api/place/nearbysearch/json", params:nil, success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    private func withLoadingView() {
        let s  = SWGet()
        s.responseDataType = SWResponseDataType()
        s.startDataTask(url: "http://techslides.com/demos/sample-videos/small.mp4", params:nil, parentView: self.view , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    private func withParameter() {
        let s  = SWGet()
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "http://localhost:3000/api/v1/users/jobs", params:["name":"this is name", "address": "your address"] as AnyObject  , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    private func withCacheData() {
        let s  = SWGet()
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "https://maps.googleapis.com/maps/api/place/nearbysearch/json", params: nil, parentView: self.view, cache: { (response, object) in
            print("chache", object)
            }, success: { (task, object) in
                print("success", object)

            }) { (task, error) in
                print("success", error)
        }
    }
    
    // MARK: post reuqest
    
    private func simplePost() {
        let s = SWPost()
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "http://localhost:3000/api/v1/users/jobs", params:["name":"this is name", "address": "your address"] as AnyObject  , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
        
        let s2 = SWPost()
        s2.responseDataType = SWResponseStringDataType()
        s2.startDataTask(url: "http://localhost:3000/api/v1/users/jobs", params:"saman=test" as AnyObject  , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    private func WithMultiPart() {
        let s = SWPost()
        
        let image = UIImage(named: "skywite")
        let imgData = UIImagePNGRepresentation(image!)
        
        let media1 = SWMedia(fileName: "imagefile.png", key: "image", data: imgData!)
        let media2 = SWMedia(fileName: "imagefile.jpg", key: "image2", mineType:"image/jpeg", data: imgData!)
        
        s.responseDataType = SWResponseStringDataType()
        s.startUploadTask(url: "http://localhost:3000/api/v1/users/users", files:[media1, media2] , params: ["name":"this is name", "address": "your address"] as AnyObject, success: { (task, object) in
            
        }) { (task, error) in
            
        }
    }

    private func simplePUT() {
        let s = SWPut()
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "http://localhost:3000/api/v1/users/jobs/6", params:"saman=test" as AnyObject  , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    
    private func simplePatch() {
        let s = SWPatch()
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "http://localhost:3000/api/v1/users/jobs/6", params:"saman=test" as AnyObject  , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    private func simpleDELETE() {
        let s = SWDelete()
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "http://localhost:3000/api/v1/users/jobs/6", params:"saman=test" as AnyObject  , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    private func simpleHEAD() {
        let s = SWHead()
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "http://localhost:3000/api/v1/users/jobs/6", params:"saman=test" as AnyObject  , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    private func autoLoadingView() {
        let s = SWHead()
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "http://localhost:3000/api/v1/users/jobs/6", params:"saman=test" as AnyObject, parentView:self.view  , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    private func downloadProgress() {
        let s = SWGet()
        s.startDownloadTask(url: "http://techslides.com/demos/sample-videos/small.mp4", params: "" as AnyObject , success: { (task, url) in
            
        }, failure: { (task, error) in
            
        })
        
        s.setDownloadProgress { (byesWritten, totalByes) in
            print(" byte", byesWritten, totalByes)
        }
    }
    
    private func uploaddProgress() {
        let s = SWPost()
        
        let image = UIImage(named: "skywite")
        let imgData = UIImagePNGRepresentation(image!)
        
        let media1 = SWMedia(fileName: "imagefile.png", key: "image", data: imgData!)
        let media2 = SWMedia(fileName: "imagefile.jpg", key: "image2", mineType:"image/jpeg", data: imgData!)

        
        s.startUploadTask(url: "http://localhost:3000/api/v1/users/jobs", files: [media1, media2], params: nil , success: { (task, obj) in
            
        }) { (task, error) in
        
        }

        s.setUploadProgress { (byesWritten, totalByes) in
            print(" byte", byesWritten, totalByes)
        }
    }
    
    private func customHeader() {
        
        let s = SWPost()
        
        s.reqeust.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "http://localhost:3000/api/v1/users/jobs", params:["name":"this is name", "address": "your address"] as AnyObject  , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    private func customContentType() {
        
        let s = SWPost()
        
        s.reqeust.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "http://localhost:3000/api/v1/users/jobs", params:["name":"this is name", "address": "your address"] as AnyObject  , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    private func customTimeOut() {
        
        let s = SWPost()
        s.timeOut = 120
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "http://localhost:3000/api/v1/users/jobs", params:["name":"this is name", "address": "your address"] as AnyObject  , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    private func offlineRequest() {
        
        let s = SWPost()
        s.timeOut = 120
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "http://192.168.1.36:3000/api/v1/users/jobs" , params: ["name":"this is name for testing", "address": "your address"] as AnyObject, parentView: nil, sendLaterIfOffline: true, cache: { (cache, response) in
            
        }, success: { (task, response) in
            
        }) { (task, error) in
            
        }
    }

    private func responseEncoding() {
        
        //JSON
        let s = SWPost()
        s.responseDataType = SWResponseJSONDataType()
        s.startDataTask(url: "" , params: ["name":"this is name for testing", "address": "your address"] as AnyObject, parentView: nil, sendLaterIfOffline: true, cache: { (cache, response) in
            
        }, success: { (task, response) in
            
        }) { (task, error) in
            
        }
        
        //String
        let s2 = SWPost()
        s2.responseDataType = SWResponseStringDataType()
        s2.startDataTask(url: "" , params: ["name":"this is name for testing", "address": "your address"] as AnyObject, parentView: nil, sendLaterIfOffline: true, cache: { (cache, response) in
            
        }, success: { (task, response) in
            
        }) { (task, error) in
            
        }
    }
    
    private func accessCacheData() {
        
        let s = SWPost()
        s.responseDataType = SWResponseJSONDataType()
        s.startDataTask(url: "http://192.168.1.36:3000/api/v1/users/jobs", params: ["name":"this is name for testing", "address": "your address"] as AnyObject , parentView: nil, cache: { (response, responseObject) in
            
        }, success: { (task, response) in
            
        }) { (task, error) in
            
        }
    }
    
    private func uiImageViewWithURL() {
        let imageView = UIImageView.init(frame: CGRect(x:0, y:0, width:300, height:300))
        imageView.loadWithURLString(url: "")
        imageView.loadWithURLString(url: "", loadFromCacheFirst: true)
        imageView.loadWithURLString(url: "") { (image) in
            
        }
        imageView.loadWithURLString(url: "", loadFromCacheFirst: true) { (image) in
            
        }
    }
    
    private func netWorkAvailibity() {
        if (SWReachability.getCurrentNetworkStatus() == .NotReachable) {
            //connection not avaible
        }
        
        //if you want to get status chnage notification
        SWReachability.checkNetowrk(currentNetworkStatus: { (currentStatus) in
            
        }) { (changedStatus) in
            
        }
    }
    
    private func downloadProgressWithProgressView() {
        
        let s = SWPost()
        s.responseDataType = SWResponseJSONDataType()
        s.startDownloadTask(url: "http://192.168.1.36:3000/api/v1/users/jobs" , params:nil , parentView: nil, sendLaterIfOffline: true, cache: { (cache, response) in
            
        }, success: { (task, response) in
            
        }) { (task, error) in
            
        }
        
        progressView.setRequestForDownload(request: s)
    }
    
    private func uploadProgressWithProgressView() {
        let s = SWPost()
        
        let image = UIImage(named: "skywite")
        let imgData = UIImagePNGRepresentation(image!)
        
        let media1 = SWMedia(fileName: "imagefile.png", key: "image", data: imgData!)
        let media2 = SWMedia(fileName: "imagefile.jpg", key: "image2", mineType:"image/jpeg", data: imgData!)
        
        s.responseDataType = SWResponseStringDataType()
        s.startUploadTask(url: "http://localhost:3000/api/v1/users/users", files:[media1, media2] , params: ["name":"this is name", "address": "your address"] as AnyObject, success: { (task, object) in
            
        }) { (task, error) in
            
        }
        progressView.setRequestForUpload(request: s)
    }
}

