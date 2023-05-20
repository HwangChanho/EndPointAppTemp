//
//  ViewController.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/04/19.
//

import Cocoa
import SystemExtensions

enum FileNotiNameSpace: String {
    case PF_ES_EXTENSION_ID = "com.jiran.pcfilter.esextension"
    case APP_ID             = "PFEndPointSecurityApp"
    case ALIAS_FILE_ID      = "com.apple.alias-file"
}

struct attrlist {
    let bitmapcount: u_short                    /* number of attr. bit sets in list (should be 5) */
    let reserved:    UInt16                     /* (to maintain 4-byte alignment) */
    let commonattr:  attrgroup_t                /* common attribute group */
    let volattr:     attrgroup_t                /* Volume attribute group */
    let dirattr:     attrgroup_t                /* directory attribute group */
    let fileattr:    attrgroup_t                /* file attribute group */
    let forkattr:    attrgroup_t                /* fork attribute group */
};

typealias boolVoidHandler = (Bool) -> ()

class FileNotificationXPCAppCommunication: NSObject, JDAppCommunication {
    static let shared = FileNotificationXPCAppCommunication()
    private override init() {}
    
    var connected: Bool = false
    var currentRequest: OSSystemExtensionRequest?
    let XPCConnection = XPCManager.shared
    
    func receiveDataWithDictionary(_ data: NSDictionary, _ reply: boolVoidHandler) {
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
        req.delegate = (self as? OSSystemExtensionRequestDelegate)
        OSSystemExtensionManager.shared.submitRequest(req)
        currentRequest = req
        connected = false
    }
    
    func unInstallSystemExtension() {
        let log = "UnInstall SystemExtension"
        let req: OSSystemExtensionRequest = OSSystemExtensionRequest.activationRequest(forExtensionWithIdentifier: FileNotiNameSpace.PF_ES_EXTENSION_ID.rawValue, queue: .main)
        req.delegate = (self as? OSSystemExtensionRequestDelegate)
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
    
    func ReceiveDataWithDictionaryWithCompletionHandler(_ data: NSDictionary?, _ reply: Bool) {
        
    }
}

class FileNotificationViewController: NSViewController {
    @IBOutlet weak var logSwitch: NSSwitch!
    @IBOutlet weak var addEventComboBox: NSComboBox!
    @IBOutlet weak var delEventComboBox: NSComboBox!
    @IBOutlet var textVIew: NSTextView!
    
    private var textViewLineCount = 0
    
    var notificationInstall: NSObject?
    var notificationXPCConnect: NSObject?
    
    let XPCCommunicationManager = FileNotificationXPCAppCommunication.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func installExtension(_ sender: NSButton) {
        if notificationInstall == nil {
            notificationInstall = NotificationCenter.default.addObserver(forName: NSNotification.Name("install-extension"), object: nil, queue: .main, using: { [self] noti in
                let value = NSDictionary(object: noti.userInfo!, forKey: "info" as NSCopying)
                let log = value
                connectXPC(sender)
                initEventComboBox()
            }) as? NSObject
        }
        
        if notificationXPCConnect == nil {
            notificationXPCConnect = NotificationCenter.default.addObserver(forName: NSNotification.Name("xpc-connect"), object: nil, queue: .main, using: { [self] noti in
                let value = NSDictionary(object: noti.userInfo!, forKey: "info" as NSCopying)
                let log = value
                connectXPC(sender)
            }) as? NSObject
        }
        
        XPCCommunicationManager.installSystemExtension()
    }
    
    @IBAction func connectXPC(_ sender: NSButton) {
        if notificationInstall != nil {
            NSWorkspace.shared.notificationCenter.removeObserver(notificationInstall as Any)
            notificationInstall = nil
        }
        
        XPCCommunicationManager.connectXPC()
    }
    
    @IBAction func unInstallExtension(_ sender: NSButton) {
        XPCCommunicationManager.installSystemExtension()
    }
    
