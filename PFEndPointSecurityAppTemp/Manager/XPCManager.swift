//
//  XPCManager.swift
//  PFEndPointSecurityAppTemp
//
//  Created by AlexHwang on 2023/04/28.
//

import Foundation
import AppKit

protocol JDProviderCommunication: NSObject {
    func registerWithCompletionHandler(_ appID: NSString, WithCompletionHandler completionHandler: @escaping (Bool) -> ())
    func receiveDataWithDictionary(_ data: NSDictionary, appID: NSString, completionHandler reply: @escaping (Bool) -> ())
}

protocol JDAppCommunication: NSObject {
    func receiveDataWithDictionaryWithCompletionHandler(_ data: NSDictionary, _ reply: @escaping (Bool) -> ())
}

class XPCManager: NSObject, JDProviderCommunication, JDAppCommunication {
    static let shared = XPCManager()
    
    typealias boolHandler = (Bool) -> Void
    
    var connectionList: NSMutableDictionary? = nil
    var providerDelegate: JDProviderCommunication? = nil
    var currentConnection: NSXPCConnection? = nil
    var listener: NSXPCListener? = nil
    
    var delegate: JDAppCommunication? = nil
    
    var XPCConnection: NSXPCListenerDelegate? = nil
    
    func receiveDataWithDictionaryWithCompletionHandler(_ data: NSDictionary, _ reply: @escaping (Bool) -> ()) {
        if data.count == 0 {
            reply(false)
            return
        }
        
        if (data.object(forKey: NotiNameSpace.KEY_EVENT_TYPE_NOTIFY) != nil) {
            for key in data.allKeys {
                let NSKey: NSString = key as! NSString
                
                if NSKey.compare(EndPointNameSpace.KEY_STAT, options: .caseInsensitive) == .orderedSame {
                    let stat: NSData = data.object(forKey: EndPointNameSpace.KEY_STAT) as! NSData
                    var stStat: stat?
                    stat.getBytes(&stStat, length: sizeof(stStat))
                    
                    let log = "Key=[stat], Value[dev=\(stStat?.st_dev), ino=\(stStat?.st_ino), mode=\(stStat?.st_mode), nlink=\(stStat?.st_nlink), size=\(stStat?.st_size)]"
                    
                } else if NSKey.compare(EndPointNameSpace.KEY_ATTR_LIST, options: .caseInsensitive) == .orderedSame {
                    let attrList: NSData = data.object(forKey: EndPointNameSpace.KEY_ATTR_LIST) as! NSData
                    var stAttrList: attrlist?
                    attrList.getBytes(&stAttrList, length: sizeof(stAttrList))
                    
                    let log = "Key=[attrlist], Value[bitmapcount=\(String(describing: stAttrList?.bitmapcount)), reserved=\(String(describing: stAttrList?.reserved)), commonattr=\(String(describing: stAttrList?.commonattr)) ...]"
                } else if NSKey.compare(NotiNameSpace.KEY_EVENT_TYPE_NOTIFY, options: .caseInsensitive) == .orderedSame {
                    let log = "Key=[event_type], Value[\(String(describing: ES_EVENT_TYPE_NOTIFY_DICT.object(forKey: data.object(forKey: NSKey)!)))]"
                } else if NSKey.compare(EndPointNameSpace.KEY_FFLAG, options: .caseInsensitive) == .orderedSame {
                    let fflag: NSNumber = data.object(forKey: NSKey) as! NSNumber
                    let log = "Key=[fflag], Value[\(fflag.intValue)]"
                } else {
                    let log = "Key=[\(NSKey)], Value=[\(String(describing: data.object(forKey: NSKey)))]"
                }
            }
        } else if data.object(forKey: AuthNameSpace.KEY_EVENT_TYPE_AUTH) != nil {
            let eventType: NSString = data.object(forKey: AuthNameSpace.KEY_EVENT_TYPE_AUTH) as! NSString
            if eventType.compare(AuthNameSpace.EVENT_TYPE_IS_ALLOW_FILE_BURN) == .orderedSame {
                let log1 = "SrcPath =[\(String(describing: data.object(forKey: EndPointNameSpace.KEY_SRC_PATH)))]"
                let log2 = "ProcPath=[\(String(describing: data.object(forKey: EndPointNameSpace.KEY_PROC_PATH)))]"
                let log3 = "Pid     =[\(String(describing: data.object(forKey: EndPointNameSpace.KEY_PID)))]"
                
                reply(true)
                return
            } else if eventType.compare(AuthNameSpace.EVENT_TYPE_IS_ALLOW_FILE_OPEN) == .orderedSame {
                print("undefined data!!", data)
                
                for key in data.allKeys {
                    let NSKey: NSString = key as! NSString
                    
                    if NSKey.compare(EndPointNameSpace.KEY_STAT, options: .caseInsensitive) == .orderedSame {
                        let stat: NSData = data.object(forKey: EndPointNameSpace.KEY_STAT) as! NSData
                        var stStat: stat?
                        stat.getBytes(&stStat, length: sizeof(stStat))
                        
                        let log = "Key=[stat], Value[dev=\(String(describing: stStat?.st_dev)), ino=\(String(describing: stStat?.st_ino)), mode=\(String(describing: stStat?.st_mode)), nlink=\(String(describing: stStat?.st_nlink)), size=\(String(describing: stStat?.st_size))]"
                        continue
                    }
                }
                
                reply(true)
                return
            } else {
                for key in data.allKeys {
                    let NSKey: NSString = key as! NSString
                    
                    if NSKey.compare(EndPointNameSpace.KEY_STAT, options: .caseInsensitive) == .orderedSame {
                        let stat: NSData = data.object(forKey: EndPointNameSpace.KEY_STAT) as! NSData
                        var stStat: stat?
                        stat.getBytes(&stStat, length: sizeof(stStat))
                        
                        let log = "Stat : dev=[\(String(describing: stStat?.st_dev))], ino=[\(String(describing: stStat?.st_ino))], mode=[\(String(describing: stStat?.st_mode))]"
                    } else if NSKey.compare(EndPointNameSpace.KEY_ATTR_LIST, options: .caseInsensitive) == .orderedSame {
                        let attrList: NSData = data.object(forKey: EndPointNameSpace.KEY_ATTR_LIST) as! NSData
                        var stAttrList: attrlist?
                        attrList.getBytes(&stAttrList, length: sizeof(stAttrList))
                        
                        let log = "Attrlist : bitmapcount=[\(String(describing: stAttrList?.bitmapcount))], reserved=[\(String(describing: stAttrList?.reserved))], commonattr=[\(String(describing: stAttrList?.commonattr))]]"
                    } else {
                        let log = "\(NSKey)=[\(String(describing: data.object(forKey: NSKey)))]"
                    }
                    
                }
            }
        }
        
        reply(true)
    }
    
