//
//  SWMedia.swift
//  SkyWite
//
//  Created by Saman kumara on 1/3/17.
//  Copyright © 2016 Saman Kumara. All rights reserved.
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

/**
 *  This class will help to send mulitipart request with some files. before and file need to create files.
 */
open class SWMedia {
    
    /// File name will return from this
    var fileName: String
    
    
    ///  Request key will return from this
    var key: String
    
    ///  Request File mine type will return from this
    var MIMEType: String?
    
    /// Request file Data will return from this
    var data: Data?
    
    
    /// When user create with commen file types user can use this method.
    ///
    /// - Parameters:
    ///   - fileName: file name
    ///   - key: request key
    ///   - data: file data
    init(fileName: String, key: String, data: Data)  {
        self.fileName   = fileName
        self.key        = key
        self.data       = data
        
        var mineTypes: [String: String]  = [
            "3gp"   : "video/3gpp",
            "3g2"   : "video/3gpp2",
            "7z"    : "application/x-7z-compressed",
            "pdf"   : "application/pdf",
            "gif"   : "image/gif",
            "jpeg"  : "image/jpeg",
            "jpg"   : "image/jpeg",
            "jpgv"  : "video/jpeg",
            "xls"   : "application/vnd.ms-excel",
            "pptx"  : "application/vnd.openxmlformats-officedocument.presentationml.presentation",
            "docx"  : "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
            "ppt"   : "application/vnd.ms-powerpoint",
            "wmv"   : "video/x-ms-wmv",
            "doc"   : "application/msword",
            "mpeg"  : "video/mpeg",
            "mp4a"  : "audio/mp4",
            "mp4"   : "video/mp4",
            "png"   : "image/png",
            "xml"   : "application/rss+xml",
            "rss"   : "application/rss+xml",
            "movie" : "video/x-sgi-movie",
            "tar"   : "application/x-tar",
            "txt"   : "text/plain",
        ]
        
        if let mineType = mineTypes[(self.fileName as NSString).pathExtension] {
            self.MIMEType   = mineType;
        }
    }

    /// When user create with custom file types user can use this method.
    ///
    /// - Parameters:
    ///   - fileName: file name
    ///   - key: request key
    ///   - mineType: Custom Mine Type
    ///   - data: file data
    convenience init(fileName: String, key: String, mineType: String, data: Data) {
        self.init(fileName: fileName, key: key, data:data)
        self.MIMEType = mineType
    }
}