    @IBAction func addAllNotifyEvent(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        let eventTypes = NSMutableArray()
        
        var nNotifyEventFlag = 0
        
        let itemCount = addEventComboBox.numberOfItems
        
        for i in 0..<itemCount {
            let notifyEventType: NSString = "ES_EVENT_TYPE_NOTIFY_\(addEventComboBox.itemObjectValue(at: i))" as NSString
            
            for key in ES_EVENT_TYPE_NOTIFY_DICT.allKeys {
                if key as! Int == 0 { continue }
                
                let value = ES_EVENT_TYPE_NOTIFY_DICT.object(forKey: key)
                if notifyEventType.compare(value as! String) == .orderedSame {
                    eventTypes.add(key)
                    nNotifyEventFlag = nNotifyEventFlag + (ES_EVENT_TYPE_NOTIFY_DICT.object(forKey: key) as! Int)
                    break
                }
            }
        }
        
        dictSendData.setObject(eventTypes, forKey: NotiNameSpace.KEY_ADD_NOTIFY_EVENT as NSCopying)
        dictSendData.setObject(NSNumber(integerLiteral: nNotifyEventFlag), forKey: NotiNameSpace.KEY_ADD_NOTIFY_EVENT_FLAG as NSCopying)
        
        if XPCCommunicationManager.sendClientData(dictSendData) == false {
            let log = "Failed Add Notify Event !!!"
            return
        }
        
        for i in 0..<itemCount {
            delEventComboBox.addItem(withObjectValue: addEventComboBox.itemObjectValue(at: i))
        }
        
        delEventComboBox.selectItem(at: 0)
        addEventComboBox.removeAllItems()
        addEventComboBox.stringValue = ""
    }
    
    @IBAction func addEvent(_ sender: NSButton) {
        let index = addEventComboBox.indexOfSelectedItem
        let selectedItem = addEventComboBox.itemObjectValue(at: index) as! Int
        
        if selectedItem < 0 {
            let log = "not selected disAllowLogComboBox"
            return
        }
        
        let dictSendData = NSMutableDictionary()
        let eventTypes = NSMutableArray()
        let notifyEventType: NSString = "ES_EVENT_TYPE_NOTIFY_\(addEventComboBox.itemObjectValue(at: index))" as NSString
        
        for key in ES_EVENT_TYPE_NOTIFY_DICT.allKeys {
            if key as! Int == 0 { continue }
            
            let value = ES_EVENT_TYPE_NOTIFY_DICT.object(forKey: key)
            if notifyEventType.compare(value as! String) == .orderedSame {
                eventTypes.add(key)
                dictSendData.setObject(ES_EVENT_TYPE_NOTIFY_DICT.object(forKey: key)!, forKey: NotiNameSpace.KEY_ADD_NOTIFY_EVENT_FLAG as NSCopying)
                break
            }
        }
        dictSendData.setObject(eventTypes, forKey: NotiNameSpace.KEY_ADD_NOTIFY_EVENT as NSCopying)
        
        if XPCCommunicationManager.sendClientData(dictSendData) == false {
            let log = "Failed Send Client Data !!!"
            return
        }
        
        delEventComboBox.addItem(withObjectValue: selectedItem)
        delEventComboBox.selectItem(at: 0)
        
        if addEventComboBox.numberOfItems == 1 {
            addEventComboBox.stringValue = ""
        }
        
        addEventComboBox.removeItem(at: index)
        addEventComboBox.selectItem(at: 0)
    }
    
