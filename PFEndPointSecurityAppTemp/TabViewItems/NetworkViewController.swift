//
//  NetworkViewController.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/05/15.
//

import Cocoa

class NetworkViewController: NSViewController {
    
    @IBOutlet weak var activeNicNameComboBox: NSComboBox!
    @IBOutlet var textView: NSTextView!
    
    @IBOutlet weak var ethernetSwitch: NSSwitch!
    @IBOutlet weak var airPortSwitch: NSSwitch!
    @IBOutlet weak var modemSwitch: NSSwitch!
    @IBOutlet weak var thunderboltSwitch: NSSwitch!
    @IBOutlet weak var airDropSwitch: NSSwitch!
    @IBOutlet weak var bridgeSwitch: NSSwitch!
    @IBOutlet weak var firewireSwitch: NSSwitch!
    @IBOutlet weak var usbSwitch: NSSwitch!
    @IBOutlet weak var bluetoothSwitch: NSSwitch!
    
    private var activeNicNameListArr: [String] = []
    private var textViewLineCount = 0
    private let networkUtilManager = NetworkUtil.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func getActiveNicName(_ sender: NSButton) {
        
    }
    
    @IBAction func getServiceName(_ sender: NSButton) {
        
    }
    
    @IBAction func getServiceInfo(_ sender: NSButton) {
        
    }
    
    @IBAction func powerOff(_ sender: NSButton) {
        
    }
    
    @IBAction func getAllNicInfo(_ sender: NSButton) {
        getAllNicInfo()
    }
    
    @IBAction func statusChangeCallBack(_ sender: NSButton) {
        
    }
    
    @IBAction func document(_ sender: NSButton) {
        
    }
    
    private func getAllNicInfo() {
        guard let arrNicInfo = networkUtilManager.getAllNicInfo() else { return }
        
        for info in arrNicInfo {
            let nicInfo = NSString(format: info as! NSString, "%@")
            
            if !nicInfo.contains(LEFT_CURLY_BRAKET) {
                textViewLineCount = setTextViewText(self.textView, info as! String, textViewLineCount)
                return
            }
            
            guard let range = NSRange(LEFT_CURLY_BRAKET) else { return }
            let parseInfo = nicInfo.substring(with: NSMakeRange(range.location + 1, nicInfo.length - (range.location + 2)))
            let listItems: NSArray = parseInfo.components(separatedBy: COMMA_SPACE) as NSArray
            
            for item in listItems {
                let newItem: NSString = item as! NSString
                let keyValue: NSArray = newItem.components(separatedBy: "=") as NSArray
                let value: NSString = (keyValue.object(at: 1) as AnyObject).trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as NSString
                let key: NSString = (keyValue.object(at: 0) as AnyObject).trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as NSString
                
                textViewLineCount = setTextViewText(self.textView, "Key=[\(key)], Value=[\(value)]", textViewLineCount)
            }
        }
    }
    
    private func getActiveNicName() {
        activeNicNameComboBox.removeAllItems()
        
        
    }
}
