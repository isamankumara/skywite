//
//  UIImageViewExtension.swift
//  SkyWite
//
//  Created by Saman kumara on 2/15/17.
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
#if os(iOS) || os(watchOS) || os(tvOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

private var associationBlockKey: UInt8 = 0
private var associationGetRequestKey: UInt8 = 1

#if os(iOS) || os(watchOS) || os(tvOS)

// MARK: - UIImageView extension
extension UIImageView {
 
    /// cacle blcok
    @IBInspectable var cacheBlock: ((CachedURLResponse, AnyObject) -> Void) {
        get {
            return objc_getAssociatedObject(self, &associationBlockKey) as! ((CachedURLResponse, AnyObject) -> Void)
        }
        
        set (newValue){
            objc_setAssociatedObject(self, &associationBlockKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// get request to download image
    @IBInspectable var imageRequest: SWGet {
        get {
            return objc_getAssociatedObject(self, &associationGetRequestKey) as! SWGet
        }
        
        set (newValue){
            objc_setAssociatedObject(self, &associationGetRequestKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// This method will help to downlaod image without complete block.
    ///
    /// - Parameter url: The url that user want to download
    func loadWithURLString(url: String) {
        self.loadWithURLString(url: url, loadFromCacheFirst: false)
    }
    
    /// This method will help to downlaod image without complete block.
    ///
    /// - Parameters:
    ///   - url: The url that user want to download
    ///   - loadFromCacheFirst: if yes image will load from cache first and then load from downloading
    func loadWithURLString(url: String, loadFromCacheFirst: Bool) {
        self.loadWithURLString(url: url, loadFromCacheFirst: loadFromCacheFirst, complete: nil)
    }
    
    /// This method will help to downlaod image without complete block.
    ///
    /// - Parameters:
    ///   - url: The url that user want to download
    ///   - complete: compete block will call with image
    func loadWithURLString(url: String, complete: ((UIImage) -> Void)?) {
        self.loadWithURLString(url: url, loadFromCacheFirst: false, complete: complete)
    }
    
    /// This method will help to downlaod image without complete block.
    ///
    /// - Parameters:
    ///   - url: The url that use want to downlaod image
    ///   - loadFromCacheFirst: if yes image will load from cache first and then load from downloading
    ///   - complete: compete block will call with image
    func loadWithURLString(url: String, loadFromCacheFirst: Bool, complete: ((UIImage) -> Void)?) {
        let indicator   = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        indicator.startAnimating()
        indicator.center = CGPoint(x: self.frame.size.width / 2 , y: self.frame.size.width / 2)
        indicator.hidesWhenStopped = false
        
        self.imageRequest = SWGet()
        self.imageRequest.responseDataType = SWResponseImageType()
        self.imageRequest .startDataTask(url: url, params: nil, parentView: nil, cache: { (response, responseOjbect) in
            indicator.removeFromSuperview()
            if (loadFromCacheFirst) {
                self.image = responseOjbect as? UIImage
            }
        }, success: { (task, responseObject) in
            indicator.removeFromSuperview()
            self.image = responseObject as? UIImage
            if (complete != nil) {
                complete!(self.image!)
            }
        }, failure: { (task, error) in
            indicator.removeFromSuperview()
        })
    }
    
    /// This function will help to cancel the image downloding reqeust
    func cancel() {
        self.imageRequest.cancel()
        
        for view in self.subviews {
            if(view is UIActivityIndicatorView) {
                let indigator = view as! UIActivityIndicatorView
                indigator.removeFromSuperview()
            }
        }
    }
}

    
#elseif os(OSX)
// MARK: - NSImageView extension
extension NSImageView {
    
    @IBInspectable var cacheBlock: ((CachedURLResponse, AnyObject) -> Void) {
        get {
            return objc_getAssociatedObject(self, &associationBlockKey) as! ((CachedURLResponse, AnyObject) -> Void)
        }
        
        set (newValue){
            objc_setAssociatedObject(self, &associationBlockKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @IBInspectable var imageRequest: SWGet {
        get {
            return objc_getAssociatedObject(self, &associationGetRequestKey) as! SWGet
        }
        
        set (newValue){
            objc_setAssociatedObject(self, &associationGetRequestKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// This method will help to downlaod image without complete block.
    ///
    /// - Parameters:
    ///   - url: The url that use want to downlaod image
    func loadWithURLString(url: String) {
        self.loadWithURLString(url: url, loadFromCacheFirst: false)
    }
    
    /// This method will help to downlaod image without complete block.
    ///
    /// - Parameters:
    ///   - url: The url that use want to downlaod image
    ///   - loadFromCacheFirst: if yes image will load from cache first and then load from downloading
    func loadWithURLString(url: String, loadFromCacheFirst: Bool) {
        self.loadWithURLString(url: url, loadFromCacheFirst: loadFromCacheFirst, complete: nil)
    }
    
    /// This method will help to downlaod image without complete block.
    ///
    /// - Parameters:
    ///   - url: The url that use want to downlaod image
    ///   - complete: compete block will call with image
    func loadWithURLString(url: String, complete: ((NSImage) -> Void)?) {
        self.loadWithURLString(url: url, loadFromCacheFirst: false, complete: complete)
    }
    
    /// This method will help to downlaod image without complete block.
    ///
    /// - Parameters:
    ///   - url: The url that use want to downlaod image
    ///   - loadFromCacheFirst: if yes image will load from cache first and then load from downloading
    ///   - complete: compete block will call with image
    func loadWithURLString(url: String, loadFromCacheFirst: Bool, complete: ((NSImage) -> Void)?) {
        
        let indicator   = NSProgressIndicator.init(frame:  CGRect(x: (self.frame.size.width/2), y:(self.frame.size.height/2), width:30, height:30))
        indicator.wantsLayer = true
        indicator.style = NSProgressIndicatorStyle.spinningStyle
        indicator.startAnimation(nil)
        
        self.imageRequest = SWGet()
        self.imageRequest.responseDataType = SWResponseImageType()
        self.imageRequest .startDataTask(url: url, params: nil, parentView: nil, cache: { (response, responseOjbect) in
            indicator.removeFromSuperview()
            if (loadFromCacheFirst) {
                self.image = responseOjbect as? NSImage
            }
        }, success: { (task, responseObject) in
            indicator.removeFromSuperview()
            self.image = responseObject as? NSImage
            if (complete != nil) {
                complete!(self.image!)
            }
        }, failure: { (task, error) in
            indicator.removeFromSuperview()
        })
    }
    
    /// This function will help to cancel the image downloding reqeust
    func cancel() {
        self.imageRequest.cancel()
        
        for view in self.subviews {
            if(view is NSProgressIndicator) {
                let indigator = view as! NSProgressIndicator
                indigator.removeFromSuperview()
            }
        }
    }
}
#endif
