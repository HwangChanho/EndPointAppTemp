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
    var bitmapcount: u_short                    /* number of attr. bit sets in list (should be 5) */
    var reserved:    UInt16                     /* (to maintain 4-byte alignment) */
    var commonattr:  attrgroup_t                /* common attribute group */
    var volattr:     attrgroup_t                /* Volume attribute group */
    var dirattr:     attrgroup_t                /* directory attribute group */
    var fileattr:    attrgroup_t                /* file attribute group */
    var forkattr:    attrgroup_t                /* fork attribute group */
};

typealias boolVoidHandler = (Bool) -> ()

class FileNotificationViewController: NSViewController, OSSystemExtensionRequestDelegate, ShowLogDelegate {
    func request(_ request: OSSystemExtensionRequest, actionForReplacingExtension existing: OSSystemExtensionProperties, withExtension ext: OSSystemExtensionProperties) -> OSSystemExtensionRequest.ReplacementAction {
        print(#function)
        return .replace
    }
    
    func requestNeedsUserApproval(_ request: OSSystemExtensionRequest) {
        print(#function)
    }
    
    func request(_ request: OSSystemExtensionRequest, didFinishWithResult result: OSSystemExtensionRequest.Result) {
        print(#function)
    }
    
    func request(_ request: OSSystemExtensionRequest, didFailWithError error: Error) {
        print(#function)
    }
    
    @IBOutlet weak var logSwitch: NSSwitch!
    @IBOutlet weak var addEventComboBox: NSComboBox!
    @IBOutlet weak var delEventComboBox: NSComboBox!
    @IBOutlet var textView: NSTextView!
    
    private var textViewLineCount = 0
    
    var notificationInstall: NSObject? = nil
    var notificationXPCConnect: NSObject? = nil
    
    let XPCCommunicationManager = FileNotificationXPCAppCommunication.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        XPCCommunicationManager.delegate = self
    }
    
    @IBAction func installExtension(_ sender: NSButton) {
        if notificationInstall == nil {
            notificationInstall = NotificationCenter.default.addObserver(
                forName: NSNotification.Name("install-extension"),
                object: nil,
                queue: .main,
                using: { [self] noti in
                    let value = noti.userInfo?["info"]
                    setLog(value as! String)
                    connectXPC(sender)
                    initEventComboBox()
                }) as? NSObject
        }
        
        if notificationXPCConnect == nil {
            notificationXPCConnect = NotificationCenter.default.addObserver(
                forName: NSNotification.Name("xpc-connect"),
                object: nil,
                queue: .main,
                using: { [self] noti in
                    let value = noti.userInfo?["info"]
                    setLog(value as! String)
                    connectXPC(sender)
                }) as? NSObject
        }
        
        XPCCommunicationManager.installSystemExtension()
    }
    
    @IBAction func connectXPC(_ sender: Any) {
        
        if notificationInstall != nil {
            NotificationCenter.default.removeObserver(notificationInstall)
            notificationInstall = nil
        }
        
        XPCCommunicationManager.connectXPC()
    }
    
    @IBAction func unInstallExtension(_ sender: NSButton) {
        XPCCommunicationManager.unInstallSystemExtension()
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
            setLog("Failed Add Notify Event !!!")
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
            setLog("not selected disAllowLogComboBox")
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
            setLog("Failed Send Client Data !!!")
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
            setLog("not selected disAllowLogComboBox")
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
            setLog("Failed Send Client Data !!!")
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
            NotificationCenter.default.removeObserver(notificationXPCConnect)
            notificationXPCConnect = nil
        }
        
        let dictSendData = NSMutableDictionary()
        let eventSwitch = NSNumber.init(booleanLiteral: true)
        
        dictSendData.setObject(eventSwitch, forKey: AuthNameSpace.KEY_START_AUTH_EVENT as NSCopying)
        if XPCCommunicationManager.sendClientData(dictSendData) == false {
            setLog("Failed Start Auth Event !!!")
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
            setLog("Failed Add Notify Event !!!")
            return
        }
        
        setLog("Start Auth Event")
    }
    
    @IBAction func stopAuthEvent(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        let eventSwitch = NSNumber.init(booleanLiteral: true)
        
        dictSendData.setObject(eventSwitch, forKey: AuthNameSpace.KEY_START_AUTH_EVENT as NSCopying)
        if XPCCommunicationManager.sendClientData(dictSendData) == false {
            setLog("Failed Start Auth Event !!!")
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
            setLog("Failed Add Notify Event !!!")
            return
        }
        
        setLog("Start Auth Event")
    }
    
    @IBAction func printOpenFileItem(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        let reserved = NSNumber(booleanLiteral: true)
        
        dictSendData.setObject(reserved, forKey: AuthNameSpace.KEY_PRINT_OPEN_FILE_ITEM as NSCopying)
        if XPCCommunicationManager.sendClientData(dictSendData) == false {
            setLog("Failed Print Open File Item !!!")
            return
        }
        
        setLog("Print Open File Item")
    }
    
    @IBAction func addExceptionPath(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<EXCEPTION_PATH_LIST.count / EXCEPTION_PATH_LIST[0].count {
            let exceptionPath: NSString = "\(EXCEPTION_PATH_LIST[i])" as NSString
            
            dictSendData.setObject(NSNumber(integerLiteral: PEPolicyKinds.ExceptionPath.rawValue), forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
            dictSendData.setObject(exceptionPath, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) {
                setLog("Failed Add Exception Path !!!")
                return
            }
        }
        
        setLog("Add Exception Path")
    }
    
    @IBAction func delExceptionPath(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<EXCEPTION_PATH_LIST.count / EXCEPTION_PATH_LIST[0].count {
            let exceptionPath: NSString = "\(EXCEPTION_PATH_LIST[i])" as NSString
            
            dictSendData.setObject(NSNumber(integerLiteral: PEPolicyKinds.ExceptionPath.rawValue), forKey: EndPointNameSpace.KEY_DEL_POLICY as NSCopying)
            dictSendData.setObject(exceptionPath, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) {
                setLog("Failed Del Exception Path !!!")
                return
            }
        }
        
        setLog("Del Exception Path")
    }
    
    @IBAction func addMuteProcPath(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<EXCEPTION_PATH_LIST.count / EXCEPTION_PATH_LIST[0].count {
            let exceptionPath: NSString = "\(EXCEPTION_PATH_LIST[i])" as NSString
            
            dictSendData.setObject(NSNumber(integerLiteral: PEPolicyKinds.MuteProcessPath.rawValue), forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
            dictSendData.setObject(exceptionPath, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) {
                setLog("Failed Add Mute Proc Path !!!")
                return
            }
        }
        
        setLog("Add Mute Proc Path")
    }
    
    @IBAction func delMuteProcPath(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<EXCEPTION_PATH_LIST.count / EXCEPTION_PATH_LIST[0].count {
            let exceptionPath: NSString = "\(EXCEPTION_PATH_LIST[i])" as NSString
            
            dictSendData.setObject(NSNumber(integerLiteral: PEPolicyKinds.MuteProcessPath.rawValue), forKey: EndPointNameSpace.KEY_DEL_POLICY as NSCopying)
            dictSendData.setObject(exceptionPath, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) {
                setLog("Failed Del Mute Proc Path !!!")
                return
            }
        }
        
        setLog("Del Mute Proc Path")
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
    
    private func setLog(_ text: String) {
        textViewLineCount = setTextViewText(self.textView, text, textViewLineCount)
        self.textView.scrollToEndOfDocument(self)
    }
    
    func showLogMessage(_ log: String) {
        print(#function)
        textViewLineCount = setTextViewText(self.textView, log, textViewLineCount)
        self.textView.scrollToEndOfDocument(self)
    }
}

// MARK: - IS SignedId
extension FileNotificationViewController {
    func isMessengerSignedID(_ data: NSDictionary) -> Bool {
        let procSignedid: NSString = data.object(forKey: EndPointNameSpace.KEY_PROC_SIGNED_ID) as! NSString
        
        for i in 0..<MESSENGER_APP.count {
            if procSignedid.compare(MESSENGER_APP[i].signedID! as String, options: .caseInsensitive) == .orderedSame {
                return true
            }
        }
        return false
    }
    
    func isWebBrowserSignedId(_ data: NSDictionary) -> Bool {
        let procSignedid: NSString = data.object(forKey: EndPointNameSpace.KEY_PROC_SIGNED_ID) as! NSString
        
        for i in 0..<WEB_BROWSER_FILE_READ_SIGNED_ID.count {
            if procSignedid.compare(WEB_BROWSER_FILE_READ_SIGNED_ID[i] as String, options: .caseInsensitive) == .orderedSame {
                return true
            }
        }
        return false
    }
    
    func isFTPSignedId(_ data: NSDictionary) -> Bool {
        let procSignedid: NSString = data.object(forKey: EndPointNameSpace.KEY_PROC_SIGNED_ID) as! NSString
        
        for i in 0..<FTP_APP.count {
            if procSignedid.compare(FTP_APP[i].signedID! as String, options: .caseInsensitive) == .orderedSame {
                return true
            }
        }
        return false
    }
    
    func isMailSignedId(_ data: NSDictionary) -> Bool {
        let procSignedid: NSString = data.object(forKey: EndPointNameSpace.KEY_PROC_SIGNED_ID) as! NSString
        
        for i in 0..<MAIL_APP.count {
            if procSignedid.compare(MAIL_APP[i].signedID! as String, options: .caseInsensitive) == .orderedSame {
                return true
            }
        }
        return false
    }
}
