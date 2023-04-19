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
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectedDeviceList.addItems(withObjectValues: ["1", "2"])
        pairedDeviceList.addItems(withObjectValues: ["A", "B"])
        
        pairedDevices()
        
        guard let devices = IOBluetoothDevice.pairedDevices() else {
            print("No devices")
            return
        }
        
        print("devices :", devices)
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func getConnectedDeviceListDidTapped(_ sender: NSButton) {
        
    }
    
    @IBAction func disConnectButtonDidTapped(_ sender: NSButton) {
        
    }
    
    @IBAction func getPairedDevicedListButtonDidTapped(_ sender: NSButton) {
        
    }
    
    @IBAction func connectedButtonDidTapped(_ sender: NSButton) {
        
    }
    
    @IBAction func connectCallBackButtonDidTapped(_ sender: NSButton) {
        
    }
    
    @IBAction func disConnectCallBackButtonDidTapped(_ sender: NSButton) {
        
    }
    
    @IBAction func checkButtonDidTapped(_ sender: NSButton) {
        
    }
    
    @IBAction func documentButtonDidTapped(_ sender: NSButton) {
        
    }
    
    func pairedDevices() {
        print("Bluetooth devices:")
        
        guard let devices = IOBluetoothDevice.pairedDevices() else {
            print("No devices")
            return
        }
        
        for item in devices {
            if let device = item as? IOBluetoothDevice {
                print("Name: \(device.name ?? "noName")")
                print("Paired?: \(device.isPaired())")
                print("Connected?: \(device.isConnected())")
            }
        }
        
        
    }
    
}

extension BluetoothViewController {
    private func checkBluetoothPermission() {
        
    }
    
    private func setLog(_ text: String) {
        
    }
}
