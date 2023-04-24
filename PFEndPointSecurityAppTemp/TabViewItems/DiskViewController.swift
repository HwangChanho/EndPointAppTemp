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
        
        print("externalStorage ::", getExternalVolumeNameList(keys: .externalStorage))
        // comboBox external
        
        print("removableDisk ::", getExternalVolumeNameList(keys: .removableDisk))
        
        let path = getVolumePath(getExternalVolumeNameList(keys: .externalStorage).first!)

        print("BSD ::", getDiskFromVolume(path), path)
        
        print("Disk Info ::", getDiskInfo(getExternalVolumeNameList(keys: .externalStorage).first!))

//        print("unMount ::", unMountDisk(path))
        
        print("add mount Observer ::", setMountCallBack( { path in
            print(path)
        }))
        
        print("add unMount Observer ::", setUnMountCallBack({ path in
            print(path)
        }))
        
        getSerialNumber(getExternalVolumeNameList(keys: .externalStorage).first!)
        
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func getExternalDistListButtonDidTapped(_ sender: Any) {
        
    }
    
    
    
}
