//
//  PEEndPointSecurityDefine.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/05/19.
//

import Foundation

enum EndPointNameSpace {
    // 전송 데이터의 Dictionary Key
    static let KEY_PATH               = "path"
    static let KEY_FFLAG              = "fflag"
    static let KEY_STAT               = "stat"
    static let KEY_MODIFIED           = "modified"
    static let KEY_SRC_PATH           = "src_path"
    static let KEY_DST_PATH           = "dst_path"
    static let KEY_NEW_PATH           = "new_path"
    static let KEY_ATTR_LIST          = "attr_list"
    static let KEY_EXT_ATTR           = "ext_attr"
    static let KEY_FLASGS             = "flags"
    static let KEY_MODE               = "mode"
    static let KEY_GID                = "gid"
    static let KEY_UID                = "uid"
    static let KEY_PARENT_DIR         = "parent_dir"
    static let KEY_PID                = "pid"
    static let KEY_PROC_PATH          = "proc_path"
    static let KEY_PROC_SIGNED_ID     = "proc_signed_id"
    static let KEY_SIGNAL             = "signal"
    static let KEY_IS_CREATE          = "is_create"
    static let KEY_ODD_EVENT          = "odd_event"
    static let KEY_TARGET_PID         = "target_pid"
    static let KEY_TARGET_PROC_PATH   = "target_proc_path"
    static let KEY_DENY               = "deny"
    
    // 정책 관련
    static let KEY_SET_ODD_POLICY     = "set_odd_policy"
    static let KEY_SET_POLICY         = "set_policy"
    static let KEY_ADD_POLICY         = "add_policy"
    static let KEY_DEL_POLICY         = "del_policy"
    static let KEY_CLEAR_POLICY       = "clear_policy"
    static let KEY_POLICY_ITEM        = "policy_item"
    
    // Odd 정책
    static let ODD_POLICY_NONE                      = 0
    static let ODD_POLICY_READ_ONLY                 = 1
    static let ODD_POLICY_PRIVATE_DATA_RECORD_CHECK = 2
    
    // 공통 사용 상수형 문자열
    static let FINDER_PROC_PATH: [String]                   = ["/System/Library/CoreServices/Finder.app/Contents/MacOS/Finder"]
    static let DESKTOP_SERVICES_HELPER_PROC_PATH: [String]    = ["/System/Library/PrivateFrameworks/DesktopServicesPriv.framework/Versions/A/Resources/DesktopServicesHelper"]
    static let CP_PROC_PATH: [String]                         = ["/bin/cp"]
    static let MV_PROC_PATH: [String]                         = ["/bin/mv"]
    
    static let EMPTY: [String]                                = ["empty"]
}
