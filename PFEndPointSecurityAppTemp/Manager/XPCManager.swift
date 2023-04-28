//
//  XPCManager.swift
//  PFEndPointSecurityAppTemp
//
//  Created by AlexHwang on 2023/04/28.
//

import Foundation

protocol JDProviderCommunication: NSObject {
    func registerWithCompletionHandler(_ appID: NSString, WithCompletionHandler completionHandler: @escaping (Bool) -> ())
    func receiveDataWithDictionary(_ data: NSDictionary, appID: NSString, completionHandler reply: @escaping (Bool) -> ())
}

final class XPCManager: NSObject, JDProviderCommunication {
    static let shared = XPCManager()
    
    var connectionList: NSMutableDictionary?
    var providerDelegate: JDProviderCommunication?
    var currentConnection: NSXPCConnection?
    
    weak var JDProviderCommunication: Protocol?
    weak var JDAppCommunication: Protocol?
    
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
