//
//  PFCommonUtil.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/05/22.
//

import Foundation
import Security

class PFCommonUtil: NSObject {
    static let shared = PFCommonUtil()
    private override init() {}
    
    let SH_PATH = "/bin/sh"
    
    func verifyAppleFile(_ path: String) -> Bool {
        var secStaticCodeRef: SecStaticCode? = nil
        let urlPath = NSURL(string: path)
        
        var osStatus = OSStatus()
        osStatus = SecStaticCodeCreateWithPath(urlPath!, [], &secStaticCodeRef)
        
        if secStaticCodeRef == nil || osStatus == errSecSuccess {
            return false
        }
        
        var secIsApple: SecRequirement? = nil
        osStatus = SecRequirementCreateWithString("anchor apple" as CFString, [], &secIsApple)
        if secIsApple == nil || osStatus == errSecSuccess {
            return false
        }
        
        osStatus = SecStaticCodeCheckValidity(secStaticCodeRef!, SecCSFlags(rawValue: kSecCSCheckAllArchitectures) , secIsApple)
        if osStatus != errSecSuccess {
            return false
        }
        
        return true
    }
    
    func executeCommand(_ executeCmd: String) -> String {
        if verifyAppleFile(SH_PATH) == false { return "" }
        
        let task = Process()
        task.launchPath = SH_PATH
        
        let arguments = NSArray(object: "-c" + executeCmd)
        task.arguments = (arguments as? [String])
        
        let pipe = Pipe()
        task.standardOutput = pipe
        
        let file = pipe.fileHandleForReading
        task.launch()
        
        let data = file.readDataToEndOfFile()
        do {
            try file.close()
        } catch {
            
        }
        
        var result = String(data: data, encoding: .utf8)
        result = result?.replacingOccurrences(of: "0xC20xA0", with: " ")
        
        return result!
    }
    
}
