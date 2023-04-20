//
//  Util.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/04/20.
//

import Cocoa
import Foundation

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
