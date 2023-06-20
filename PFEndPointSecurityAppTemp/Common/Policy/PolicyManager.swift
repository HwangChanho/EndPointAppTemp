//
//  PFCPolicyManager.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/06/11.
//

import Foundation
import os

enum UserNameSpace {
    static let USERS_DIR = "/Users/"
    static let APPLICATIONS_DIR = "/Applications"
    static let APPLICATIONS_DIR_LEN = 13
}

class PolicyManager: NSObject {
    static let instance = PolicyManager()
    private override init() {}
    
    private struct PolicyItemData: Equatable {
        var nFileFlag = 0
        var strPolicyItem: String?
    }
    
    private struct PolicyItems {
        var nPolicyItem = 0
        var mutexPolicy: pthread_mutex_t?
        var vPolicyItemData: [PolicyItemData]?
    }
    
    private var stPolicyItems: [PolicyItems] = []
    
    func clear() {
        for i in 0..<EndPointNameSpace.allCases.count {
            stPolicyItems[i].nPolicyItem = 0
            clearVector(&stPolicyItems[i].mutexPolicy!, &stPolicyItems[i].vPolicyItemData!)
        }
    }
    
    func getPolicyItem(_ nPolicy: PolicyKinds) -> Int {
        return stPolicyItems[nPolicy.rawValue].nPolicyItem
    }
    
    func setPolicyItem(_ nPolicy: PolicyKinds, _ nPolicyItem: Int) -> Bool {
        stPolicyItems[nPolicy.rawValue].nPolicyItem = nPolicyItem
        return true
    }
    
    func addPolicyItem(_ nPolicy: PolicyKinds, _ nPolicyItem: Int) -> Bool {
        if PolicyKinds.NotifyEventFlag == nPolicy {
            stPolicyItems[nPolicy.rawValue].nPolicyItem = stPolicyItems[nPolicy.rawValue].nPolicyItem | nPolicyItem
            return true
        }
        
        return false
    }
    
    func subPolicyItem(_ nPolicy: PolicyKinds, _ nPolicyItem: Int) -> Bool {
        if stPolicyItems[nPolicy.rawValue].nPolicyItem < nPolicyItem {
            return false
        }
        
        if PolicyKinds.NotifyEventFlag == nPolicy {
            stPolicyItems[nPolicy.rawValue].nPolicyItem = stPolicyItems[nPolicy.rawValue].nPolicyItem ^ nPolicyItem
            return true
        }
        
        stPolicyItems[nPolicy.rawValue].nPolicyItem = stPolicyItems[nPolicy.rawValue].nPolicyItem ^ nPolicyItem
        return true
    }
    
    func addPolicyItem(_ nPolicy: PolicyKinds, _ strPolicyItem: String, nFileFlag: Int) -> Bool {
        return addPolicyItemData(strPolicyItem, nFileFlag, &stPolicyItems[nPolicy.rawValue].mutexPolicy!, vVector: &(stPolicyItems[nPolicy.rawValue].vPolicyItemData)!)
    }
    
    private func addPolicyItemData(_ strItem: String, _ nFileFlag: Int, _ mutexVector: inout pthread_mutex_t, vVector: inout [PolicyItemData]) -> Bool {
        if strItem.isEmpty == true {
            return false
        }
        
        pthread_mutex_lock(&mutexVector)
        for stItem in vVector {
            if stItem.strPolicyItem == strItem {
                pthread_mutex_unlock(&mutexVector)
                return true
            }
        }
        
        var stPolicyItemData = PolicyItemData(nFileFlag: nFileFlag, strPolicyItem: strItem)
        
        vVector.append(stPolicyItemData)
        pthread_mutex_unlock(&mutexVector)
        
        return true
    }
    
    func delPolicyItem(_ nPolicy: PolicyKinds, _ strPolicyItem: String) -> Bool {
        return delPolicyItemData(strPolicyItem, &stPolicyItems[nPolicy.rawValue].mutexPolicy!, vVector: &(stPolicyItems[nPolicy.rawValue].vPolicyItemData)!)
    }
    
    func getPolicyItemFileFlag(_ nPolicy: PolicyKinds, _ strPolicyItem: String) -> Int {
        return getPolicyItemFileFlag(strPolicyItem, &stPolicyItems[nPolicy.rawValue].mutexPolicy!, stPolicyItems[nPolicy.rawValue].vPolicyItemData!)
    }
    
    private func getPolicyItemFileFlag(_ strItem: String, _ mutexVector: inout pthread_mutex_t, _ vVector: [PolicyItemData]) -> Int {
        if vVector.isEmpty || strItem.isEmpty {
            return 0x01
        }
        
        pthread_mutex_lock(&mutexVector)
        
        for stItemData in vVector {
            if strItem == stItemData.strPolicyItem {
                pthread_mutex_unlock(&mutexVector)
                return stItemData.nFileFlag
            }
        }
        
        pthread_mutex_unlock(&mutexVector)
        return 0x01
    }
    