    @IBAction func delEvent(_ sender: NSButton) {
        let index = addEventComboBox.indexOfSelectedItem
        let selectedItem = addEventComboBox.itemObjectValue(at: index) as! Int
        
        if selectedItem < 0 {
            let log = "not selected disAllowLogComboBox"
            return
        }
        
        let dictSendData = NSMutableDictionary()
        let notifyEventTypes = NSMutableArray()
        let notifyEventType: NSString = "ES_EVENT_TYPE_NOTIFY_\(delEventComboBox.itemObjectValue(at: index))" as NSString
        
        for key in ES_EVENT_TYPE_NOTIFY_DICT.allKeys {
            if key as! Int == 0 { continue }
            
            let value = ES_EVENT_TYPE_NOTIFY_DICT.object(forKey: key)
            if notifyEventType.compare(value as! String) == .orderedSame {
                notifyEventTypes.addObjects(from: key as! [Any])
                dictSendData.setObject(ES_EVENT_TYPE_NOTIFY_DICT.object(forKey: key)!, forKey: NotiNameSpace.KEY_SUB_NOTIFY_EVENT_FLAG as NSCopying)
                break
            }
        }
        
        dictSendData.setObject(notifyEventTypes, forKey: NotiNameSpace.KEY_DEL_NOTIFY_EVENT as NSCopying)
        
        if XPCCommunicationManager.sendClientData(dictSendData) == false {
            let log = "Failed Send Client Data !!!"
            return
        }
        
        addEventComboBox.addItem(withObjectValue: selectedItem)
        addEventComboBox.selectItem(at: 0)
        
        if delEventComboBox.numberOfItems == 1 {
            delEventComboBox.stringValue = ""
        }
        
        delEventComboBox.removeItem(at: index)
        delEventComboBox.selectItem(at: 0)
    }
    
    @IBAction func startAuthEvent(_ sender: NSButton) {
        if notificationXPCConnect != nil {
            NSWorkspace.shared.notificationCenter.removeObserver(notificationXPCConnect as Any)
            notificationXPCConnect = nil
        }
        
        let dictSendData = NSMutableDictionary()
        let eventSwitch = NSNumber.init(booleanLiteral: true)
        
        dictSendData.setObject(eventSwitch, forKey: AuthNameSpace.KEY_START_AUTH_EVENT as NSCopying)
        if XPCCommunicationManager.sendClientData(dictSendData) == false {
            let log = "Failed Start Auth Event !!!"
            return
        }
        dictSendData.removeAllObjects()
        
        let notifyEventTypes = NSMutableArray()
        notifyEventTypes.add(NSNumber(integerLiteral: EsEvent.ES_EVENT_TYPE_NOTIFY_OPEN.rawValue))
        notifyEventTypes.add(NSNumber(integerLiteral: EsEvent.ES_EVENT_TYPE_NOTIFY_CLOSE.rawValue))
        notifyEventTypes.add(NSNumber(integerLiteral: EsEvent.ES_EVENT_TYPE_NOTIFY_CREATE.rawValue))
        dictSendData.setObject(notifyEventTypes, forKey: NotiNameSpace.KEY_ADD_NOTIFY_EVENT as NSCopying)
        
        let nNotifyEventFlag = NotifyEventFlag.OpenWithOther.rawValue + NotifyEventFlag.CreateWithOther.rawValue + NotifyEventFlag.CloseWithOther.rawValue
        dictSendData.setObject(NSNumber(integerLiteral: nNotifyEventFlag), forKey: NotiNameSpace.KEY_ADD_NOTIFY_EVENT_FLAG as NSCopying)
        
        if XPCCommunicationManager.sendClientData(dictSendData) == false {
            let log = "Failed Add Notify Event !!!"
            return
        }
        
        let log = "Start Auth Event"
    }
    
    @IBAction func stopAuthEvent(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        let eventSwitch = NSNumber.init(booleanLiteral: true)
        
        dictSendData.setObject(eventSwitch, forKey: AuthNameSpace.KEY_START_AUTH_EVENT as NSCopying)
        if XPCCommunicationManager.sendClientData(dictSendData) == false {
            let log = "Failed Start Auth Event !!!"
            return
        }
        dictSendData.removeAllObjects()
        
        let notifyEventTypes = NSMutableArray()
        notifyEventTypes.add(NSNumber(integerLiteral: EsEvent.ES_EVENT_TYPE_NOTIFY_OPEN.rawValue))
        notifyEventTypes.add(NSNumber(integerLiteral: EsEvent.ES_EVENT_TYPE_NOTIFY_CLOSE.rawValue))
        notifyEventTypes.add(NSNumber(integerLiteral: EsEvent.ES_EVENT_TYPE_NOTIFY_CREATE.rawValue))
        dictSendData.setObject(notifyEventTypes, forKey: NotiNameSpace.KEY_DEL_NOTIFY_EVENT as NSCopying)
        
        let nNotifyEventFlag = NotifyEventFlag.OpenWithOther.rawValue + NotifyEventFlag.CreateWithOther.rawValue + NotifyEventFlag.CloseWithOther.rawValue
        dictSendData.setObject(NSNumber(integerLiteral: nNotifyEventFlag), forKey: NotiNameSpace.KEY_ADD_NOTIFY_EVENT_FLAG as NSCopying)
        
        if XPCCommunicationManager.sendClientData(dictSendData) == false {
            let log = "Failed Add Notify Event !!!"
            return
        }
        
        let log = "Start Auth Event"
    }
    
