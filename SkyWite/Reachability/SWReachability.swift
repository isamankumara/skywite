//
//  SWReachability.swift
//  SkyWite
//
//  Created by Saman kumara on 1/3/17.
//  Copyright © 2017 Saman Kumara. All rights reserved.
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
import SystemConfiguration


/// This is Enum to keep reachability status
///
/// - NotReachable: This will be use for not reachable state
/// - WWAN: This will be use for wwan
/// - Wifi: This will be use for wifi
enum SWReachabilityStatus {
    case NotReachable
    case WWAN
    case Wifi
}


/// This class will help to handle SWReachability block
@objc
class SWReachabilityHandler : NSObject {
    var changeStatus: ((SWReachabilityStatus) -> Void)?
    func checkNetworkStatus() {
        if (changeStatus != nil) {
            changeStatus!(SWReachability.getCurrentNetworkStatus())
        }
    }
}
/// New NSNotification object for identify reachability status chnages
public let kSWReachabilityChangedNotification = NSNotification.Name("kSWReachabilityChangedNotification")

/// This method will call when Reachability status change. And it will notfify using NSNotification
func callback(reachability:SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) {
    let notificationCenter: NotificationCenter = NotificationCenter.default
     notificationCenter.post(name: kSWReachabilityChangedNotification, object: nil)
}

/// Handler
private var KConnectionHandler: UInt8 = 0

/// This class will help to get current reachability status and it notification when status change.
class SWReachability {
    /// reachability status object
    fileprivate var reachabilityStatus : SWReachabilityStatus
    /// Reachability object
    fileprivate var reachability: SCNetworkReachability?
    
    /// When use WWAN this will be true otherwise it will be false
    private(set) var reachableOnWWAN: Bool
    
    /// Default init method
    public convenience init?() {
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)
        
        guard let rachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return nil
        }

        self.init(reachabilityRef: rachability)
    }
    
    /// Init construction with SCNetworkReachability object
    ///
    /// - Parameter reachabilityRef: SCNetworkReachability object
    required public init(reachabilityRef: SCNetworkReachability) {
        reachableOnWWAN = true
        self.reachability = reachabilityRef
        self.reachabilityStatus = .NotReachable
    }
    
    private(set) var isRunningOnDevice: Bool = {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            return false
        #else
            return true
        #endif
    }()
    
    /// Using this method you can get whether connection availble or not
    ///
    /// - Returns: Bool value will be return according to the connection availability
    public class func connected() -> Bool {
        return SWReachability()!.isReachable
    }
    
    /// Class will be helpt to create notification handleer
    ///
    /// - Parameters:
    ///   - currentNetworkStatus: current status will be return under the block
    ///   - changeNetworkSatus: when change the status this block will be trigger and you can get the changed status
    public class func checkNetowrk(currentNetworkStatus: @escaping((SWReachabilityStatus) -> ()) ,changeNetworkSatus: @escaping((SWReachabilityStatus) -> ())) {
        let notificationCenter: NotificationCenter = NotificationCenter.default
        
        let handler = SWReachabilityHandler()
        handler.changeStatus = changeNetworkSatus
        objc_setAssociatedObject(self, &KConnectionHandler, handler, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        let reachability = SWReachability()
        notificationCenter.addObserver(handler, selector: #selector(SWReachabilityHandler.checkNetworkStatus), name: kSWReachabilityChangedNotification, object: nil)
        reachability?.startNotify()
        currentNetworkStatus((reachability?.getCurrentNetworkStatus())!)
    }
    /// Start notify
    private func startNotify() {
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = Unmanaged.passUnretained(self).toOpaque()
        
        SCNetworkReachabilitySetCallback(reachability!, callback, &context)
        SCNetworkReachabilityScheduleWithRunLoop(reachability!, CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue)
    }
    
    /// stop notify
    func stopNotify() {
        if (self.reachability != nil) {
            SCNetworkReachabilityUnscheduleFromRunLoop(reachability!, CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue);
        }
    }
    
    
    /// This is read only parameter and it will assing reachability status
    var isReachable: Bool {
        
        guard isReachableFlagSet else { return false }
        
        if isConnectionRequiredAndTransientFlagSet {
            return false
        }
        
        if isRunningOnDevice {
            if isOnWWANFlagSet && !reachableOnWWAN {
                return false
            }
        }
        return true
    }
    
    /// This is read only parameter and it will assing reachability for wifi
    var isReachableViaWiFi: Bool {
        guard isReachableFlagSet else { return false }
        guard isRunningOnDevice else { return true }
        return !isOnWWANFlagSet
    }
    
    /// This is read only parameter
    private var isReachableFlagSet: Bool {
        return reachabilityFlags.contains(.reachable)
    }
    
    /// This is read only parameter and it will assing reachability for wwan
    var isReachableViaWWAN: Bool {
        return isRunningOnDevice && isReachableFlagSet && isOnWWANFlagSet
    }
    
    /// This is read only parameter
    var isOnWWANFlagSet: Bool {
        #if os(iOS)
            return reachabilityFlags.contains(.isWWAN)
        #else
            return false
        #endif
    }
    
    private var isConnectionRequiredFlagSet: Bool {
        return reachabilityFlags.contains(.connectionRequired)
    }
    private var isInterventionRequiredFlagSet: Bool {
        return reachabilityFlags.contains(.interventionRequired)
    }
    private var isConnectionOnTrafficFlagSet: Bool {
        return reachabilityFlags.contains(.connectionOnTraffic)
    }
    private var isConnectionOnDemandFlagSet: Bool {
        return reachabilityFlags.contains(.connectionOnDemand)
    }
    private var isConnectionOnTrafficOrDemandFlagSet: Bool {
        return !reachabilityFlags.intersection([.connectionOnTraffic, .connectionOnDemand]).isEmpty
    }
    private var isTransientConnectionFlagSet: Bool {
        return reachabilityFlags.contains(.transientConnection)
    }
    private var isLocalAddressFlagSet: Bool {
        return reachabilityFlags.contains(.isLocalAddress)
    }
    private var isDirectFlagSet: Bool {
        return reachabilityFlags.contains(.isDirect)
    }
    private var isConnectionRequiredAndTransientFlagSet: Bool {
        return reachabilityFlags.intersection([.connectionRequired, .transientConnection]) == [.connectionRequired, .transientConnection]
    }
    
    private var reachabilityFlags: SCNetworkReachabilityFlags {
        
        guard let reachabilityRef = self.reachability else { return SCNetworkReachabilityFlags() }
        
        var flags = SCNetworkReachabilityFlags()
        let gotFlags = withUnsafeMutablePointer(to: &flags) {
            SCNetworkReachabilityGetFlags(reachabilityRef, UnsafeMutablePointer($0))
        }
        
        if gotFlags {
            return flags
        } else {
            return SCNetworkReachabilityFlags()
        }
    }
    
    /// THis will method return current Network status
    ///
    /// - Returns: SWReachabilityStatus enum value will be return
    func getCurrentNetworkStatus() -> SWReachabilityStatus {
        guard isReachable else { return .NotReachable }
        
        if isReachableViaWiFi {
            return .Wifi
        }
        if isRunningOnDevice {
            return .WWAN
        }
        
        return .NotReachable
    }
    
    
    /// A class function. This will method return current Network status
    ///
    /// - Returns: SWReachabilityStatus enum value will be return
    public class func getCurrentNetworkStatus() -> SWReachabilityStatus {
        return (SWReachability()?.getCurrentNetworkStatus())!
    }
}
