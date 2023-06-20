//
//  PEEndPointSecurityDefine.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/05/19.
//

import Foundation

enum NotifyEventFlag: Int {
    case Exec                 = 0x00000001
    case Open                 = 0x00000002
    case Close                = 0x00000004
    case Create               = 0x00000008
    case Link                 = 0x00000010
    case MMap                 = 0x00000020
    case Rename               = 0x00000040
    case SetAttrList          = 0x00000080
    case SetExtAttr           = 0x00000100
    case SetFlags             = 0x00000200
    case SetMode              = 0x00000400
    case SetOwner             = 0x00000800
    case UnLink               = 0x00001000
    case Write                = 0x00002000
    case ReadLink             = 0x00004000
    case Truncate             = 0x00008000
    
    case ExecWithOther        = 0x00010000
    case OpenWithOther        = 0x00020000
    case CloseWithOther       = 0x00040000
    case CreateWithOther      = 0x00080000
    case LinkWithOther        = 0x00100000
    case MMapWithOther        = 0x00200000
    case RenameWithOther      = 0x00400000
    case SetAttrListWithOther = 0x00800000
    case SetExtAttrWithOther  = 0x01000000
    case SetFlagsWithOther    = 0x02000000
    case SetModeWithOther     = 0x04000000
    case SetOwnerWithOther    = 0x08000000
    case UnLinkWithOther      = 0x10000000
    case WriteWithOther       = 0x20000000
    case ReadLinkWithOther    = 0x40000000
    case TruncateWithOther    = 0x80000000
}

enum PolicyKinds: Int {
    case OddPolicy = 0                              // ODD 정책
    case DenyProcessPath                        // 프로세스 경로로 프로세스 실행 차단
    case DenyProcessSignedId                    // 프로세스 서명 ID로 프로세스 실행 차단
    case CheckFileReadProcessPath               // 프로세스 경로의 해당 되는 프로세스의 파일 읽기를 체크한다
    case CheckFileReadProcessSignedId           // 프로세스 서명 ID의 해당 되는 프로세스의 파일 읽기를 체크한다
    case ExceptionPath                          // 예외 경로
    case MuteProcessPath                        // 음소거 프로세스 경로
    case ExternalStorageVolumePath              // 외부 저장소 경로
    case DenyDirecotryWithUsers                 // 사용자 경로 하위의 차단 디렉토리
    case DenyCreateFileInDirectory              // 지정된 경로 하위의 파일 생성 차단
    case ProtectionPath                         // 경로 보호 ( 디렉토리 하위의 경로 모두 보호 )
    case ProtectionFilePath                     // 파일 보호
    case ProtectionProcessPath                  // 프로세스 경로로 프로세스 보호
    case ProtectionProcessSignedId              // 프로세스 서명 ID 로 프로세스 보호
    case ProtectionAcceptProcessPath            // 경로 보호, 파일 보호의 접근 할 수 있는 프로세스 경로
    case ProtectionAcceptProcessSignedId        // 경로 보호, 파일 보호의 접근 할 수 있는 프로세스 서명 ID
    case NotifyEventFlag                        // Notify 이벤트를 Auth 이벤트에서도 사용 할 경우의 대한 Flag
    case MonitoringModifiedFilePath             // 파일의 변경 여부를 감시 한다.
    case Last
}

enum EndPointNameSpace: CaseIterable {
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
    static let FINDER_PROC_PATH: String                   = "/System/Library/CoreServices/Finder.app/Contents/MacOS/Finder"
    static let DESKTOP_SERVICES_HELPER_PROC_PATH: String    = "/System/Library/PrivateFrameworks/DesktopServicesPriv.framework/Versions/A/Resources/DesktopServicesHelper"
    static let CP_PROC_PATH: String                         = "/bin/cp"
    static let MV_PROC_PATH: String                         = "/bin/mv"
    
    static let EMPTY: String                                = "empty"
}