    func registerWithMachServiceNameWithDelegateWithAppIDWithCompletionHandler(_ machServiceName: NSString, _ delegate: JDAppCommunication, _ appID: NSString, _ completionHandler: @escaping boolHandler) {
        self.delegate = delegate
        
        if currentConnection == nil {
            let options: NSXPCConnection.Options = .privileged
            let newConnection = NSXPCConnection.init(machServiceName: machServiceName as String, options: options)

            newConnection.exportedInterface = .none
            newConnection.exportedObject = delegate
            currentConnection = newConnection
            newConnection.resume()
            
            let providerProxy: NSObject? = newConnection.remoteObjectProxyWithErrorHandler { [self] error in
                let log = "Failed to register with the provider: \(error.localizedDescription)"
                
                if currentConnection != nil {
                    currentConnection?.invalidate()
                    currentConnection = nil
                }
                
                completionHandler(false)
            } as? NSObject
            
            if providerProxy != nil {
                registerWithCompletionHandler(appID, WithCompletionHandler: completionHandler)
            }
            
        } else {
            let log = "Already registered with the provider"
            completionHandler(true)
        }
    }
//
//    func registerWithBundleWithDelegateWithAppIDWithCompletionHandler(_ bundle: Bundle, _ delegate: NSObjet<JDAppCommunication>, _ appID: NSString, _ completionHandler: @escaping (Bool) -> Void) {
//        if currentConnection == nil {
//            let machServiceName: NSString = self.extensionMachServiceNameFromBundle(bundle: bundle)
////            self.
//        }
//    }
    
    func sendDataFromProviderWithAppIDWithResponseHandler(_ data: NSDictionary, appID: NSString, responseHandler: @escaping (Bool) -> ()) -> Bool {
        guard let connection = connectionList?.object(forKey: appID) else { return false }

        let appProxy: JDAppCommunication = (connection as AnyObject).synchronousRemoteObjectProxyWithErrorHandler { err in
            print("Failed to XPC to app with data : \(err)")
            self.connectionList?.removeObject(forKey: appID)
            responseHandler(true)
        } as! JDAppCommunication

        appProxy.receiveDataWithDictionaryWithCompletionHandler(data, responseHandler)

        if self.connectionList?.object(forKey: appID) == nil {
            return false
        }

        return true
    }
    
    func sendDataFromAppWithAppIDWithResponseHandler(_ data: NSDictionary, appID: NSString, responseHandler: @escaping (Bool) -> ()) -> Bool {
        let providerProxy: JDProviderCommunication? = currentConnection?.synchronousRemoteObjectProxyWithErrorHandler({ err in
            print("Failed to register with the provider : \(err)")
            if self.currentConnection != nil {
                self.currentConnection?.invalidate()
                self.currentConnection = nil
            }
            responseHandler(false)
        }) as? JDProviderCommunication
        
        if providerProxy == nil { return false }
        
        providerProxy?.receiveDataWithDictionary(data, appID: appID, completionHandler: responseHandler)
        
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
    
//    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) {
//        newConnection.exportedInterface = NSXPCInterface(with: JDProviderCommunication!)
//        newConnection.exportedObject = self
//        newConnection.remoteObjectInterface = NSXPCInterface(with: JDAppCommunication!)
//        newConnection.invalidationHandler = { self.currentConnection = nil }
//        newConnection.interruptionHandler = { self.currentConnection = nil }
//
//        self.currentConnection = newConnection
//        newConnection.resume()
//
//    }
    
    func getAllAppID() -> NSArray? {
        if connectionList == nil {
            return nil
        }
        
        return connectionList!.allKeys as NSArray
    }
}



