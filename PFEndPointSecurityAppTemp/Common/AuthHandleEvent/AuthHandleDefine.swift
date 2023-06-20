//
//  AuthHandleDefine.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/05/19.
//

import Foundation

enum AuthNameSpace {
    static let KEY_EVENT_TYPE_AUTH                = "event_type_auth"
    static let KEY_START_AUTH_EVENT               = "start_auth_event"
    static let KEY_STOP_AUTH_EVENT                = "stop_auth_event"
    static let KEY_PRINT_OPEN_FILE_ITEM           = "print_open_file_item"
    
    static let EVENT_TYPE_PRINT_OPEN_FILE_ITEM    = "print_open_file_item"

    static let EVENT_TYPE_IS_ALLOW_FILE_COPY      = "is_allow_file_copy"
    static let EVENT_TYPE_ALLOW_FILE_COPY         = "allow_file_copy"

    static let EVENT_TYPE_IS_ALLOW_FILE_OPEN      = "is_allow_file_open"           // 파일 오픈 확인

    static let EVENT_TYPE_IS_ALLOW_FILE_BURN      = "is_allow_file_burn"
    static let EVENT_TYPE_DENY_FILE_BURN          = "deny_file_burn"

    // notify 라고 붙은 이벤트는 App 에서 허용, 차단을 할 수 없음, 순수하게 알림 용도
    static let EVENT_TYPE_NOTIFY_OPEN             = "notify_open"
    static let EVENT_TYPE_NOTIFY_WRITE            = "notify_write"
    static let EVENT_TYPE_NOTIFY_RENAME           = "notify_rename"
    static let EVENT_TYPE_NOTIFY_UNLINK           = "notify_unlink"
    static let EVENT_TYPE_NOTIFY_EXECUTE          = "notify_execute"
    static let EVENT_TYPE_NOTIFY_TRUNCATE         = "notify_truncate"
    static let EVENT_TYPE_NOTIFY_LINK             = "notify_link"
    static let EVENT_TYPE_NOTIFY_CREATE           = "notify_create"
    static let EVENT_TYPE_NOTIFY_SET_ATTR_LIST    = "notify_set_attr_list"
    static let EVENT_TYPE_NOTIFY_SET_FLAGS        = "notify_set_flags"
    static let EVENT_TYPE_NOTIFY_SET_MODE         = "notify_set_mode"
    static let EVENT_TYPE_NOTIFY_SET_OWNER        = "notify_set_owner"
    static let EVENT_TYPE_NOTIFY_SET_EXT_ATTR     = "notify_set_ext_attr"
    static let EVENT_TYPE_NOTIFY_DEL_EXT_ATTR     = "notify_del_ext_attr"
    static let EVENT_TYPE_NOTIFY_SET_ACL          = "notify_set_acl"
    static let EVENT_TYPE_NOTIFY_SIGNAL           = "notify_signal"

    static let DISC_RECORDING_FRAMEWORK_PATH: String      = "/System/Library/Frameworks/DiscRecording.framework"
    static let APPLE_BURN_FOLDER_EXT: String              = ".fpbf"

    static let DR_UTIL_PROCESS: String                    = "/usr/bin/drutil"
    static let HDI_UTIL_PROCESS: String                   = "/usr/bin/hdiutil"
}
