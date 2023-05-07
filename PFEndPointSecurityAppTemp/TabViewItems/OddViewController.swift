//
//  OddViewController.swift
//  PFEndPointSecurityAppTemp
//
//  Created by AlexHwang on 2023/05/02.
//

import Cocoa

class OddViewController: NSViewController {
    
    @IBOutlet var textView: NSTextView!
    
    private var pairedDeviceListArr: [String] = []
    private var textViewLineCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getBsdNameListButtonClick()
    }
    
    private func getBsdNameListButtonClick() {
        let manager = OddUtilManager.shared
        
        manager.getConnectBsdNameList(&pairedDeviceListArr)
        
        print("paired Device :: ", pairedDeviceListArr)
    }
    
}
