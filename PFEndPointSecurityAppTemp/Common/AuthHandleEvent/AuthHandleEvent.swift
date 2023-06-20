//
//  AuthHandleEvent.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/06/11.
//

import Foundation
import EndpointSecurity
import Dispatch

var g_AuthEventQueue: DispatchQueue?
var g_bIsStartAuthEvent = false

func initDisPatchQueue() {
    if g_AuthEventQueue != nil {
        return
    }

    g_AuthEventQueue = DispatchQueue(label: "auth_event_queue", attributes: .concurrent)
}

func AUTH_HANDLE_EVENT_WORKER(_ function: (_ pClient: OpaquePointer, _ pMsg: es_message_t) -> Void) {
    
}
/*
func authHandleEvent(_ pClient: UnsafeMutablePointer<es_client_t>, _ pMsg: UnsafePointer<es_message_t>) {
    guard let pMsgCopy = es_retain_message(pMsg).assumingMemoryBound(to: es_message_t.self) else {
        return
    }
    
    switch pMsgCopy.pointee.event_type {
    case ES_EVENT_TYPE_AUTH_EXEC:
        authHandleEventWorker(AuthHandleExecWorker)
    case ES_EVENT_TYPE_AUTH_OPEN:
        authHandleEventWorker(AuthHandleOpenWorker)
    case ES_EVENT_TYPE_AUTH_RENAME:
        authHandleEventWorker(AuthHandleRenameWorker)
    case ES_EVENT_TYPE_AUTH_SIGNAL:
        authHandleEventWorker(AuthHandleSignalWorker)
    case ES_EVENT_TYPE_AUTH_UNLINK:
        authHandleEventWorker(AuthHandleUnlinkWorker)
    case ES_EVENT_TYPE_AUTH_TRUNCATE:
        authHandleEventWorker(AuthHandleTruncateWorker)
    case ES_EVENT_TYPE_AUTH_LINK:
        authHandleEventWorker(AuthHandleLinkWorker)
    case ES_EVENT_TYPE_AUTH_CREATE:
        authHandleEventWorker(AuthHandleCreateWorker)
    case ES_EVENT_TYPE_AUTH_SETATTRLIST:
        authHandleEventWorker(AuthHandleSetAttrListWorker)
    case ES_EVENT_TYPE_AUTH_SETEXTATTR:
        authHandleEventWorker(AuthHandleSetExtAttrWorker)
    case ES_EVENT_TYPE_AUTH_SETFLAGS:
        authHandleEventWorker(AuthHandleSetFlagsWorker)
    case ES_EVENT_TYPE_AUTH_SETMODE:
        authHandleEventWorker(AuthHandleSetModeWorker)
    case ES_EVENT_TYPE_AUTH_SETOWNER:
        authHandleEventWorker(AuthHandleSetOwnerWorker)
    case ES_EVENT_TYPE_AUTH_DELETEEXTATTR:
        authHandleEventWorker(AuthHandleDelExtAttrWorker)
    case ES_EVENT_TYPE_AUTH_SETACL:
        authHandleEventWorker(AuthHandleSetAclWorker)
    default:
        if pMsgCopy.pointee.action_type == ES_ACTION_TYPE_AUTH {
            es_respond_auth_result(pClient, pMsgCopy, ES_AUTH_RESULT_ALLOW, true)
            es_free_message(pMsgCopy)
        }
    }
}
*/

func authHandleEventWorker(_ worker: () -> Void) {
    worker()
}
 
/*
func startAuthHandleEvent(ppClient: OpaquePointer?) -> Bool {
    if ppClient != nil {
        return true
    }
    
    initDisPatchQueue()
    
    let eResult = es_new_client(ppClient) { pClient, pMsg in
        <#code#>
    }
    if eResult != ES_NEW_CLIENT_RESULT_SUCCESS {
        os_log_error(OS_LOG_DEFAULT, "Failed to create the ES client: %d", eResult)
        return false
    }
    
    let arEvents: [es_event_type_t] = [
        ES_EVENT_TYPE_AUTH_EXEC,
        ES_EVENT_TYPE_AUTH_OPEN,
        ES_EVENT_TYPE_AUTH_RENAME,
        ES_EVENT_TYPE_AUTH_SIGNAL,
        ES_EVENT_TYPE_AUTH_UNLINK,
        ES_EVENT_TYPE_AUTH_TRUNCATE,
        ES_EVENT_TYPE_AUTH_LINK,
        ES_EVENT_TYPE_AUTH_CREATE,
        ES_EVENT_TYPE_AUTH_SETATTRLIST,
        ES_EVENT_TYPE_AUTH_SETEXTATTR,
        ES_EVENT_TYPE_AUTH_SETFLAGS,
        ES_EVENT_TYPE_AUTH_SETMODE,
        ES_EVENT_TYPE_AUTH_SETOWNER,
        ES_EVENT_TYPE_AUTH_DELETEEXTATTR,
        ES_EVENT_TYPE_AUTH_SETACL
    ]
    
    if es_subscribe(ppClient.pointee, arEvents, UInt32(arEvents.count)) != ES_RETURN_SUCCESS {
        os_log_error(OS_LOG_DEFAULT, "Failed to subscribe to events")
        es_delete_client(ppClient.pointee)
        ppClient.pointee = nil
        return false
    }
    
    g_bIsStartAuthEvent = true
    return true
}
*/
func stopAuthHandleEvent(_ ppClient: inout OpaquePointer?) -> Bool {
    if ppClient == nil { return true }
    
    let arEvents: [es_event_type_t] = [ES_EVENT_TYPE_AUTH_EXEC,
                                       ES_EVENT_TYPE_AUTH_OPEN,
                                       ES_EVENT_TYPE_AUTH_RENAME,
                                       ES_EVENT_TYPE_AUTH_SIGNAL,
                                       ES_EVENT_TYPE_AUTH_UNLINK,
                                       ES_EVENT_TYPE_AUTH_TRUNCATE,
                                       ES_EVENT_TYPE_AUTH_LINK,
                                       ES_EVENT_TYPE_AUTH_CREATE,
                                       ES_EVENT_TYPE_AUTH_SETATTRLIST,
                                       ES_EVENT_TYPE_AUTH_SETEXTATTR,
                                       ES_EVENT_TYPE_AUTH_SETFLAGS,
                                       ES_EVENT_TYPE_AUTH_SETMODE,
                                       ES_EVENT_TYPE_AUTH_SETOWNER,
                                       ES_EVENT_TYPE_AUTH_DELETEEXTATTR,
                                       ES_EVENT_TYPE_AUTH_SETACL]
    
    if ES_RETURN_SUCCESS != es_unsubscribe(ppClient!, arEvents, UInt32(sizeof(arEvents)/sizeof(arEvents[0]))) {
        print("Failed to unsubscribe to events")
        return false
    }
    
    es_delete_client(ppClient)
    ppClient = nil
    
    g_bIsStartAuthEvent = false
    return true
}

func isStartAuthHandleEvent() -> Bool {
    return g_bIsStartAuthEvent
}

func printOpenFileItem() -> Bool {
    let fileManager = OpenFileManager.instance
    return fileManager.printOpenFileItem()
}
