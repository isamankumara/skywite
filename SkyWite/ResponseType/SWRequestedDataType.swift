//
//  SWRequestedDataType.swift
//  SkyWite
//
//  Created by Saman kumara on 01/02/17.
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
 * SWRequestDataProtocol use to generate HTTPBody on the request.
 */
protocol SWRequestDataProtocol {
    
}


let SW_MULTIPART_REQUEST_BOUNDARY : String = "boundary-swnetworking-----------14737809831466499882746641449"

func SWEscapedQueryStringKeyFromStringWithEncoding(string: String) -> String {
    var charset = NSCharacterSet.urlQueryAllowed
    charset.remove(charactersIn: "!*'();:@&=+$,/?%#")
    return string.addingPercentEncoding(withAllowedCharacters: charset)!
}

func SWEscapedQueryStringValueFromStringWithEncoding(string: String) -> String {
    var charset = NSCharacterSet.urlQueryAllowed
    charset.remove(charactersIn: "!*'();:@&=+$,/?%#[]")
    return string.addingPercentEncoding(withAllowedCharacters: charset)!
}

class SWRequestDataType :NSObject, SWRequestDataProtocol, NSCoding {

    /// bodaydata that request use to sent
    var bodyData : NSData?
    
    /// default init method
    override init() {
        super.init()
    }
    
    /// Calling this method can get HTTPBody data
    ///
    /// - Returns: return BodyData as NSData
    func getRequestBodyData() -> NSData {
        return self.bodyData!
    }
    
    /// When calling this method can get Content Type
    ///
    /// - Returns: return Content Type an a NSString
    func getContentType() -> String {
        return ""
    }
    
    /// This method use set request body. If want to custom datatype user can overide this method
    ///
    /// - Parameters:
    ///   - files: files files array to submit. (this is multipart body)
    ///   - parameters: parameters The parameters will me NSDictionary or NSString
    func dataWithFiles(files: [SWMedia], parameters: Any) {
    }
    
    /// SWRequestFormData use to get query string
    ///
    /// - Returns: return string as query string
    func getQueryString() -> String {
        return ""
    }

    // MARK: NSCordering
    
    /// Decorder init method
    ///
    /// - Parameter decorder: NSCoder object
    required convenience init(coder decorder: NSCoder) {
        self.init()
        self.bodyData            = decorder.decodeObject(forKey: "bodyData") as! NSData?
    }
    
    
    /// Encode method that used for encording
    ///
    /// - Parameter aCoder: aCoder NScoder object
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.bodyData, forKey: "bodyData")
    }
}


/// SWRequestFormData use to generate HTTPBody as FormData on the request.
class SWRequestFormData : SWRequestDataType {
    
    /// This method use set request body. If want to custom datatype user can overide this method
    ///
    /// - Parameters:
    ///   - files: files files array to submit. (this is multipart body)
    ///   - parameters: The parameters will me NSDictionary or NSString
    internal override func dataWithFiles(files: [SWMedia], parameters: Any) {
        self.params         = parameters
        self.bodyData       = self.getQueryString() .data(using: String.Encoding.ascii, allowLossyConversion: true) as NSData?
    }

    
    private var params: Any?
    
    
    override func getContentType() -> String {
        return "application/x-www-form-urlencoded"
    }
    
    override func getQueryString() -> String {
        
        var returnString = ""
        if (self.params is NSDictionary) {
            let param: NSDictionary = self.params as! NSDictionary
            var paramsArray = [String]()
            
            for key in param.allKeys {
                paramsArray.append("\(SWEscapedQueryStringKeyFromStringWithEncoding(string: key as! String))=\(SWEscapedQueryStringValueFromStringWithEncoding(string: param.object(forKey: key) as! String))")
            }
            
            returnString = paramsArray.joined(separator: "&")
        }else if(self.params is String) {
            returnString = self.params as! String
        }
        
        return returnString
    }
    
    override func getRequestBodyData() -> NSData {
        return self.bodyData!
    }
}

/// This class will handle all the multipart form data. The SWRequestDataType class will be super class
class SWRequestMulitFormData : SWRequestDataType {
    
    
    /// files array need to add SWMead
    private var files : [SWMedia] = [SWMedia]()
    
    internal override func dataWithFiles(files: [SWMedia], parameters: Any) {
        self.files      = files
        
        var dictionary = NSMutableDictionary()
        
        if parameters is NSDictionary {
            dictionary = NSMutableDictionary(dictionary: parameters as! Dictionary)
        }else {
            let parms = parameters as! String
            let array = parms.components(separatedBy: "&")
            for (_, element) in array.enumerated() {
                let keyValueArray = element.components(separatedBy: "=")
                if (keyValueArray.count > 1) {
                    dictionary.setValue(keyValueArray[0], forKey: keyValueArray[1])
                }
            }
        }
        self.bodyData   = self.getBodyDataWithParameters(params : dictionary)
    }

    internal override func getContentType() -> String {
        return "multipart/form-data; boundary=\(SW_MULTIPART_REQUEST_BOUNDARY)"
    }

    private func getBodyDataWithParameters(params: NSDictionary) -> NSMutableData {
        let body : NSMutableData = NSMutableData.init()
        body.append("--\(SW_MULTIPART_REQUEST_BOUNDARY)\r\n".data(using: String.Encoding.utf8)!)
        
        let endBoundy = "\r\n--\(SW_MULTIPART_REQUEST_BOUNDARY)\r\n"
       
        var i = 0
        
        for key in params.allKeys {
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("saman".data(using: String.Encoding.utf8)!)
            
            i += 1
            
            if ((i != params.allKeys.count) || (self.files.count > 0)) {
                body.append(endBoundy.data(using: String.Encoding.utf8)!)
            }
        }
    
        i = 0
        for file in self.files {
            body.append("Content-Disposition: form-data; name=\"\(file.key)\"; filename=\"\(file.fileName)\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: \(String(describing: file.MIMEType))\r\n\r\n".data(using: String.Encoding.utf8)!)
            i += 1
            
            if (i != self.files.count) {
                body.append(endBoundy.data(using: String.Encoding.utf8)!)
            }
        }
        
        body.append("\r\n--\(SW_MULTIPART_REQUEST_BOUNDARY)--\r\n".data(using: String.Encoding.utf8)!)

        return body
    }
}

/// This class will handle Request body for JSON. Then SWRequestDataType will be super class for this class
class SWRequestJSONData : SWRequestDataType {
    internal override func dataWithFiles(files: [SWMedia], parameters: Any) {
        do {
            self.bodyData = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions(rawValue: UInt(0))) as NSData?
        } catch {
            print(error)
        }
    }

    internal override func getContentType() -> String {
        return "application/json"
    }

}
