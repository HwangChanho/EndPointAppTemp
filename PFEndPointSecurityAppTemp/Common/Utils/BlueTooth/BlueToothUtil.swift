//
//  BlueToothUtil.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/04/25.
//

import Foundation
import IOBluetooth



// MARK: BlueToot

func getDeviceClassMajorDescriptionWithDeviceAddressInString(_ deviceAddress: String) -> String {
    guard let device = IOBluetoothDevice(addressString: deviceAddress) else { return "" }
    
    return getDeviceClassMajorDescription(Int(device.deviceClassMajor))
}

func getDeviceClassMajorAndMinorDescriptionWithDeviceAddressInString(_ deviceAddress: String) -> String {
    guard let device = IOBluetoothDevice(addressString: deviceAddress) else { return "" }
    
    return getDeviceClassDescription(Int(device.deviceClassMajor), Int(device.deviceClassMinor))
}

func getDeviceName(_ deviceAddress: String) -> String {
    guard let device = IOBluetoothDevice(addressString: deviceAddress) else { return "" }
    
    return device.name
}

func getDeviceClassMajorDescription(_ classMajor: Int) -> String {
    if kBluetoothDeviceClassMajorMiscellaneous > classMajor || kBluetoothDeviceClassMajorUnclassified < classMajor { return "" }
    
    guard let description: NSString = BTD_CLASS_MAJOR_DESCRIPTION_DICT.object(forKey: classMajor) as? NSString else { return "" }
    
    if description.length == 0 { return "" }
    
    return description as String
}

func getDeviceClassDescription(_ classMajor: Int, _ classMinor: Int) -> String {
    if kBluetoothDeviceClassMajorMiscellaneous > classMajor || kBluetoothDeviceClassMajorUnclassified < classMajor { return "" }
    
    guard let dictClassMinor: NSDictionary = BTD_CLASS_DESCRIPTION_DICT.object(forKey: classMajor) as? NSDictionary else { return "" }
    if dictClassMinor.count == 0 { return "" }
    
    return dictClassMinor.object(forKey: classMinor) as! String
}

func setBlueToothConnectCallBack(_ deviceAddress: String) -> String {
    guard let device = IOBluetoothDevice(addressString: deviceAddress) else { return "" }

    return blueToothConnectionCallBack(device.name, deviceAddress, Int(device.deviceClassMajor), Int(device.deviceClassMinor))
}

func setBlueToothDisconnectCallBack(_ deviceAddress: String) -> String {
    guard let device = IOBluetoothDevice(addressString: deviceAddress) else { return "" }

    return blueToothDisConnectionCallBack(device.name, deviceAddress, Int(device.deviceClassMajor), Int(device.deviceClassMinor))
}

func blueToothConnectionCallBack(_ deviceName: String, _ deviceAddress: String, _ classMajor: Int, _ classMinor: Int) -> String {
    let strDescription: String = getDeviceClassDescription(classMajor, classMinor)
    
    return "Bluetooth Connected : [\(deviceName)][\(strDescription)][\(deviceAddress)][\(classMajor)][\(classMinor)]"
}

func blueToothDisConnectionCallBack(_ deviceName: String, _ deviceAddress: String, _ classMajor: Int, _ classMinor: Int) -> String {
    let strDescription: String = getDeviceClassDescription(classMajor, classMinor)
    
    return "Bluetooth DisConnected : [\(deviceName)][\(strDescription)][\(deviceAddress)][\(classMajor)][\(classMinor)]"
}

func getDocumentInfo() -> String {
    var logString = "---------------------------------------------------------- Bluetooth  -------------------------------------------------------\n"
    
    let sortOrder = NSSortDescriptor(key: "self", ascending: true)
    let arrKeys = NSArray(array: BTD_CLASS_MAJOR_DESCRIPTION_DICT.allKeys)
    arrKeys.sortedArray(using: [sortOrder])
    
    for key in arrKeys {
        logString += "Class[\(key)], Description[\(String(describing: BTD_CLASS_MAJOR_DESCRIPTION_DICT.object(forKey: key)))]\n"
    }
    
    for key in arrKeys {
        let dictMinorClassDescription: NSDictionary = BTD_CLASS_DESCRIPTION_DICT.object(forKey: key) as! NSDictionary
        
        let arrDictKeys: NSArray = dictMinorClassDescription.allKeys as NSArray
        arrDictKeys.sortedArray(using: [sortOrder])
        
        for minorKey in arrDictKeys {
            logString += "Class[\(key)][\(minorKey)], Description[\(String(describing: dictMinorClassDescription.object(forKey: minorKey)))]\n"
        }
    }
    
    logString += "-------------------------------------------------------------------------------------------------------------------------------\n"
    
    return logString
}

func checkBluetooth() -> Bool {
    let objc = CPPWrapper()
    
    return objc.getPowerState()
}

func setPower(_ onOff: BlueToothPower) {
    let objc = CPPWrapper()
    
    objc.setPower(onOff.state)
}
