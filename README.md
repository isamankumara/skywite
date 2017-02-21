# <p align="center" style='color:#30a1f3' >SkyWite</p>

<p align="center" >
<img src="http://skywite.com/wp-content/uploads/2015/05/skywite.png" alt="Skywite" title=“SkyWite”>
</p>


[![Version](https://img.shields.io/cocoapods/v/SkyWite.svg?style=flat)](http://cocoapods.org/pods/SkyWite)
[![License](https://img.shields.io/cocoapods/l/SkyWite.svg?style=flat)](http://cocoapods.org/pods/SkyWite)
[![Platform](https://img.shields.io/cocoapods/p/SkyWite.svg?style=flat)](http://cocoapods.org/pods/SkyWite)
[![Twitter](https://img.shields.io/badge/twitter-@SWframeworks-blue.svg?style=flat)](http://twitter.com/SWframeworks)



SkyWite is an open-source and highly versatile multi-purpose frameworks. Clean code and sleek features make SkyWite an ideal choice. Powerful high-level networking abstractions built into Cocoa. It has a modular architecture with well-designed, feature-rich APIs that are a joy to use.

Achieve your deadlines by using SkyWite. You will save Hundred hours. 

Start development using Skywite. Definitely you will be happy....! yeah..

SkyWite being developed in clean code and its sleek features make it the “Dream Framework” for any iOS / Macos developer. Its modular architecture and feature-rich APIs makes it very simple for development. SkyWite’s powerful networking abstraction is built using Cocoa, which makes it easily available for everyone,

Its core being developed on Objective C,  makes it compatible on the following platforms :
-        iOS,
-        Mac OS X,
-        TV OS and

The next question that would pop for any developer is, why build a framework as such when there a many similar ones available. The answer was quite straight forward. 9 out of 10 frameworks out there in the market have the following features:

1. Support all request methods
2. Offline request support
3. HTTP request operation manager
4. Cocoa Pod Support
5. SWIFT Compatible
6. Supports Apple UI Kit.
7. Background request support
8. Session manager
9. Reachability manager
10. Secured 
11. Free support offered around the framework
12. The framework will be continuously updated with the new OS drops
13. Community around the framework to support bug fixes
14. Code amendment flexibility
16. 99% Guaranteed on crash management for the framework
17. Block support
18. MIT License

Above features are not only available on the other frameworks in the market, but is also available on SkyWite, but here is what makes SkyWite special:

19. Offline sync support
20. The frameworks adds in a loading indicator when a request is sent, allows for addition of custom indicators as well
21. A sing line of code to initiate a request, which will approximately save 20 lines of code
22. Block with background request
23. Tag a request (set int value to identify requests)
24. Set priority for offline requests.
25. All the request/response body will generated automatically which would save the developer approximately 50-70 lines of coding


As same as the swnetworking framework we released earlier, this framework also doesn't have any issue. If you find any, I'll fix them as soon as possible. Now we don't need a team as there is no such issues to fix.


# Requirements

You need to add "SystemConfiguration" framework into your project before implement this.


#How to apply to Xcode project

### Downloading Source Code
- [Download Skywite](https://github.com/isamankumara/skywite/archive/master.zip) from gitHub
- Add required frameworks

### Using CocoaPods

SkyWite is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SkyWite"
```

If you are new to CocoaPods, please go to [Wiki](https://guides.cocoapods.org/using/getting-started.html) page.


### Communication

- If you **need any help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/skywite). (Tag 'skywite') or you can send a mail with details ( we will provide fast feedback )
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/skywite).
- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue or you can contribute.
- If you **have a feature request**, send a request mail we will add as soon as possible.
- If you **want to contribute**, submit a pull request.

#Architecture


* `SWRequest`
    - `SWRequest`
    - `SWGet`
    - `SWPost`
    - `SWMultiPart`
    - `SWPut`
    - `SWPatch`
    - `SWDelete`
    - `SWHead`
    - `SWOfflineRequestManger`
* `ResponseType`
    - `SWResponseDataType`
    - `SWResponseJSONDataType`
    - `SWResponseXMLDataType`
    - `SWResponseStringDataType`
    - `SWResponseUIImageType`
    - `SWRequestDataType`
    - `SWRequestFormData`
    - `SWRequestMultiFormData`
    - `SWRequestJSONData`
* `Reachability`
    - `SWReachability`
* `File`
    - `SWMedia`
* `UIKit+SkyWite`
    - `UIImageViewExtension`
    - `UIProgressViewExtension`

# How to Use

## Use HTTP Request will be `NSURLSession`
ALL Requests will be NSURLSession. Session will add in to `NSOperationQueue` . Request creation , response serialization, network reachability handing and offline request as well.

### `GET` Request
```swift
let s  = SWGet()
s.startDataTask(url: "", params:nil, success: { (task, object) in
}) { (task, error) in
    print("error", error)
}
```
If you want send parameters you have two options

```swift
let s  = SWGet()
s.startDataTask(url: "", params:"name=this is name&address=your address", success: { (task, object) in
}) { (task, error) in
    print("error", error)
}
```
If you want to encdoe parameters and values you need to pass `Dictionary` object with keys/values.

```swift
let s  = SWGet()
s.startDataTask(url: "", params:"name=this is name&address=your address", success: { (task, object) in
}) { (task, error) in
    print("error", error)
}
```

We are recommend to use second option because if you have `&` sign with parameter or value it will break sending values.

###  `GET` with Response type 
Available as response types
`SWResponseJSONDataType`, `SWResponseJSONDataType`, `SWResponseXMLDataType`,` SWResponseStringDataType`,`SWResponseUIImageType`  
You need set `responseDataType`.

```swift
// this response will be JSON
let s  = SWGet()
s.responseDataType = SWResponseStringDataType()
s.startDataTask(url: "", params:nil, success: { (task, object) in
print("item", object)
}) { (task, error) in
    print("error", error)
}
```
### `GET` with loading indicator
If you set your parent view to method, loading indicator will be displayed. 
```swift
let s  = SWGet()
s.responseDataType = SWResponseDataType()
s.startDataTask(url: "", params:nil, parentView: self.view , success: { (task, object) in
    print("item", object)
}) { (task, error) in
    print("error", error)
}
```

If you want custom loading view you need to add new `nib` file to your project and name it as 'sw_loadingView'. It will be displayed on the screen.
### Cache Response
If you want to access cached data on the response. You need to use relevant method that include cache block
```swift
let s  = SWGet()
s.responseDataType = SWResponseStringDataType()
s.startDataTask(url: "", params: nil, parentView: self.view, cache: { (response, object) in
    print("chache", object)
}, success: { (task, object) in
    print("success", object)
}) { (task, error) in
    print("success", error)
}
```
### `POST` request (simple)
Cache, Loading view available for the on the relevant method. Please check available methods
```swift
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
```

### `POST` multipart request
It is really easy.
```swift
let s = SWPost()

let image = NSImage(named: "skywite")
let imgData = pngRepresentationOfImage(image: image!)

let media1 = SWMedia(fileName: "imagefile.png", key: "image", data: imgData)
let media2 = SWMedia(fileName: "imagefile.jpg", key: "image2", mineType:"image/jpeg", data: imgData)

s.responseDataType = SWResponseStringDataType()
s.startUploadTask(url: "", files:[media1, media2] , params: ["name":"this is name", "address": "your address"] as AnyObject, success: { (task, object) in

}) { (task, error) in

}

//create with custom mine type one

let media2 = SWMedia(fileName: "imagefile.jpg", key: "image2", mineType:"image/jpeg", data: imgData)

```
### `PUT` simple request
```swift
let s = SWPut()
s.responseDataType = SWResponseStringDataType()
s.startDataTask(url: "", params:"saman=test" as AnyObject  , success: { (task, object) in
    print("item", object)
}) { (task, error) in
    print("error", error)
}
```
### `PATCH` simple request
```swift
let s = SWPatch()
s.responseDataType = SWResponseStringDataType()
s.startDataTask(url: "", params:"saman=test" as AnyObject  , success: { (task, object) in
    print("item", object)
}) { (task, error) in
    print("error", error)
}

```
### `DELETE` simple request
```swift
let s = SWDelete()
s.responseDataType = SWResponseStringDataType()
s.startDataTask(url: "", params:"saman=test" as AnyObject  , success: { (task, object) in
    print("item", object)
}) { (task, error) in
    print("error", error)
}

```

### `HEAD` simple request
```swfit
let s = SWHead()
s.responseDataType = SWResponseStringDataType()
s.startDataTask(url: "", params:"saman=test" as AnyObject  , success: { (task, object) in
    print("item", object)
}) { (task, error) in
    print("error", error)
}
```
## Features
all the following features averrable on all the request types. 
eg : If you want to access you need to call relevant method that include cache block 

### Custom headers
If you want to add custom headers you can set to accessing request object.
```swift
let s = SWPost()
s.reqeust.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
s.responseDataType = SWResponseStringDataType()
s.startDataTask(url: "", params:["name":"this is name", "address": "your address"] as AnyObject  , success: { (task, object) in
    print("item", object)
}) { (task, error) in
    print("error", error)
}
```

### Custom time out
If you want to change request timeout , you have to change property call `timeOut`.
```swift
let s = SWPost()
s.timeOut = 120
s.responseDataType = SWResponseStringDataType()
s.startDataTask(url: "", params:["name":"this is name", "address": "your address"] as AnyObject  , success: { (task, object) in
    print("item", object)
}) { (task, error) in
    print("error", error)
}
```

### Response Encoding
You need to sent object type for the `responseDataType` on all your requests.

```swift
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
```

### `UIImageView` with `SkyWite`
No need to download image and set to `UIImageView` anymore. You can set url to `UIImageView`. 

```swift
// Please use only one method . you can see 4 methods :)

let imageView = UIImageView.init(frame: CGRect(x:0, y:0, width:300, height:300))
imageView.loadWithURLString(url: "")
imageView.loadWithURLString(url: "", loadFromCacheFirst: true)
imageView.loadWithURLString(url: "") { (image) in
}
imageView.loadWithURLString(url: "", loadFromCacheFirst: true) { (image) in
}
```

### Check Reachability
New Reachability class to support block when change network status
available Status

`NotReachable`
`WWAN`
`Wifi`

```swift
if (SWReachability.getCurrentNetworkStatus() == .NotReachable) {
//connection not avaible
}

//if you want to get status chnage notification
SWReachability.checkNetowrk(currentNetworkStatus: { (currentStatus) in
}) { (changedStatus) in
}

```

### Upload progress With Request

```swift
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

```

### Download Progress With Request

```swift
let s = SWPost()
s.responseDataType = SWResponseJSONDataType()
s.startDownloadTask(url: "http://192.168.1.36:3000/api/v1/users/jobs" , params:nil , parentView: nil, sendLaterIfOffline: true, cache: { (cache, response) in
}, success: { (task, response) in
}) { (task, error) in
}
progressView.setRequestForDownload(request: s)
```

### Pass object to response block

You can set custom object to your request object as `userObject` . This will allow any type

```swift
let s = SWPost()
s.userObject = //any type object.

```

### Identify the Request
You can set `tag` for the request

```swift
let s = SWPost()
s.tag = 12;

```

### Offline request from `SkyWite`

This is really simple. First of all you need to send offline request expire time. this is seconds

```swift
SWOfflineManager.requestExpireTime(seconds: 1300)
```

You have methods with parameter passing `sendLaterIfOllfine`. Just pass `YES`. That's it.

```swift
let s = SWPost()
s.responseDataType = SWResponseJSONDataType()
s.startDownloadTask(url: "http://192.168.1.36:3000/api/v1/users/jobs" , params:nil , parentView: nil, sendLaterIfOffline: true, cache: { (cache, response) in
}, success: { (task, response) in
}) { (task, error) in
}

```
If you want catch offline request you need to use following methods. Better to add following lines to your `AppDelegate` didFinishLaunchingWithOptions methods.

```swift
SWOfflineManager.sharedInstance.request(success: { (squreqeust, obj) in
}) { (request, error) in
}
```

Please note you need to set `tag` or `userObject` to identify the request. `userObject` should be `'NSCording' support object 


### Set Task for UIProgressView
Please use following method to set task for UIProgressView

```swift
func setDownloadTask(task: URLSessionDownloadTask) {}
func setUploadTask(task: URLSessionUploadTask) {}
```
# Credits

`SkyWite` is owned and maintained bye the [SkyWite](http://www.skywite.com)
`SkyWite` was originally created by [saman kumara](http://www.isamankumara.com). If you want to contact [me@isamankuamra.com](mailto:me@isamankumara.com)

# Security disclosure

If you believe you have identified a security vulnerability with `SkyWite`, you should report it as soon as possible via email to [me@isamankumara.com](mailto:me@isamankumara.com). Please do not post it to a public issue tracker.

# License

`Skywite` is released under the MIT license. See LICENSE for details.