    @IBAction func printOpenFileItem(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        let reserved = NSNumber(booleanLiteral: true)
        
        dictSendData.setObject(reserved, forKey: AuthNameSpace.KEY_PRINT_OPEN_FILE_ITEM as NSCopying)
        if XPCCommunicationManager.sendClientData(dictSendData) == false {
            let log = "Failed Print Open File Item !!!"
            return
        }
        
        let log = "Print Open File Item"
    }
    
    @IBAction func addExceptionPath(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<EXCEPTION_PATH_LIST.count / EXCEPTION_PATH_LIST[0].count {
            let exceptionPath: NSString = "\(EXCEPTION_PATH_LIST[i])" as NSString
            
            dictSendData.setObject(NSNumber(integerLiteral: PEPolicyKinds.ExceptionPath.rawValue), forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
            dictSendData.setObject(exceptionPath, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) {
                let log = "Failed Add Exception Path !!!"
                return
            }
        }
        
        let log = "Add Exception Path"
    }
    
    @IBAction func delExceptionPath(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<EXCEPTION_PATH_LIST.count / EXCEPTION_PATH_LIST[0].count {
            let exceptionPath: NSString = "\(EXCEPTION_PATH_LIST[i])" as NSString
            
            dictSendData.setObject(NSNumber(integerLiteral: PEPolicyKinds.ExceptionPath.rawValue), forKey: EndPointNameSpace.KEY_DEL_POLICY as NSCopying)
            dictSendData.setObject(exceptionPath, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) {
                let log = "Failed Del Exception Path !!!"
                return
            }
        }
        
        let log = "Del Exception Path"
    }
    
    @IBAction func addMuteProcPath(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<EXCEPTION_PATH_LIST.count / EXCEPTION_PATH_LIST[0].count {
            let exceptionPath: NSString = "\(EXCEPTION_PATH_LIST[i])" as NSString
            
            dictSendData.setObject(NSNumber(integerLiteral: PEPolicyKinds.MuteProcessPath.rawValue), forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
            dictSendData.setObject(exceptionPath, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) {
                let log = "Failed Add Mute Proc Path !!!"
                return
            }
        }
        
        let log = "Add Mute Proc Path"
    }
    
    @IBAction func delMuteProcPath(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<EXCEPTION_PATH_LIST.count / EXCEPTION_PATH_LIST[0].count {
            let exceptionPath: NSString = "\(EXCEPTION_PATH_LIST[i])" as NSString
            
            dictSendData.setObject(NSNumber(integerLiteral: PEPolicyKinds.MuteProcessPath.rawValue), forKey: EndPointNameSpace.KEY_DEL_POLICY as NSCopying)
            dictSendData.setObject(exceptionPath, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) {
                let log = "Failed Del Mute Proc Path !!!"
                return
            }
        }
        
        let log = "Del Mute Proc Path"
    }
    
    private func initEventComboBox() {
        addEventComboBox.removeAllItems()
        delEventComboBox.removeAllItems()
        
        for eventType in ES_EVENT_TYPE_NOTIFY_DICT.allValues {
            let NSEventType: NSString = eventType as! NSString
            
            if NSEventType.compare("ES_EVENT_TYPE_NONE") == .orderedSame { continue }
            addEventComboBox.addItem(withObjectValue: NSEventType.substring(from: 21))
        }
        
        addEventComboBox.selectItem(at: 0)
    }
}

