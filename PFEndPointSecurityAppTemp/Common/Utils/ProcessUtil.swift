//
//  ProcessUtil.swift
//  PFEndPointSecurityAppTemp
//
//  Created by AlexHwang on 2023/05/21.
//

import Foundation
import libkern
import AppKit

let KERN_MAX_PROC = "kern.maxproc"

class ProcessUtil: NSObject {
    static let shared = ProcessUtil()
    private override init() {}
    
    func killAllProcess(_ strProcess: String) -> Bool {
        var vAllPidList: [pid_t] = []
        getAllPidList(&vAllPidList)
        
        var bIsPath = false
        if strProcess.first == "/" {
            bIsPath = true
        }
        
        for nPid in vAllPidList {
            let strProcPath = getProcessPath(for: nPid)
            
            if bIsPath == true {
                if strProcPath?.compare(strProcess) == .orderedSame {
                    if kill(nPid, SIGKILL) != 0 {
                        return false
                    }
                }
            } else {
                let strProcName = getFileName(strProcPath!)
                if strProcName.compare(strProcess) == .orderedSame  {
                    if kill(nPid, SIGKILL) != 0 {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    func getAllPidList(_ vAllPidList: inout [pid_t]) {
        vAllPidList.removeAll()
        
        var nMaxProc = 0
        var size = sizeof(nMaxProc)
        sysctlbyname(KERN_MAX_PROC, &nMaxProc, &size, nil, 0)
        
        vAllPidList = getAllProcessIDs()
    }
    
    func getProcessList() -> [kinfo_proc]? {
        var name : [Int32] = [ CTL_KERN, KERN_PROC, KERN_PROC_ALL ]
        var length = size_t()
        
        sysctl(&name, UInt32(name.count), nil, &length, nil, 0)
        
        let count = length / MemoryLayout<kinfo_proc>.size
        var procList = Array(repeating: kinfo_proc(), count: count)
        let result = sysctl(&name, UInt32(name.count), &procList, &length, nil, 0)
        
        guard result == 0 else { return nil } // Some error ...
        
        return Array(procList.prefix(length / MemoryLayout<kinfo_proc>.size))
    }
    
    func getAllProcessIDs() -> [pid_t] {
        let runningApplications = NSWorkspace.shared.runningApplications
        let processIDs = runningApplications.map { $0.processIdentifier }
        return processIDs
    }
    
    func getProcessPath(for processID: pid_t) -> String? {
        let process = Process()
        process.launchPath = "/bin/ps"
        process.arguments = ["-p", "\(processID)", "-o", "comm="]

        let pipe = Pipe()
        process.standardOutput = pipe

        process.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        process.waitUntilExit()

        if process.terminationStatus == 0 {
            let trimmedOutput = output?.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmedOutput
        } else {
            return nil
        }
    }
    
    func getFileName(_ strPath: String, _ bExt: Bool? = true) -> String {
        if strPath.isEmpty {
            return ""
        }
        
        var strFileName = ""
        
        if !strPath.contains("/") {
            strFileName = strPath
        } else {
            let index = strPath.firstIndex(of: "/")
            strFileName = String(strPath[index!...])
        }
        
        if bExt == false && strFileName.isEmpty == false {
            if strFileName.contains(".") {
                let index = strPath.firstIndex(of: ".")
                strFileName = String(strFileName[...index!])
            }
        }
        
        return strFileName
    }
}