    func clearPolicyItem(_ nPolicy: PolicyKinds) {
        stPolicyItems[nPolicy.rawValue].nPolicyItem = 0
        clearVector(&stPolicyItems[nPolicy.rawValue].mutexPolicy!, &stPolicyItems[nPolicy.rawValue].vPolicyItemData!)
    }
    
    func isPolicyItem(_ nPolicy: PolicyKinds, _ strPolicyItem: String) -> Bool {
        if PolicyKinds.DenyProcessSignedId == nPolicy ||
            PolicyKinds.CheckFileReadProcessSignedId == nPolicy ||
            PolicyKinds.MuteProcessPath == nPolicy ||
            PolicyKinds.ProtectionFilePath == nPolicy ||
            PolicyKinds.ProtectionProcessSignedId == nPolicy ||
            PolicyKinds.ProtectionAcceptProcessSignedId == nPolicy ||
            PolicyKinds.MonitoringModifiedFilePath == nPolicy {
            return compareStringItemData(strPolicyItem, &stPolicyItems[nPolicy.rawValue].mutexPolicy!, vVector: &(stPolicyItems[nPolicy.rawValue].vPolicyItemData)!)
        }
        
        if PolicyKinds.DenyProcessPath == nPolicy ||
            PolicyKinds.CheckFileReadProcessPath == nPolicy ||
            PolicyKinds.ProtectionProcessPath == nPolicy ||
            PolicyKinds.ProtectionAcceptProcessPath == nPolicy {
            return findProcessPathStringItemData(strPolicyItem, &stPolicyItems[nPolicy.rawValue].mutexPolicy!, vVector: &(stPolicyItems[nPolicy.rawValue].vPolicyItemData)!)
        }
        
        if PolicyKinds.DenyProcessPath == nPolicy ||
            PolicyKinds.CheckFileReadProcessPath == nPolicy ||
            PolicyKinds.ProtectionProcessPath == nPolicy {
            return findPathStringItemData(strPolicyItem, &stPolicyItems[nPolicy.rawValue].mutexPolicy!, vVector: &(stPolicyItems[nPolicy.rawValue].vPolicyItemData)!)
        }
        
        if PolicyKinds.DenyDirecotryWithUsers == nPolicy {
            return isDenyDirecotryWithUsers(strPolicyItem)
        }
        
        if PolicyKinds.DenyCreateFileInDirectory == nPolicy {
            return isDenyCreateFileInDirectory(strPolicyItem)
        }
        
        return false
    }
    
    private func isDenyCreateFileInDirectory(_ _strDirPath: String) -> Bool {
        var pvDenyCreateFileInDirectory: [PolicyItemData] = stPolicyItems[PolicyKinds.DenyCreateFileInDirectory.rawValue].vPolicyItemData!
        var pmutexDenyCreateFileInDirectory: pthread_mutex_t = stPolicyItems[PolicyKinds.DenyCreateFileInDirectory.rawValue].mutexPolicy!
        
        if pvDenyCreateFileInDirectory.isEmpty || _strDirPath.isEmpty { return false }
        
        pthread_mutex_lock(&pmutexDenyCreateFileInDirectory)
        
        for stDenyCreateFileInDirectory in pvDenyCreateFileInDirectory {
            if _strDirPath.hasPrefix(stDenyCreateFileInDirectory.strPolicyItem!) { continue }
            
            var strFileName: String = _strDirPath
            strFileName = strFileName.replacingOccurrences(of: stDenyCreateFileInDirectory.strPolicyItem!, with: "")
            if !strFileName.contains("/") {
                pthread_mutex_unlock(&pmutexDenyCreateFileInDirectory)
                return true
            }
        }
        
        pthread_mutex_unlock(&pmutexDenyCreateFileInDirectory)
        return false
    }
    
