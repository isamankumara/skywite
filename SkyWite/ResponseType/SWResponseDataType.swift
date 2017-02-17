//
//  SWResponseDataType.swift
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
#if os(iOS) || os(watchOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import Cocoa
#endif


/// SWResponseDataProtocol here and it will be coverd SWResponseDataTypes
protocol SWResponseDataProtocol {
   
}

/// This class will be cover all the response data types
class  SWResponseDataType: NSObject, SWResponseDataProtocol, NSCoding {
    
    /// This parameter can use for keep response status code
    internal var responseCode: Int?

    
    /// Using this method we user can get relevet response type
    ///
    /// - Parameters:
    ///   - response: response will be HTTPURLResponse
    ///   - data: data the user get as a response
    /// - Returns: return Any object that relevent to the response type
    func responseObject(response: HTTPURLResponse, data: Data) -> Any {
        return data
    }
    
    /// Using this method we user can get relevet response type
    ///
    /// - Parameter data: the user get as a response
    /// - Returns: return Any object that relevent to the response type
    func responseOjbectFromdData(data: Data) -> Any{
        return data
    }
    
    /// defalut init methed
    override init() {
        super.init()
    }
    
    // MARK: NSCorderingn
    
    /// Decorder init method
    ///
    /// - Parameter decorder: NSCoder object
    required convenience init(coder decorder: NSCoder) {
        self.init()
        self.responseCode            = Int(decorder.decodeInt32(forKey: "responseCode"))
    }
    
    /// Encode method that used for encording
    ///
    /// - Parameter aCoder: aCoder NScoder object
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(responseCode, forKey: "responseCode")
    }
}

/// This Class will handle Json resopne, The SWResponseDataType will be super class for this class
class SWResponseJSONDataType : SWResponseDataType {

    private var removeNil : Bool?
    private var readingOptions: JSONSerialization.ReadingOptions?
    
    /// THis method to use setup jsong configuration
    ///
    /// - Parameters:
    ///   - readingOptions: readingOptions json Serialization reading option
    ///   - removeNil: removeNil set remove boolean value to remove null values
    init(readingOptions: JSONSerialization.ReadingOptions, removeNil: Bool) {
        self.readingOptions = readingOptions
        self.removeNil      = removeNil
    }
    
    /// Default init method
    override init() {
        
    }
    /// Init method with reading option parameter
    convenience init(readingOptions: JSONSerialization.ReadingOptions) {
        self.init(readingOptions: readingOptions, removeNil: false)
    }
    
    override func responseObject(response: HTTPURLResponse, data: Data) -> Any {
        self.responseCode = response.statusCode
        var json : Any? = nil
        
        do {
            json = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
        } catch {
            print(error)
        }
        
        return json!
    }
    
    override func responseOjbectFromdData(data: Data) -> Any{
        
        var json : Any? = nil
        
        do {
            json = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
        } catch {
            print(error)
        }
        
        return json!
    }
}


/// This class will handle string response. The SWResponseDataType will be supper class for this class
class SWResponseStringDataType : SWResponseDataType {
    
    /// This will help to keep string encoding default encoding will be String.Encoding.utf8
    private var encoding = String.Encoding.utf8
    
    /// This method will use to get Class instance
    ///
    /// - Parameter encoding: String encdoing type
    /// - Returns: return SWResponseStringDataType instance
    public class func typeWithEncoding(encoding: String.Encoding) -> SWResponseStringDataType {
        let stringType = SWResponseStringDataType()
        stringType.encoding = encoding
        return stringType
    }
    
    override func responseObject(response: HTTPURLResponse, data: Data?) -> Any {
        self.responseCode = response.statusCode
        var string = ""
        
        if (data != nil) {
            string = String(data: data! as Data, encoding: encoding)!
        }else {
            string = "NSUTF8StringEncoding doens't support for your response. Please use esponseStringWithEncoding:(NSStringEncoding) encoding"
        }
        
        return string
    }
    
    override func responseOjbectFromdData(data: Data?) -> Any {
        var string = ""
        
        if (data != nil) {
            string = String(data: data! as Data, encoding: encoding)!
        }else {
            string = "NSUTF8StringEncoding doens't support for your response. Please use esponseStringWithEncoding:(NSStringEncoding) encoding"
        }
        
        return string
    }
    
    // MARK: NSCorderingn
    
    // Decorder init method
    ///
    /// - Parameter decorder: NSCoder object
    convenience required init(coder decorder: NSCoder) {
        self.init()
        self.encoding            = String.Encoding(rawValue:UInt(decorder.decodeInt32(forKey: "encoding")))
        //self.responseCode        = Int(decorder.decodeInt32(forKey: "responseCode"))
    }
    
    /// Encode method that used for encording
    ///
    /// - Parameter aCoder: aCoder NScoder object
    public func encde(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(encoding.rawValue, forKey: "encoding")
    }
}

/// This class can help to get the image as the response
class SWResponseImageType : SWResponseDataType {
    
    /// This method will use to get image as the response
    ///
    /// - Parameters:
    ///   - response: HTTPURLResponse object
    ///   - data: data object the use get as response
    /// - Returns: return image
    override func responseObject(response: HTTPURLResponse, data: Data) -> Any {
        self.responseCode = response.statusCode
        #if os(iOS) || os(watchOS) || os(tvOS)
            return UIImage(data: data as Data)!

        #elseif os(OSX)
            return NSImage(data: data as Data)!
        #endif
    }
    
    override func responseOjbectFromdData(data: Data) -> Any{
        #if os(iOS) || os(watchOS) || os(tvOS)
            return UIImage(data: data as Data)!
        #elseif os(OSX)
            return NSImage(data: data as Data)!
        #endif
    }
}
