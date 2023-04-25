//
//  BluetoothViewController.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/04/19.
//

import Cocoa
import IOBluetooth

class BluetoothViewController: NSViewController {
    @IBOutlet weak var connectedDeviceList: NSComboBox!
    @IBOutlet weak var pairedDeviceList: NSComboBox!
    @IBOutlet weak var powerToggle: NSSwitch!
    @IBOutlet var textView: NSTextView!
    
    private var pairedDeviceListArr: [IOBluetoothDevice] = []
    private var connectedDeviceListArr: [IOBluetoothDevice] = []
    private var disconnectCallBackDeviceListArr: [IOBluetoothDevice] = []
    
    private var isSetConnectCallBack = false
    
    private var textViewLineCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        checkBluetooth()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func getConnectedDeviceListDidTapped(_ sender: NSButton) {
        checkPairedAndConnectedDevices()
    }
    
    @IBAction func disConnectButtonDidTapped(_ sender: NSButton) {
        let index = connectedDeviceList.indexOfSelectedItem
        
        if index == -1 {
            setLog("Nothing To DisConnect")
        } else {
            setLog("DisConnecting...")
            
            DispatchQueue.main.async { [self] in
                if kIOReturnSuccess != self.connectedDeviceListArr[index].closeConnection() {
                    setLog("DisConnecting fail")
                } else {
                    setLog("DisConnected")
                }
            }
        }
    }
    
    @IBAction func getPairedDevicedListButtonDidTapped(_ sender: NSButton) {
        checkPairedAndConnectedDevices()
    }
    
    @IBAction func connectedButtonDidTapped(_ sender: NSButton) {
        let index = pairedDeviceList.indexOfSelectedItem
        
        if index == -1 {
            setLog("Nothing To Connect")
        } else {
            setLog("Connecting...")
            
            DispatchQueue.main.async { [self] in
                if kIOReturnSuccess != self.pairedDeviceListArr[index].openConnection(self, withPageTimeout: 10, authenticationRequired: false) {
                    setLog("Connecting fail")
                } else {
                    setLog("Connected")
                }
            }
        }
    }
    
    @IBAction func connectCallBackButtonDidTapped(_ sender: NSButton) {
        if isSetConnectCallBack {
            setLog("Already SetConnectCallBack")
            return
        }
        
        IOBluetoothDevice.register(forConnectNotifications: self, selector: #selector(getBluetoothNotification))
        
        isSetConnectCallBack = true
        setLog("Set Connect CallBack")
    }
    
    @IBAction func disConnectCallBackButtonDidTapped(_ sender: NSButton) {
        let index = connectedDeviceList.indexOfSelectedItem
        
        if index == -1 {
            setLog("Select Device First!")
            return
        } else {
            disconnectCallBackDeviceListArr.forEach { device in
                if device == connectedDeviceListArr[index] {
                    setLog("Already SetDisConnectCallBack")
                }
            }
            
            connectedDeviceListArr[index].register(forDisconnectNotification: self, selector: #selector(getBluetoothNotificationForDisConnect))
        }
        
        disconnectCallBackDeviceListArr.append(connectedDeviceListArr[index])
        setLog("Set DisConnect CallBack")
    }
    
    @IBAction func powerToggleSwitchDidTapped(_ sender: NSSwitch) {
        print(sender.state)
        switch sender.state.rawValue {
        case 1:
            setLog("Power is On")
        case 0:
            setLog("Power is Off")
        default:
            setLog("default")
        }
    }
    
    @IBAction func checkButtonDidTapped(_ sender: NSButton) {

        
        switch IOBluetoothHostController().powerState.rawValue {
        case 1:
            setLog("Power is On")
            powerToggle.state = .on
        case 2:
            setLog("Power is Off")
            powerToggle.state = .off
        default:
            setLog("default")
            powerToggle.state = .off
        }
    }
    
    @IBAction func documentButtonDidTapped(_ sender: NSButton) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            setLog(getDocumentInfo())
            if let textLength = textView.textStorage?.length {
                textView.textStorage?.setAttributes([.foregroundColor: NSColor.white, .font: NSFont(name: "Menlo", size: 11)!], range: NSRange(location: 0, length: textLength))
            }
        }
    }
    
    func checkPairedAndConnectedDevices() {
        connectedDeviceList.removeAllItems()
        pairedDeviceList.removeAllItems()
        
        guard let devices = IOBluetoothDevice.pairedDevices() else {
            setLog("No devices")
            return
        }
        
        for item in devices {
            if let device = item as? IOBluetoothDevice {
                
                if device.isConnected() {
                    connectedDeviceListArr.append(device)
                    connectedDeviceList.addItem(withObjectValue: device.addressString ?? "")
                    connectedDeviceList.selectItem(at: 0)
                    setLog("Connected Device :: \(device.addressString ?? "No address") - \(device.name ?? "No device name")")
                } else if device.isPaired() {
                    pairedDeviceListArr.append(device)
                    pairedDeviceList.addItem(withObjectValue: device.addressString ?? "")
                    pairedDeviceList.selectItem(at: 0)
                    setLog("Paired Device :: \(device.addressString ?? "No address") - \(device.name ?? "No device name")")
                }
            }
        }
    }
    
    private func setLog(_ text: String) {
        textViewLineCount = setTextViewText(self.textView, text, textViewLineCount)
        textView.scrollToEndOfDocument(self)
    }
    
    @objc private func getBluetoothNotification(_ deviceInfo: IOBluetoothUserNotification, _ device: IOBluetoothDevice) {
        textViewLineCount = setTextViewText(self.textView, setBlueToothConnectCallBack(device.addressString), textViewLineCount)
        
        if connectedDeviceListArr.contains(device) {
            return
        }
        connectedDeviceListArr.append(device)
        connectedDeviceList.addItem(withObjectValue: device.addressString ?? "")
    }
    
    @objc private func getBluetoothNotificationForDisConnect(_ deviceInfo: IOBluetoothUserNotification, _ device: IOBluetoothDevice) {
        textViewLineCount = setTextViewText(self.textView, setBlueToothDisconnectCallBack(device.addressString), textViewLineCount)
        checkPairedAndConnectedDevices()
    }
    
}