    private func isDenyDirecotryWithUsers(_ _strDirPath: String) -> Bool {
        let pathManager = PathUtil.shared
        
        var pvDenyDirectoryWithUsers: [PolicyItemData] = stPolicyItems[PolicyKinds.DenyDirecotryWithUsers.rawValue].vPolicyItemData!
        var pmutexDenyDirectoryWithUsers: pthread_mutex_t = stPolicyItems[PolicyKinds.DenyDirecotryWithUsers.rawValue].mutexPolicy!
        
        if pvDenyDirectoryWithUsers.isEmpty || _strDirPath.isEmpty { return false }
        if _strDirPath.range(of: UserNameSpace.USERS_DIR)?.lowerBound.utf16Offset(in: _strDirPath) != 0 { return false }
        
        pthread_mutex_lock(&pmutexDenyDirectoryWithUsers)
        
        for stDenyDirectoryWithUsers in pvDenyDirectoryWithUsers {
            var strDirPath = pathManager.delRootDirectory(_strDirPath)
            strDirPath = pathManager.delRootDirectory(strDirPath)
            
            if strDirPath.hasPrefix(stDenyDirectoryWithUsers.strPolicyItem!) {
                pthread_mutex_unlock(&pmutexDenyDirectoryWithUsers)
                return true
            }
        }
        
        pthread_mutex_unlock(&pmutexDenyDirectoryWithUsers)
        return false
    }
    
    private func findPathStringItemData(_ strItem: String, _ mutexVector: inout pthread_mutex_t, vVector: inout [PolicyItemData]) -> Bool {
        if vVector.isEmpty || strItem.isEmpty { return false }
        
        pthread_mutex_lock(&mutexVector)
        for stItemData in vVector {
            if strItem.hasPrefix(stItemData.strPolicyItem!) {
                if strItem.count == stItemData.strPolicyItem?.count || strItem[strItem.index(strItem.startIndex, offsetBy: stItemData.strPolicyItem!.count)] == "/" {
                    pthread_mutex_unlock(&mutexVector)
                    return true
                }
            }
        }
        
        pthread_mutex_unlock(&mutexVector)
        return false
    }
    
    private func findProcessPathStringItemData(_ strItem: String, _ mutexVector: inout pthread_mutex_t, vVector: inout [PolicyItemData]) -> Bool {
        if vVector.isEmpty || strItem.isEmpty { return false }
        
        var strItemSubPath: String = strItem
        let nFind = strItem.range(of: UserNameSpace.APPLICATIONS_DIR)?.lowerBound.utf16Offset(in: strItem) ?? NSNotFound
        
        if nFind == 0 {
            strItemSubPath = String(strItem.dropFirst(UserNameSpace.APPLICATIONS_DIR_LEN).suffix(strItem.count - UserNameSpace.APPLICATIONS_DIR_LEN))
        }
        
        pthread_mutex_lock(&mutexVector)
        for stItemData in vVector {
            var strPolicyItemSubPath: String = stItemData.strPolicyItem!
            if nFind == 0 && ((strPolicyItemSubPath.range(of: UserNameSpace.APPLICATIONS_DIR)?.lowerBound.utf16Offset(in: strPolicyItemSubPath) ?? NSNotFound) != 0) {
                strPolicyItemSubPath = String(strPolicyItemSubPath.dropFirst(UserNameSpace.APPLICATIONS_DIR_LEN).suffix(strPolicyItemSubPath.count - UserNameSpace.APPLICATIONS_DIR_LEN))
            }
            
            if ((strItemSubPath.range(of: UserNameSpace.APPLICATIONS_DIR)?.lowerBound.utf16Offset(in: strPolicyItemSubPath) ?? NSNotFound) == 0) {
                pthread_mutex_unlock(&mutexVector)
                return true
            }
        }
        
        pthread_mutex_unlock(&mutexVector)
        return false
    }
    
    private func delPolicyItemData(_ strItem: String, _ mutexVector: inout pthread_mutex_t, vVector: inout [PolicyItemData]) -> Bool {
        if strItem.isEmpty {
            return false
        }
        
        if vVector.isEmpty {
            return true
        }
        
        pthread_mutex_lock(&mutexVector)
        
        var iterator: Array<PolicyItemData>.Iterator = vVector.makeIterator()
        while let item = iterator.next() {
            if item.strPolicyItem!.compare(strItem) == .orderedSame {
                if let index = vVector.firstIndex(where: { $0 == item }) {
                    vVector.remove(at: index)
                    break
                }
            }
        }
        
        pthread_mutex_unlock(&mutexVector)
        
        return true
    }
    
    private func compareStringItemData(_ strItem: String, _ mutexVector: inout pthread_mutex_t, vVector: inout [PolicyItemData]) -> Bool {
        if vVector.isEmpty || strItem.isEmpty { return false }
        
        pthread_mutex_lock(&mutexVector)
        for stItemData in vVector {
            if strItem == stItemData.strPolicyItem {
                pthread_mutex_unlock(&mutexVector)
                return true
            }
        }
        pthread_mutex_unlock(&mutexVector)
        
        return false
    }
    
    private func clearVector(_ mutextVector: inout pthread_mutex_t, _ vVector: inout [PolicyItemData]) {
        pthread_mutex_lock(&mutextVector)
        vVector = []
        pthread_mutex_unlock(&mutextVector)
    }
}
