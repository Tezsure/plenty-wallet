import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
    
    private var eventSink: FlutterEventSink?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: "com.beacon_flutter/beacon",
                                                 binaryMessenger: controller.binaryMessenger)
        
        let beaconController = BeaconController()
        
        let eventChannel = FlutterEventChannel(name: "com.beacon_flutter/beaconEvent", binaryMessenger: controller.binaryMessenger)
        eventChannel.setStreamHandler(self)
        
        
        methodChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if(call.method == "startBeacon"){
                beaconController.startBeacon(address: call.arguments as? String ?? "",onInitCompleted: { data in
                    if data == false{
                        result("0")
                    } else{
                        beaconController.listenForRequests(onMessage: {data in if self.eventSink != nil {
                            self.eventSink?(data)
                        }})
                        result("1")
                    }
                })
            }
            else if(call.method == "addPeer"){
                guard let newData = call.arguments as? [String:Any] else{
                    result("Error in parameters")
                    return
                }
                
                var id, name, publicKey, relayServer, version: String
                id = ""
                name = ""
                publicKey = ""
                relayServer = ""
                version = ""
                if let newId = newData["id"]{
                    id = "\(newId)"
                }
                if let newName = newData["name"]{
                    name = "\(newName)"
                }
                if let newKey = newData["publicKey"]{
                    publicKey = "\(newKey)"
                }
                if let newServer = newData["relayServer"]{
                    relayServer = "\(newServer)"
                }
                if let newVersion = newData["version"]{
                    version = "\(newVersion)"
                }
                
                beaconController.addPeer(id: id, name: name, publicKey: publicKey, relayServer: relayServer, version: version)
                result("1")
                
            }
            else if(call.method == "respond"){
                guard let newData = call.arguments as? [String:Any] else{
                    result("Error in parameters")
                    return
                }
                var grant = ""
                var txHash = ""
                var accountAddress = ""
                if let newgrant = newData["result"]{
                    grant = "\(newgrant)"
                }
                if let newTxHash = newData["opHash"]{
                    txHash = "\(newTxHash)"
                }
                if let newaccountAddress = newData["accountAddress"]{
                    accountAddress = "\(newaccountAddress)"
                }
                beaconController.sendResponse(isGranted: grant, txHash: txHash, accountAddress: accountAddress)
                result("1")
            }
            // result(FlutterMethodNotImplemented)
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    public func onListen(withArguments arguments: Any?,
                         eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}

//class SwiftStreamHandler: NSObject, FlutterStreamHandler {
//
//     var beaconController:BeaconController
//
//    var sink: FlutterEventSink
//
//    internal required init(beaconController: BeaconController) {
//         self.beaconController = beaconController
////        self.sink = nil
//    }
//
//    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
////        events(1)
////        var sink:
////        if events != nil{
//        self.sink = events
//        sink = events
//            self.beaconController.listenForRequests(sink: self.sink)
////        }
//
//
////        events(true) // any generic type or more compex dictionary of [String:Any]
////        events(FlutterError(code: "ERROR_CODE",
////                             message: "Detailed message",
////                             details: nil)) // in case of errors
////        events(FlutterEndOfEventStream) // when stream is over
//        return nil
//    }
//
//    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
//        return nil
//    }
//}

//class SwiftStreamHandler: NSObject, FlutterStreamHandler {
//
//    var beaconController:BeaconController
//
//    internal required init(beaconController:BeaconController) {
//        self.beaconController = beaconController
//    }
//
//    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
//        self.beaconController?.onNewRequest = {
//            data in events(data)
//        }
////        events(true) // any generic type or more compex dictionary of [String:Any]
////        events(FlutterError(code: "ERROR_CODE",
////                             message: "Detailed message",
////                             details: nil)) // in case of errors
////        events(FlutterEndOfEventStream) // when stream is over
//        return nil
//    }
//
//    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
//        return nil
//    }
//}

