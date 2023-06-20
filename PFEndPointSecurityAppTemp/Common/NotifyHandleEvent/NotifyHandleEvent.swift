//
//  NotifyHandleEvent.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/06/11.
//

import Foundation
import EndpointSecurity

enum SignedID: String {
    case PF_APP_SIGNED_ID = "com.jiran.PFEndPointSecurityApp"
}

//var client: OpaquePointer?
/*
func safeCreateNotifyClient(ppClient: OpaquePointer?) -> Bool {
    if ppClient == nil {
        let result = es_new_client_result_t = es_new_client(ppClient, { client, message in
            notifyHandleEvent(client, message)
        })
        
        if result != ES_NEW_CLIENT_RESULT_SUCCESS {
            print("error ::", "Failed to create the ES client: \(result)")
        }
    }
    
    return true
}
*/
func addNotifyEvent(ppClient: OpaquePointer, pDictData: NSDictionary?) -> Bool {
    if pDictData == nil || safeCreateNotifyClient(ppClient: ppClient) == false {
        return false
    }
    
    let events: NSArray = pDictData?.object(forKey: NotiNameSpace.KEY_ADD_NOTIFY_EVENT) as! NSArray
    for event in events {
        var eventType: es_event_type_t = es_event_type_t(rawValue: event as! UInt32)
        if es_subscribe(ppClient, &eventType, 1) != ES_RETURN_SUCCESS {
            print("error ::", "Failed to subscribe to events")
            return false
        }
    }
    
    let notifyEventFlag: NSNumber? = pDictData?.object(forKey: NotiNameSpace.KEY_ADD_NOTIFY_EVENT_FLAG) as? NSNumber
    if notifyEventFlag != nil {
        let manager = PFCPolicyManager.instance
        
        let _ = manager.addPolicyItem(PolicyKinds.NotifyEventFlag, notifyEventFlag!.intValue)
    }
    
    return true
}
/*
func notifyHandleEvent(_ pClient: OpaquePointer?, pMsg: es_message_t?) -> Bool {
    guard let pointee = pMsg?.process.pointee else { return false }
    
    if getpid() == audit_token_to_pid(pointee.audit_token) { return true }
    
    if pointee.signing_id.length > 0 {
        if strcmp(pointee.signing_id.data, SignedID.PF_APP_SIGNED_ID.rawValue) == 0 { return true }
    }
    
    let dictFileEventData = NSMutableDictionary()
    
    switch pMsg?.event_type {
    case ES_EVENT_TYPE_NOTIFY_EXEC:
        setNotifyExecEventData(dictFileEventData, _pMsg);
        break;
    case ES_EVENT_TYPE_NOTIFY_OPEN:
        SetNotifyOpenEventData(dictFileEventData, _pMsg);
        break;
    case ES_EVENT_TYPE_NOTIFY_CLOSE:
        SetNotifyCloseEventData(dictFileEventData, _pMsg);
        break;
    case ES_EVENT_TYPE_NOTIFY_CREATE:
        SetNotifyCreateEventData(dictFileEventData, _pMsg);
        break;
    case ES_EVENT_TYPE_NOTIFY_LINK:
        SetNotifyLinkEventData(dictFileEventData, _pMsg);
        break;
    case ES_EVENT_TYPE_NOTIFY_MMAP:
        SetNotifyMMapEventData(dictFileEventData, _pMsg);
        break;
    case ES_EVENT_TYPE_NOTIFY_RENAME:
        SetNotifyRenameEventData(dictFileEventData, _pMsg);
        break;
    case ES_EVENT_TYPE_NOTIFY_SETATTRLIST:
        SetNotifySetAttrListEventData(dictFileEventData, _pMsg);
        break;
    case ES_EVENT_TYPE_NOTIFY_SETEXTATTR:
        SetNotifySetExtAttrEventData(dictFileEventData, _pMsg);
        break;
    case ES_EVENT_TYPE_NOTIFY_SETFLAGS:
        SetNotifySetFlagsEventData(dictFileEventData, _pMsg);
        break;
    case ES_EVENT_TYPE_NOTIFY_SETMODE:
        SetNotifySetModeEventData(dictFileEventData, _pMsg);
        break;
    case ES_EVENT_TYPE_NOTIFY_SETOWNER:
        SetNotifySetOwnerEventData(dictFileEventData, _pMsg);
        break;
    case ES_EVENT_TYPE_NOTIFY_UNLINK:
        SetNotifyUnlinkEventData(dictFileEventData, _pMsg);
        break;
    case ES_EVENT_TYPE_NOTIFY_WRITE:
        SetNotifyWriteEventData(dictFileEventData, _pMsg);
        break;
    case ES_EVENT_TYPE_NOTIFY_READLINK:
        SetNotifyReadLinkEventData(dictFileEventData, _pMsg);
        break;
    case ES_EVENT_TYPE_NOTIFY_TRUNCATE:
        SetNotifyTruncateEventData(dictFileEventData, _pMsg);
        break;
        
    default:
        break;
    }
}
*/
