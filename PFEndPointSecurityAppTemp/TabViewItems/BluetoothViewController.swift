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
    
    private var textViewLineCount = 0
    
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
            textViewLineCount = setTextViewText(self.textView, "Nothing To DisConnect", textViewLineCount)
        } else {
            textViewLineCount = setTextViewText(self.textView, "DisConnecting...", textViewLineCount)
            
            DispatchQueue.main.async { [self] in
                if kIOReturnSuccess != self.connectedDeviceListArr[index].closeConnection() {
                    textViewLineCount = setTextViewText(self.textView, "DisConnecting fail", textViewLineCount)
                } else {
                    textViewLineCount = setTextViewText(self.textView, "DisConnected", textViewLineCount)
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
            textViewLineCount = setTextViewText(self.textView, "Nothing To Connect", textViewLineCount)
        } else {
            textViewLineCount = setTextViewText(self.textView, "Connecting...", textViewLineCount)
            
            DispatchQueue.main.async { [self] in
                if kIOReturnSuccess != self.pairedDeviceListArr[index].openConnection(self, withPageTimeout: 10, authenticationRequired: false) {
                    textViewLineCount = setTextViewText(self.textView, "Connecting fail", textViewLineCount)
                } else {
                    textViewLineCount = setTextViewText(self.textView, "Connected", textViewLineCount)
                }
            }
        }
    }
    
    @IBAction func connectCallBackButtonDidTapped(_ sender: NSButton) {
        
    }
    
    @IBAction func disConnectCallBackButtonDidTapped(_ sender: NSButton) {
        
    }
    
    @IBAction func checkButtonDidTapped(_ sender: NSButton) {
        
    }
    
    @IBAction func documentButtonDidTapped(_ sender: NSButton) {
        
    }
    
    func disConnectDevices() {
        
    }
    
    func connectDevice() {
        
    }
    
    func checkPairedAndConnectedDevices() {
        connectedDeviceList.removeAllItems()
        pairedDeviceList.removeAllItems()
        
        guard let devices = IOBluetoothDevice.pairedDevices() else {
            textViewLineCount = setTextViewText(self.textView, "No devices", textViewLineCount)
            return
        }
        
        for item in devices {
            if let device = item as? IOBluetoothDevice {
                
                if device.isConnected() {
                    connectedDeviceListArr.append(device)
                    connectedDeviceList.addItem(withObjectValue: device.addressString ?? device.name ?? "")
                    connectedDeviceList.selectItem(at: 0)
                    textViewLineCount = setTextViewText(self.textView, "Connected Device :: \(device.addressString ?? "No address") - \(device.name ?? "No device name")", textViewLineCount)
                } else if device.isPaired() {
                    pairedDeviceListArr.append(device)
                    pairedDeviceList.addItem(withObjectValue: device.addressString ?? device.name ?? "")
                    pairedDeviceList.selectItem(at: 0)
                    textViewLineCount = setTextViewText(self.textView, "Paired Device :: \(device.addressString ?? "No address") - \(device.name ?? "No device name")", textViewLineCount)
                }
            }
        }
    }
    
}
