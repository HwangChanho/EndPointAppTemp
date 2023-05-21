//
//  FileNotiUtil.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/05/19.
//

import Foundation
import SystemExtensions

class FileNotificationXPCAppCommunication: NSObject, JDAppCommunication {
    static let shared = FileNotificationXPCAppCommunication()
    private override init() {}
    
    var connected: Bool = false
    var currentRequest: OSSystemExtensionRequest?
    let XPCConnection = XPCManager.shared
    
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
    
    func requestNeedsUserApproval(_ request: OSSystemExtensionRequest) {
        if currentRequest != request {
            let log = "UNEXPECTED NON-CURRENT Request to activate \(request.identifier) succeeded."
            return
        }
        
        let log = "Request to activate \(request.identifier) awaiting approval.\nAwaiting Approval\n"
    }
    
    func requestDidFinishWithResult(_ request: OSSystemExtensionRequest, _ result: OSSystemExtensionRequest.Result) {
        if self.currentRequest != request {
            let log = "UNEXPECTED NON-CURRENT Request to activate \(request.identifier) succeeded."
            return
        }
        
        let log = "Request to activate \(request.identifier) succeeded \(result).\nSuccessfully installed the extension\n"
        
        currentRequest = nil
        
        let notificationQueue = NotificationQueue.default
        let userInfo: NSDictionary = ["info": "Notfication Message : Install SystemExtension Succeed"]
        let notification: NSNotification = NSNotification(name: NSNotification.Name(rawValue: "install-extension"), object: nil, userInfo: (userInfo as! [AnyHashable : Any]))
        notificationQueue.enqueue(notification as Notification, postingStyle: .asap)
    }
    
    func requestDidFailWithError(_ request: OSSystemExtensionRequest, _ error: NSError) {
        if currentRequest != request {
            let log = "UNEXPECTED NON-CURRENT Request to activate \(request.identifier) failed with error \(error)."
            return
        }
        
        let log = "Request to activate \(request.identifier) failed with error \(error).\nFailed to install the extension\n\(error.localizedDescription)"
        
        currentRequest = nil
    }
    
    func installSystemExtension() {
        let log = "Install SystemExtension"
        
        let req: OSSystemExtensionRequest = OSSystemExtensionRequest.activationRequest(forExtensionWithIdentifier: FileNotiNameSpace.PF_ES_EXTENSION_ID.rawValue, queue: .main)
        let vc = FileNotificationViewController()
        req.delegate = vc.self
        OSSystemExtensionManager.shared.submitRequest(req)
        currentRequest = req
        connected = false
    }
    
    func unInstallSystemExtension() {
        let log = "UnInstall SystemExtension"
        
        let req: OSSystemExtensionRequest = OSSystemExtensionRequest.activationRequest(forExtensionWithIdentifier: FileNotiNameSpace.PF_ES_EXTENSION_ID.rawValue, queue: .main)
        OSSystemExtensionManager.shared.submitRequest(req)
        let vc = FileNotificationViewController()
        req.delegate = vc.self
        currentRequest = req
        connected = false
    }
    
    func connectXPC() {
        let log = "XPC Connect"
        let appID = "\(FileNotiNameSpace.APP_ID)_\(getpid())"
        XPCConnection.registerWithMachServiceNameWithDelegateWithAppIDWithCompletionHandler(FileNotiNameSpace.PF_ES_EXTENSION_ID.rawValue as NSString, self, appID as NSString) { [self] success in
            if success {
                connected = true
                let log = "Successfully registered with system extension"
                
                let userInfo: NSDictionary = ["info": "Notfication Message : XPC Connect Succeed"]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "xpc-connect"), object: nil, userInfo: userInfo as? [AnyHashable : Any])
            } else {
                connected = false
                let log = "Registration with system extension failed"
            }
        }
    }
    
    func sendClientData(_ dictSendData: NSDictionary) -> Bool {
        if !connected {
            let log = "XPC not connted"
            return false
        }
        
        var bSucceed = false
        let appID = "\(FileNotiNameSpace.APP_ID)_\(getpid())"
        
        XPCConnection.sendDataFromAppWithAppIDWithResponseHandler(dictSendData, appID: appID as NSString) { success in
            if success {
                bSucceed = true
                let log = "Successfully SendData"
            } else {
                let log = "SendData failed"
            }
        }
        
        return bSucceed
    }
}
