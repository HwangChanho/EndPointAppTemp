//
//  NotifyHandleEventDefine.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/05/19.
//

import Foundation

enum NotiNameSpace {
    static let KEY_EVENT_TYPE_NOTIFY                = "event_type_notify"
    static let KEY_ADD_NOTIFY_EVENT                 = "add_notify_event"
    static let KEY_DEL_NOTIFY_EVENT                 = "del_notify_event"
    
    static let KEY_ADD_NOTIFY_EVENT_FLAG            = "add_notify_event_flag"
    static let KEY_SUB_NOTIFY_EVENT_FLAG            = "sub_notify_event_flag"
    
    static let EVENT_TYPE_MONOTORING_MODIFIED_FILE  = "monitoring_modified_file"
    
    static let ES_EVENT_TYPE_NONE                   = 0
    static let ES_EVENT_TYPE_FLAG_NONE              = 0
}

enum EsEvent: Int {
    // The following events are available beginning in macOS 10.15
    case ES_EVENT_TYPE_AUTH_EXEC
    case ES_EVENT_TYPE_AUTH_OPEN
    case ES_EVENT_TYPE_AUTH_KEXTLOAD
    case ES_EVENT_TYPE_AUTH_MMAP
    case ES_EVENT_TYPE_AUTH_MPROTECT
    case ES_EVENT_TYPE_AUTH_MOUNT
    case ES_EVENT_TYPE_AUTH_RENAME
    case ES_EVENT_TYPE_AUTH_SIGNAL
    case ES_EVENT_TYPE_AUTH_UNLINK
    case ES_EVENT_TYPE_NOTIFY_EXEC
    case ES_EVENT_TYPE_NOTIFY_OPEN
    case ES_EVENT_TYPE_NOTIFY_FORK
    case ES_EVENT_TYPE_NOTIFY_CLOSE
    case ES_EVENT_TYPE_NOTIFY_CREATE
    case ES_EVENT_TYPE_NOTIFY_EXCHANGEDATA
    case ES_EVENT_TYPE_NOTIFY_EXIT
    case ES_EVENT_TYPE_NOTIFY_GET_TASK
    case ES_EVENT_TYPE_NOTIFY_KEXTLOAD
    case ES_EVENT_TYPE_NOTIFY_KEXTUNLOAD
    case ES_EVENT_TYPE_NOTIFY_LINK
    case ES_EVENT_TYPE_NOTIFY_MMAP
    case ES_EVENT_TYPE_NOTIFY_MPROTECT
    case ES_EVENT_TYPE_NOTIFY_MOUNT
    case ES_EVENT_TYPE_NOTIFY_UNMOUNT
    case ES_EVENT_TYPE_NOTIFY_IOKIT_OPEN
    case ES_EVENT_TYPE_NOTIFY_RENAME
    case ES_EVENT_TYPE_NOTIFY_SETATTRLIST
    case ES_EVENT_TYPE_NOTIFY_SETEXTATTR
    case ES_EVENT_TYPE_NOTIFY_SETFLAGS
    case ES_EVENT_TYPE_NOTIFY_SETMODE
    case ES_EVENT_TYPE_NOTIFY_SETOWNER
    case ES_EVENT_TYPE_NOTIFY_SIGNAL
    case ES_EVENT_TYPE_NOTIFY_UNLINK
    case ES_EVENT_TYPE_NOTIFY_WRITE
    case ES_EVENT_TYPE_AUTH_FILE_PROVIDER_MATERIALIZE
    case ES_EVENT_TYPE_NOTIFY_FILE_PROVIDER_MATERIALIZE
    case ES_EVENT_TYPE_AUTH_FILE_PROVIDER_UPDATE
    case ES_EVENT_TYPE_NOTIFY_FILE_PROVIDER_UPDATE
    case ES_EVENT_TYPE_AUTH_READLINK
    case ES_EVENT_TYPE_NOTIFY_READLINK
    case ES_EVENT_TYPE_AUTH_TRUNCATE
    case ES_EVENT_TYPE_NOTIFY_TRUNCATE
    case ES_EVENT_TYPE_AUTH_LINK
    case ES_EVENT_TYPE_NOTIFY_LOOKUP
    case ES_EVENT_TYPE_AUTH_CREATE
    case ES_EVENT_TYPE_AUTH_SETATTRLIST
    case ES_EVENT_TYPE_AUTH_SETEXTATTR
    case ES_EVENT_TYPE_AUTH_SETFLAGS
    case ES_EVENT_TYPE_AUTH_SETMODE
    case ES_EVENT_TYPE_AUTH_SETOWNER
    // The following events are available beginning in macOS 10.15.1
    case ES_EVENT_TYPE_AUTH_CHDIR
    case ES_EVENT_TYPE_NOTIFY_CHDIR
    case ES_EVENT_TYPE_AUTH_GETATTRLIST
    case ES_EVENT_TYPE_NOTIFY_GETATTRLIST
    case ES_EVENT_TYPE_NOTIFY_STAT
    case ES_EVENT_TYPE_NOTIFY_ACCESS
    case ES_EVENT_TYPE_AUTH_CHROOT
    case ES_EVENT_TYPE_NOTIFY_CHROOT
    case ES_EVENT_TYPE_AUTH_UTIMES
    case ES_EVENT_TYPE_NOTIFY_UTIMES
    case ES_EVENT_TYPE_AUTH_CLONE
    case ES_EVENT_TYPE_NOTIFY_CLONE
    case ES_EVENT_TYPE_NOTIFY_FCNTL
    case ES_EVENT_TYPE_AUTH_GETEXTATTR
    case ES_EVENT_TYPE_NOTIFY_GETEXTATTR
    case ES_EVENT_TYPE_AUTH_LISTEXTATTR
    case ES_EVENT_TYPE_NOTIFY_LISTEXTATTR
    case ES_EVENT_TYPE_AUTH_READDIR
    case ES_EVENT_TYPE_NOTIFY_READDIR
    case ES_EVENT_TYPE_AUTH_DELETEEXTATTR
    case ES_EVENT_TYPE_NOTIFY_DELETEEXTATTR
    case ES_EVENT_TYPE_AUTH_FSGETPATH
    case ES_EVENT_TYPE_NOTIFY_FSGETPATH
    case ES_EVENT_TYPE_NOTIFY_DUP
    case ES_EVENT_TYPE_AUTH_SETTIME
    case ES_EVENT_TYPE_NOTIFY_SETTIME
    case ES_EVENT_TYPE_NOTIFY_UIPC_BIND
    case ES_EVENT_TYPE_AUTH_UIPC_BIND
    case ES_EVENT_TYPE_NOTIFY_UIPC_CONNECT
    case ES_EVENT_TYPE_AUTH_UIPC_CONNECT
    case ES_EVENT_TYPE_AUTH_EXCHANGEDATA
    case ES_EVENT_TYPE_AUTH_SETACL
    case ES_EVENT_TYPE_NOTIFY_SETACL
    // The following events are available beginning in macOS 10.15.4
    case ES_EVENT_TYPE_NOTIFY_PTY_GRANT
    case ES_EVENT_TYPE_NOTIFY_PTY_CLOSE
    case ES_EVENT_TYPE_AUTH_PROC_CHECK
    case ES_EVENT_TYPE_NOTIFY_PROC_CHECK
    case ES_EVENT_TYPE_AUTH_GET_TASK
    // The following events are available beginning in macOS 11.0
    case ES_EVENT_TYPE_AUTH_SEARCHFS
    case ES_EVENT_TYPE_NOTIFY_SEARCHFS
    case ES_EVENT_TYPE_AUTH_FCNTL
    case ES_EVENT_TYPE_AUTH_IOKIT_OPEN
    case ES_EVENT_TYPE_AUTH_PROC_SUSPEND_RESUME
    case ES_EVENT_TYPE_NOTIFY_PROC_SUSPEND_RESUME
    case ES_EVENT_TYPE_NOTIFY_CS_INVALIDATED
    case ES_EVENT_TYPE_NOTIFY_GET_TASK_NAME
    case ES_EVENT_TYPE_NOTIFY_TRACE
    case ES_EVENT_TYPE_NOTIFY_REMOTE_THREAD_CREATE
    case ES_EVENT_TYPE_AUTH_REMOUNT
    case ES_EVENT_TYPE_NOTIFY_REMOUNT
    // The following events are available beginning in macOS 11.3
    case ES_EVENT_TYPE_AUTH_GET_TASK_READ
    case ES_EVENT_TYPE_NOTIFY_GET_TASK_READ
    case ES_EVENT_TYPE_NOTIFY_GET_TASK_INSPECT
    // The following events are available beginning in macOS 12.0
    case ES_EVENT_TYPE_NOTIFY_SETUID
    case ES_EVENT_TYPE_NOTIFY_SETGID
    case ES_EVENT_TYPE_NOTIFY_SETEUID
    case ES_EVENT_TYPE_NOTIFY_SETEGID
    case ES_EVENT_TYPE_NOTIFY_SETREUID
    case ES_EVENT_TYPE_NOTIFY_SETREGID
    case ES_EVENT_TYPE_AUTH_COPYFILE
    case ES_EVENT_TYPE_NOTIFY_COPYFILE
    // The following events are available beginning in macOS 13.0
    case ES_EVENT_TYPE_NOTIFY_AUTHENTICATION
    case ES_EVENT_TYPE_NOTIFY_XP_MALWARE_DETECTED
    case ES_EVENT_TYPE_NOTIFY_XP_MALWARE_REMEDIATED
    case ES_EVENT_TYPE_NOTIFY_LW_SESSION_LOGIN
    case ES_EVENT_TYPE_NOTIFY_LW_SESSION_LOGOUT
    case ES_EVENT_TYPE_NOTIFY_LW_SESSION_LOCK
    case ES_EVENT_TYPE_NOTIFY_LW_SESSION_UNLOCK
    case ES_EVENT_TYPE_NOTIFY_SCREENSHARING_ATTACH
    case ES_EVENT_TYPE_NOTIFY_SCREENSHARING_DETACH
    case ES_EVENT_TYPE_NOTIFY_OPENSSH_LOGIN
    case ES_EVENT_TYPE_NOTIFY_OPENSSH_LOGOUT
    case ES_EVENT_TYPE_NOTIFY_LOGIN_LOGIN
    case ES_EVENT_TYPE_NOTIFY_LOGIN_LOGOUT
    case ES_EVENT_TYPE_NOTIFY_BTM_LAUNCH_ITEM_ADD
    case ES_EVENT_TYPE_NOTIFY_BTM_LAUNCH_ITEM_REMOVE
    // ES_EVENT_TYPE_LAST is not a valid event type but a convenience
    // value for operating on the range of defined event types.
    // This value may change between releases and was available
    // beginning in macOS 10.15
    case ES_EVENT_TYPE_LAST
}

