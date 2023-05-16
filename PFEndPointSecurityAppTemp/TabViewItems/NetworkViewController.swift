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
    
    // killall sharedfilelistd
    @IBAction func getActiveNicName(_ sender: NSButton) {
        if !activeNicNameListArr.isEmpty {
            activeNicNameListArr.removeAll()
            activeNicNameComboBox.removeAllItems()
        }
        
        if !networkUtilManager.getActiveNicName({ [self] interFaceName in
            textViewLineCount = setTextViewText(self.textView, "ActiveNicName : \(interFaceName)", textViewLineCount)
            activeNicNameListArr.append(interFaceName)
            activeNicNameComboBox.addItem(withObjectValue: interFaceName)
            activeNicNameComboBox.selectItem(at: 0)
        }) {
            textViewLineCount = setTextViewText(self.textView, "GetActiveNicName failed!", textViewLineCount)
        }
    }
    
    @IBAction func getServiceName(_ sender: NSButton) {
        guard let nicName = getSelectedName() else { return }
        
        if !networkUtilManager.getServiceName(nicName, { [self] service in
            if service.isEmpty {
                textViewLineCount = setTextViewText(self.textView, "not serviced", textViewLineCount)
            } else {
                textViewLineCount = setTextViewText(self.textView, "Service Name : [\(service)]", textViewLineCount)
            }
        }) {
            textViewLineCount = setTextViewText(self.textView, "GetServiceName failed!!!", textViewLineCount)
        }
    }
    
    @IBAction func getServiceInfo(_ sender: NSButton) {
        guard let nicName = getSelectedName() else { return }
        
        
    }
    
    @IBAction func powerOff(_ sender: NSButton) {
        
    }
    
    @IBAction func getAllNicInfo(_ sender: NSButton) {
        textViewLineCount = setTextViewText(self.textView, networkUtilManager.getAllNicInfoKeyValue(), textViewLineCount)
    }
    
    @IBAction func statusChangeCallBack(_ sender: NSButton) {
        
    }
    
    @IBAction func document(_ sender: NSButton) {
        
    }
    
    private func getActiveNicName() {
        activeNicNameComboBox.removeAllItems()
    }
    
    private func getSelectedName() -> String? {
        let index = activeNicNameComboBox.indexOfSelectedItem
        
        if index < 0 {
            textViewLineCount = setTextViewText(self.textView, "nothing selected activeNicNameComboBox", textViewLineCount)
            return nil
        }
        
        let nicName = activeNicNameListArr[index]
        
        return nicName
    }
}
