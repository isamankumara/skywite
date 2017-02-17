//
//  ViewController.swift
//  SkyWiteMacExample
//
//  Created by Saman kumara on 11/14/16.
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

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        withLoadingView()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func simpleGET() {
        let s  = SWGet()
        s.startDataTask(url: "", params:nil, success: { (task, object) in
        }) { (task, error) in
            print("error", error)
        }
    }
    
    func withResponseType() {
        let s  = SWGet()
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "", params:nil, success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    func withLoadingView() {
        let s  = SWGet()
        s.responseDataType = SWResponseDataType()
        s.startDataTask(url: "", params:nil, parentView: self.view , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    func withParameter() {
        let s  = SWGet()
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "http://localhost:3000/api/v1/users/jobs", params:["name":"this is name", "address": "your address"] as AnyObject  , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    func withCacheData() {
        let s  = SWGet()
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "", params: nil, parentView: self.view, cache: { (response, object) in
            print("chache", object)
        }, success: { (task, object) in
            print("success", object)
            
        }) { (task, error) in
            print("success", error)
        }
    }
    
    // MARK: post reuqest
    
    func simplePost() {
        let s = SWPost()
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "", params:["name":"this is name", "address": "your address"] as AnyObject  , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
        
        let s2 = SWPost()
        s2.responseDataType = SWResponseStringDataType()
        s2.startDataTask(url: "", params:"saman=test" as AnyObject  , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    func WithMultiPart() {
        let s = SWPost()
        
        let image = NSImage(named: "skywite")
        let imgData = pngRepresentationOfImage(image: image!)
        
        let media1 = SWMedia(fileName: "imagefile.png", key: "image", data: imgData)
        let media2 = SWMedia(fileName: "imagefile.jpg", key: "image2", mineType:"image/jpeg", data: imgData)
        
        s.responseDataType = SWResponseStringDataType()
        s.startUploadTask(url: "", files:[media1, media2] , params: ["name":"this is name", "address": "your address"] as AnyObject, success: { (task, object) in
            
        }) { (task, error) in
            
        }
    }
    
    func pngRepresentationOfImage(image: NSImage) -> Data {
        image.lockFocus()
        let bitMap = NSBitmapImageRep.init(focusedViewRect: NSMakeRect(0, 0, image.size.width, image.size.height))
        image.unlockFocus()
        return (bitMap?.representation(using: .PNG, properties: [NSImageInterlaced : false]))!
    }
    
    func simplePUT() {
        let s = SWPut()
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "", params:"saman=test" as AnyObject  , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    
    func simplePatch() {
        let s = SWPatch()
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "", params:"saman=test" as AnyObject  , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    func simpleDELETE() {
        let s = SWDelete()
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "", params:"saman=test" as AnyObject  , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    func simpleHEAD() {
        let s = SWHead()
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "", params:"saman=test" as AnyObject  , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    func autoLoadingView() {
        let s = SWHead()
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "", params:"saman=test" as AnyObject, parentView:self.view  , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    func downloadProgress() {
        let s = SWGet()
        s.startDownloadTask(url: "http://techslides.com/demos/sample-videos/small.mp4", params: "" as AnyObject , success: { (task, url) in
            
        }, failure: { (task, error) in
            
        })
        
        s.setDownloadProgress { (byesWritten, totalByes) in
            print(" byte", byesWritten, totalByes)
        }
    }
    
    func uploaddProgress() {
        let s = SWPost()
        
        let image = NSImage(named: "skywite")
        let imgData = pngRepresentationOfImage(image: image!)
        
        let media1 = SWMedia(fileName: "imagefile.png", key: "image", data: imgData)
        let media2 = SWMedia(fileName: "imagefile.jpg", key: "image2", mineType:"image/jpeg", data: imgData)
        
        
        s.startUploadTask(url: "http://localhost:3000/api/v1/users/jobs", files: [media1, media2], params: nil , success: { (task, obj) in
            
        }) { (task, error) in
            
        }
        
        s.setUploadProgress { (byesWritten, totalByes) in
            print(" byte", byesWritten, totalByes)
        }
    }
    
    func customHeader() {
        
        let s = SWPost()
        
        s.reqeust.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "", params:["name":"this is name", "address": "your address"] as AnyObject  , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    func customContentType() {
        
        let s = SWPost()
        
        s.reqeust.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "http://localhost:3000/api/v1/users/jobs", params:["name":"this is name", "address": "your address"] as AnyObject  , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    func customTimeOut() {
        
        let s = SWPost()
        s.timeOut = 120
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "", params:["name":"this is name", "address": "your address"] as AnyObject  , success: { (task, object) in
            print("item", object)
        }) { (task, error) in
            print("error", error)
        }
    }
    
    func offlineRequest() {
        
        let s = SWPost()
        s.timeOut = 120
        s.responseDataType = SWResponseStringDataType()
        s.startDataTask(url: "http://192.168.1.36:3000/api/v1/users/jobs" , params: ["name":"this is name for testing", "address": "your address"] as AnyObject, parentView: nil, sendLaterIfOffline: true, cache: { (cache, response) in
            
        }, success: { (task, response) in
            
        }) { (task, error) in
            
        }
    }

}