let ES_EVENT_TYPE_NOTIFY_DICT: NSDictionary = ["ES_EVENT_TYPE_NONE" : NSNumber(integerLiteral:                                                                      NotiNameSpace.ES_EVENT_TYPE_NONE),
                                               "ES_EVENT_TYPE_NOTIFY_EXEC" : NSNumber(integerLiteral: EsEvent.ES_EVENT_TYPE_NOTIFY_EXEC.rawValue),
                                               "ES_EVENT_TYPE_NOTIFY_OPEN" : NSNumber(integerLiteral: EsEvent.ES_EVENT_TYPE_NOTIFY_OPEN.rawValue),
                                               "ES_EVENT_TYPE_NOTIFY_CLOSE" : NSNumber(integerLiteral: EsEvent.ES_EVENT_TYPE_NOTIFY_CLOSE.rawValue),
                                               "ES_EVENT_TYPE_NOTIFY_CREATE" : NSNumber(integerLiteral: EsEvent.ES_EVENT_TYPE_NOTIFY_CREATE.rawValue),
                                               "ES_EVENT_TYPE_NOTIFY_LINK" : NSNumber(integerLiteral: EsEvent.ES_EVENT_TYPE_NOTIFY_LINK.rawValue),
                                               "ES_EVENT_TYPE_NOTIFY_MMAP" : NSNumber(integerLiteral: EsEvent.ES_EVENT_TYPE_NOTIFY_MMAP.rawValue),
                                               "ES_EVENT_TYPE_NOTIFY_RENAME" : NSNumber(integerLiteral: EsEvent.ES_EVENT_TYPE_NOTIFY_RENAME.rawValue),
                                               "ES_EVENT_TYPE_NOTIFY_SETATTRLIST" : NSNumber(integerLiteral: EsEvent.ES_EVENT_TYPE_NOTIFY_SETATTRLIST.rawValue),
                                               "ES_EVENT_TYPE_NOTIFY_SETEXTATTR" : NSNumber(integerLiteral: EsEvent.ES_EVENT_TYPE_NOTIFY_SETEXTATTR.rawValue),
                                               "ES_EVENT_TYPE_NOTIFY_SETFLAGS" : NSNumber(integerLiteral: EsEvent.ES_EVENT_TYPE_NOTIFY_SETFLAGS.rawValue),
                                               "ES_EVENT_TYPE_NOTIFY_SETMODE" : NSNumber(integerLiteral: EsEvent.ES_EVENT_TYPE_NOTIFY_SETMODE.rawValue),
                                               "ES_EVENT_TYPE_NOTIFY_SETOWNER" : NSNumber(integerLiteral: EsEvent.ES_EVENT_TYPE_NOTIFY_SETOWNER.rawValue),
                                               "ES_EVENT_TYPE_NOTIFY_UNLINK" : NSNumber(integerLiteral: EsEvent.ES_EVENT_TYPE_NOTIFY_UNLINK.rawValue),
                                               "ES_EVENT_TYPE_NOTIFY_WRITE" : NSNumber(integerLiteral: EsEvent.ES_EVENT_TYPE_NOTIFY_WRITE.rawValue),
                                               "ES_EVENT_TYPE_NOTIFY_READLINK" : NSNumber(integerLiteral: EsEvent.ES_EVENT_TYPE_NOTIFY_READLINK.rawValue),
                                               "ES_EVENT_TYPE_NOTIFY_TRUNCATE" : NSNumber(integerLiteral: EsEvent.ES_EVENT_TYPE_NOTIFY_TRUNCATE.rawValue)
]
