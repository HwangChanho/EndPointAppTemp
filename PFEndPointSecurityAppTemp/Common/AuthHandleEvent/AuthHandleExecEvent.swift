//
//  AuthHandleExecEvent.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/06/12.
//

import Foundation
import EndpointSecurity

enum AuthHandleExecEventNameSpace {
    static let BURN = "burn"
    static let IMAGE_FILE_EXTENSION_LIST: [String] = [".dmg", ".iso", ".cue", ".bin", ".toc"]
}

func findBurnFromProcArgument(_ vArgList: [String]) -> Bool {
    for strArgument in vArgList {
        if strArgument == AuthHandleExecEventNameSpace.BURN {
            return true
        }
    }
    
    return false
}

func findImgFileFromProcArgument(_ vArgList: [String]) -> String {
    for strArgument in vArgList {
        let path = URL(fileURLWithPath: strArgument)
        let strExtension = path.pathExtension
        
        if strExtension.isEmpty { continue }
        
        for (index, _) in AuthHandleExecEventNameSpace.IMAGE_FILE_EXTENSION_LIST.enumerated() {
            if strExtension == AuthHandleExecEventNameSpace.IMAGE_FILE_EXTENSION_LIST[index] {
                return strArgument
            }
        }
    }
    
    return ""
}

func isOddPolicyCheck(_ strProcPath: String) -> Bool {
    let policyManager = PFCPolicyManager.instance
    
    let nCurOddPolicy = policyManager.getPolicyItem(PolicyKinds.OddPolicy)
    if nCurOddPolicy != EndPointNameSpace.ODD_POLICY_NONE {
        if strProcPath == AuthNameSpace.DR_UTIL_PROCESS || strProcPath == AuthNameSpace.HDI_UTIL_PROCESS { return true }
    }
    
    return false
}

func authHandleExecWorker(_ client: OpaquePointer, _ message: UnsafePointer<es_message_t>) {
    let nPid = audit_token_to_pid(message.pointee.event.exec.target.pointee.audit_token)
    
    let strProcPath = String(cString: message.pointee.event.exec.target.pointee.executable.pointee.path.data)
    var strProcSignedId = ""
    if message.pointee.event.exec.target.pointee.signing_id.length > 0 {
        strProcSignedId = String(cString: message.pointee.event.exec.target.pointee.signing_id.data)
    }
    
    let pPolicyManager = PFCPolicyManager.instance
    
    // Process 차단 정책
    if pPolicyManager.isPolicyItem(.denyProcessPath, strProcPath) || pPolicyManager.isPolicyItem(.denyProcessSignedId, strProcSignedId) {
        var dictExecuteEventData = NSMutableDictionary()
        dictExecuteEventData.setObject(NSNumber(value: message.pointee.event.exec.target.pointee.original_ppid), forKey: KEY_PID as NSCopying)
        dictExecuteEventData.setObject(String(cString: message.pointee.process.pointee.executable.pointee.path.data), forKey: KEY_PROC_PATH as NSCopying)
        dictExecuteEventData.setObject(NSNumber(value: nPid), forKey: KEY_TARGET_PID as NSCopying)
        dictExecuteEventData.setObject(NSString(utf8String: strProcPath.cString(using: .utf8))) // KEY_TARGET_PROC_PATH
        dictExecuteEventData.setObject(NSNumber(value: true), forKey: KEY_DENY as NSCopying)
        dictExecuteEventData.setObject(EVENT_TYPE_NOTIFY_EXECUTE, forKey: KEY_EVENT_TYPE_AUTH as NSCopying)
        
        return authSendDataWithResult(client, message, dictExecuteEventData, .deny)
    }
    
    if isOddPolicyCheck(strProcPath) {
        var vArgList = [String]()
        if !JDCProcessUtil.getProcessArguments(nPid, &vArgList) {
            es_respond_auth_result(client, message, ES_AUTH_RESULT_ALLOW, false)
            return
        }
        
        if findBurnFromProcArgument(vArgList) {
            let nCurOddPolicy = PFCPolicyManager.getInstance().getPolicyItem(.oddPolicy)
            if nCurOddPolicy == ODD_POLICY_READ_ONLY {
                var dictBurnEventData = NSMutableDictionary()
                dictBurnEventData.setObject(NSNumber(value: nPid), forKey: KEY_PID as NSCopying)
                dictBurnEventData.setObject(NSString(utf8String: strProcPath.cString(using: .utf8)), forKey: KEY_PROC_PATH as NSCopying)
                dictBurnEventData.setObject(EVENT_TYPE_DENY_FILE_BURN, forKey: KEY_EVENT_TYPE_AUTH as NSCopying)
                
                return authSendDataWithResult(client, message, dictBurnEventData, .deny)
            }
        }
    }
    
    es_respond_auth_result()
}



