//
//  ReceivePolicyManager.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/06/19.
//

import Foundation
import os

func setPolicy(_ pDictData: NSDictionary) -> Bool {
    let policyKind: NSNumber? = pDictData.object(forKey: EndPointNameSpace.KEY_SET_POLICY) as? NSNumber
    let policyItem: NSNumber? = pDictData.object(forKey: EndPointNameSpace.KEY_POLICY_ITEM) as? NSNumber
    
    let nPolicyKind = policyKind?.intValue
    
    if PolicyKinds.Last.rawValue <= nPolicyKind! { return false }
    
    return PolicyManager.instance.setPolicyItem(PolicyKinds(rawValue: nPolicyKind!)!, policyItem!.intValue)
}

func addPolicy(_ pDictData: NSDictionary) -> Bool {
    let policyKind: NSNumber? = pDictData.object(forKey: EndPointNameSpace.KEY_SET_POLICY) as? NSNumber
    let policyItem: NSString? = pDictData.object(forKey: EndPointNameSpace.KEY_POLICY_ITEM) as? NSString
    let fileFlag: NSNumber? = pDictData.object(forKey: EndPointNameSpace.KEY_FFLAG) as? NSNumber
    
    let nPolicyKind = policyKind?.intValue
    if PolicyKinds.Last.rawValue <= nPolicyKind! { return false }
    
    var nFileFlag = 0x01
    if fileFlag != nil {
        nFileFlag = fileFlag!.intValue
    }
    
    return PolicyManager.instance.addPolicyItem(PolicyKinds(rawValue: nPolicyKind!)!, policyItem! as String, nFileFlag: nFileFlag)
}

func delPolicy(_ pDictData: NSDictionary) -> Bool {
    let policyKind: NSNumber? = pDictData.object(forKey: EndPointNameSpace.KEY_SET_POLICY) as? NSNumber
    let policyItem: NSString? = pDictData.object(forKey: EndPointNameSpace.KEY_POLICY_ITEM) as? NSString
    
    let nPolicyKind = policyKind?.intValue
    if PolicyKinds.Last.rawValue <= nPolicyKind! { return false }
    
    return PolicyManager.instance.delPolicyItem(PolicyKinds(rawValue: nPolicyKind!)!, policyItem! as String)
}

func clearPolicy(_ pDictData: NSDictionary) -> Bool {
    let policyKind: NSNumber? = pDictData.object(forKey: EndPointNameSpace.KEY_SET_POLICY) as? NSNumber
    
    let nPolicyKind = policyKind?.intValue
    if PolicyKinds.Last.rawValue <= nPolicyKind! { return false }
    
    PolicyManager.instance.clearPolicyItem(PolicyKinds(rawValue: nPolicyKind!)!)
    return true
}
