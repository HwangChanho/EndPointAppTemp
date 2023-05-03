//
//  XPCManager.swift
//  PFEndPointSecurityAppTemp
//
//  Created by AlexHwang on 2023/04/28.
//

/*

import Foundation
import AppKit

protocol JDProviderCommunication: NSObject {
    func registerWithCompletionHandler(_ appID: NSString, WithCompletionHandler completionHandler: @escaping (Bool) -> ())
    func receiveDataWithDictionary(_ data: NSDictionary, appID: NSString, completionHandler reply: @escaping (Bool) -> ())
}

protocol JDAppCommunication: NSObject {
    func ReceiveDataWithDictionaryWithCompletionHandler(_ data: NSDictionary?, _ reply: Bool)
}

final class XPCManager: NSObject, JDProviderCommunication, JDAppCommunication {
    static let shared = XPCManager()
    
    var connectionList: NSMutableDictionary?
    var providerDelegate: JDProviderCommunication?
    var currentConnection: NSXPCConnection?
    var listener: NSXPCListener?
    
    func ReceiveDataWithDictionaryWithCompletionHandler(_ data: NSDictionary?, _ reply: Bool) {
        
    }
    
    func registerWithMachServiceNameWithDelegateWithAppIDWithCompletionHandler(_ machServiceName: NSString, _ delegate: NSObjet<JDAppCommunication>, _ appID: NSString, _ completionHandler: @escaping (Bool) -> Void) {
        if currentConnection == nil {
            let options: Options = {0}
            let newConnection: NSXPCConnection = NSXPCConnection.init(machServiceName: machServiceName, options: options)
            
            newConnection.exportedInterface = NSXPCInterface.init(protocol: JDAppCommunication)
            newConnection.exportedObject = delegate
            currentConnection = newConnection
            newConnection.resume()
            
//            let providerProxy: NSObject<JDProviderCommunication> = newConnection
        }
    }
    
    func registerWithBundleWithDelegateWithAppIDWithCompletionHandler(_ bundle: Bundle, _ delegate: NSObjet<JDAppCommunication>, _ appID: NSString, _ completionHandler: @escaping (Bool) -> Void) {
        if currentConnection == nil {
            let machServiceName: NSString = self.extensionMachServiceNameFromBundle(bundle: bundle)
//            self.
        }
    }
    
    func sendDataFromProviderWithAppIDWithResponseHandler(_ data: NSDictionary, appID: NSString, responseHandler: @escaping (Bool) -> ()) -> Bool {
        guard let connection: NSXPCConnection = connectionList?.object(forKey: appID) else { return false }
        
        let appProxy: NSObject<JDAppCommunication> = connection.synchronousRemoteObjectProxyWithErrorHandler { err in
            print("Failed to XPC to app with data : \(err)")
            self.connectionList?.removeObject(forKey: appID)
            responseHandler(true)
        }
        
        appProxy(ReceiveDataWithDictionaryWithCompletionHandler(data, responseHandler))
        
        if self.connectionList?.object(forKey: appID) == nil {
            return false
        }
        
        return true
    }
    
    func sendDataFromAppWithAppIDWithResponseHandler(_ data: NSDictionary, appID: NSString, responseHandler: @escaping (Bool) -> ()) -> Bool {
        let providerProxy: NSObject = currentConnection?.synchronousRemoteObjectProxyWithErrorHandler({ err in
            print("Failed to register with the provider : \(err)")
            if self.currentConnection != nil {
                self.currentConnection?.invalidate()
                self.currentConnection = nil
            }
            responseHandler(false)
        }) as! NSObject
        
        if providerProxy == nil { return false }
        
        receiveDataWithDictionary(data, appID: appID, completionHandler: responseHandler)
        
        return true
    }
    
    func sendDataWithDictionaryWithAppIDWithResponseHandler(_ data: NSDictionary, appID: NSString, responseHandler: @escaping (Bool) -> ()) -> Bool {
        if listener == nil {
            return sendDataFromAppWithAppIDWithResponseHandler(data, appID: appID, responseHandler: responseHandler)
        }
        
        if appID != nil {
            return sendDataFromProviderWithAppIDWithResponseHandler(data, appID: appID, responseHandler: responseHandler)
        }
        
        return false
    }
    
    func extensionMachServiceNameFromBundle(bundle: Bundle) -> NSString {
        let dictNetworkExtensionKey: NSDictionary = bundle.object(forInfoDictionaryKey: Constant.NSKey.KEY_NETWORK_EXTENSION) as! NSDictionary
        
        let machServiceName: NSString = dictNetworkExtensionKey[Constant.NSKey.KEY_NE_MACH_SERVICE_NAME] as! NSString
        
        return machServiceName
    }
    
    func registerWithCompletionHandler(_ appID: NSString, WithCompletionHandler completionHandler: @escaping (Bool) -> ()) {
        connectionList?.setObject(self.currentConnection!, forKey: appID)
        
        if providerDelegate != nil {
            providerDelegate?.registerWithCompletionHandler(appID, WithCompletionHandler: completionHandler)
            return
        }
        
        completionHandler(true)
    }
    
    func receiveDataWithDictionary(_ data: NSDictionary, appID: NSString, completionHandler reply: @escaping (Bool) -> ()) {
        connectionList?.setObject(self.currentConnection!, forKey: appID)
        
        if providerDelegate != nil {
            providerDelegate?.receiveDataWithDictionary(data, appID: appID, completionHandler: reply)
            return
        }
        
        reply(true)
    }
    
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) {
        newConnection.exportedInterface = NSXPCInterface(with: JDProviderCommunication!)
        newConnection.exportedObject = self
        newConnection.remoteObjectInterface = NSXPCInterface(with: JDAppCommunication!)
        newConnection.invalidationHandler = { self.currentConnection = nil }
        newConnection.interruptionHandler = { self.currentConnection = nil }
        
        self.currentConnection = newConnection
        newConnection.resume()
        
    }
    
    func getAllAppID() -> NSArray? {
        if connectionList == nil {
            return nil
        }
        
        return connectionList!.allKeys as NSArray
    }
}


*/
