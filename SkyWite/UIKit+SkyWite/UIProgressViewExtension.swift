//
//  UIProgressViewExtension.swift
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


#if os(iOS) || os(watchOS) || os(tvOS)
    
// MARK: - UIProgressView extension
extension UIProgressView {
    
    /// Using this method will set upload progress to the ProgressView
    ///
    /// - Parameter request: request to that user want do bind with progresview
    func setRequestForDownload(request: SWReqeust) {
        request.setDownloadProgress(progress: { (bytesWritten, totalByte) in
            self.progress =  Float(bytesWritten) / Float(totalByte)
        })
    }
    
    /// Using this method will set upload progress to the ProgressView
    ///
    /// - Parameter request: request to that user want do bind with progresview
    func setRequestForUpload(request: SWReqeust) {
        request.setUploadProgress(progress: { (bytesWritten, totalByte) in
            self.progress =  Float(bytesWritten) / Float(totalByte)
        })
    }
    
    /// Using this method will set upload progress to the ProgressView
    ///
    /// - Parameter request: request to that user want do bind with progresview
    func setDownloadTask(task: URLSessionDownloadTask) {
        task.downloadProgress(progress: { (bytesWritten, totalByte) in
            self.progress =  Float(bytesWritten) / Float(totalByte)
        })
    }
    
    /// Using this method will set upload progress to the ProgressView
    ///
    /// - Parameter request: request to that user want do bind with progresview
    func setUploadTask(task: URLSessionUploadTask) {
        task.setUploadProgress(progress: { (bytesWritten, totalByte) in
            self.progress =  Float(bytesWritten) / Float(totalByte)
        })
    }
}
#endif
