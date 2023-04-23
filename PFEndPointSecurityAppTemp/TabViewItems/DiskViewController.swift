//
//  DistViewController.swift
//  PFEndPointSecurityAppTemp
//
//  Created by AlexHwang on 2023/04/22.
//

import Cocoa

enum VolumeName {
    static let rootVolumeName = "@/Volumes/"
}

protocol URLResourceKeyOptionsProtocol {
    var keys: [URLResourceKey] { get }
}

enum URLResourceKeyOptions: URLResourceKeyOptionsProtocol {
    case removableDisk
    case externalStorage
    
    var keys: [URLResourceKey] {
        switch self {
        case .removableDisk:
            return [.volumeIsInternalKey]
        case .externalStorage:
            return [.volumeNameKey, .volumeIsRemovableKey]
        }
    }
    
    var forKey: URLResourceKey {
        switch self {
        case .removableDisk:
            return .volumeIsRemovableKey
        case .externalStorage:
            return .volumeIsInternalKey
        }
    }
}

class DiskViewController: NSViewController {
    
    @IBOutlet weak var externalDisk: NSComboBox!
    @IBOutlet weak var textView: NSScrollView!
    
    private var textViewLineCount = 0
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("externalStorage :: ", getExternalVolumeNameList(keys: .externalStorage))
        // comboBox external
        
        print("removableDisk :: ", getExternalVolumeNameList(keys: .removableDisk))
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func getExternalDistListButtonDidTapped(_ sender: Any) {
        
    }
    
    //    func findSerialDevices(deviceType: String, serialPortIterator: inout io_iterator_t ) -> kern_return_t {
    //        var result: kern_return_t = KERN_FAILURE
    //        var classesToMatch = IOServiceMatching(kIOSerialBSDServiceValue)
    //        var classesToMatchDict = (classesToMatch! as NSDictionary) as! Dictionary<String, AnyObject>
    //        classesToMatchDict[kIOSerialBSDTypeKey] = deviceType as AnyObject
    //
    //        let classesToMatchCFDictRef = (classesToMatchDict as NSDictionary) as CFDictionary
    //        result = IOServiceGetMatchingServices(kIOMainPortDefault, classesToMatchCFDictRef, &serialPortIterator);
    //
    //        print(result)
    //
    //        return result
    //    }
    
    
    
}

