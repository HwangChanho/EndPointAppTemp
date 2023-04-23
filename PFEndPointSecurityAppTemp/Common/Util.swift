//
//  Util.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/04/20.
//

import Cocoa
import Foundation

enum RootVolumePath {
    static let rootVolumePath = "file:///Volumes/"
    static let rootVolumePathLen = 16
}

func setTextViewText(_ textView: NSTextView, _ text: String, _ textViewLineCount: Int) -> Int {
    let lineCountToString = String(textViewLineCount)
    textView.textStorage?.append(NSAttributedString(string: lineCountToString + " ::  " + text + "\n"))
    
    if let textLength = textView.textStorage?.length {
        textView.textStorage?.setAttributes([.foregroundColor: NSColor.white, .font: NSFont.systemFont(ofSize: 13)], range: NSRange(location: 0, length: textLength))
    }
    
    return textViewLineCount + 1
}

func krReturnToString (_ kr: kern_return_t) -> String {
    if let cStr = mach_error_string(kr) {
        return String (cString: cStr)
    } else {
        return "Unknown kernel error \(kr)"
    }
}

// Disk
func getExternalVolumeNameList(keys: URLResourceKeyOptions) -> [String] {
    let filemanager = FileManager()
    let paths = filemanager.mountedVolumeURLs(includingResourceValuesForKeys: keys.keys, options: .produceFileReferenceURLs)
    var externalStorageVolumeNameArr: [String] = []
    var removableVolumeNameArr: [String] = []
    
    if let urls = paths as? [NSURL] {
        for url in urls {
            var isInternal: AnyObject?
            
            do {
                let _: () = try url.getResourceValue(&isInternal, forKey: keys.forKey)
                
                if isInternal == nil {
                    continue
                } else {
                    guard let volumeName = url.lastPathComponent else { return [] }
                    if isInternal as! Bool == false {
                        externalStorageVolumeNameArr.append(volumeName)
                    } else {
                        removableVolumeNameArr.append(volumeName)
                    }
                }
            } catch {
                print(error)
            }
            
        }
    }
    
    return keys == .externalStorage ? externalStorageVolumeNameArr : removableVolumeNameArr
}

func getVolumePath(volumeName: [String]) -> [String] {
    if volumeName.isEmpty {
        return []
    }
    
    var volumePath: [String] = []
    
    
    return []
}

