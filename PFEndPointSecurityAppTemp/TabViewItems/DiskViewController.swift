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
    @IBOutlet var textView: NSTextView!
    
    private var externalVolumenameListArr: [String] = []
    private var removableDiskListArr: [String] = []
    
    private var isSetMountCallBack = false
    private var isSetUnMountCallBack = false
    
    private var textViewLineCount = 0
    
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
    
    @IBAction func getExternalVolumeNameButtonClicked(_ sender: NSButton) {
        externalDisk.removeAllItems()
        externalVolumenameListArr.removeAll()
        
        externalVolumenameListArr = getExternalVolumeNameList(keys: .externalStorage)
        for item in externalVolumenameListArr {
            externalDisk.addItem(withObjectValue: item)
            externalDisk.selectItem(at: 0)
            textViewLineCount = setTextViewText(self.textView, "ExternalVolumeName : \(item)", textViewLineCount)
        }
    }
    
    @IBAction func getBSDNameButtonClicked(_ sender: NSButton) {
        let path = getVolumePath(externalVolumenameListArr[checkItemSelected()])
        textViewLineCount = setTextViewText(self.textView, getDiskFromVolume(path), textViewLineCount)
    }
    
    @IBAction func unountButtonClicked(_ sender: NSButton) {
        let path = getVolumePath(externalVolumenameListArr[checkItemSelected()])
        
        if unMountDisk(path) {
            textViewLineCount = setTextViewText(self.textView, "UnmountSucced : \(externalVolumenameListArr[checkItemSelected()])", textViewLineCount)
        } else {
            textViewLineCount = setTextViewText(self.textView, "Unmount Failed : \(externalVolumenameListArr[checkItemSelected()])", textViewLineCount)
        }
    }
    
    @IBAction func getSerialNumberButtonClicked(_ sender: NSButton) {
        let path = getVolumePath(externalVolumenameListArr[checkItemSelected()])
        
        textViewLineCount = setTextViewText(self.textView, "SerialNumber = [\(getSerialNumber(path))]", textViewLineCount)
    }
    
    @IBAction func getDiskInfoButtonClicked(_ sender: NSButton) {
        let path = getVolumePath(externalVolumenameListArr[checkItemSelected()])
        guard let diskInfo = getDiskInfo(path) else { return }
        
        for key in diskInfo.allKeys {
            textViewLineCount = setTextViewText(self.textView, "key=[\(key)], value=[\(diskInfo.object(forKey: key) ?? "noInfo")]", textViewLineCount)
        }
        
    }
    
    @IBAction func getRemovableDiskListButtonClicked(_ sender: NSButton) {
        removableDiskListArr.removeAll()
        removableDiskListArr = getExternalVolumeNameList(keys: .removableDisk)
        for item in removableDiskListArr {
            textViewLineCount = setTextViewText(self.textView, "RemovableVolumeName : \(item)", textViewLineCount)
        }
    }
    
    @IBAction func addExternalVolumeNameButtonClicked(_ sender: NSButton) {
        let path = getVolumePath(externalVolumenameListArr[checkItemSelected()])
        let name = externalVolumenameListArr[checkItemSelected()]
        
        let dictSendData = NSMutableDictionary()
        dictSendData.setObject(NSNumber(integerLiteral: PEPolicyKinds.ExternalStorageVolumePath.rawValue), forKey: POLICY.KEY_ADD_POLICY as NSCopying)
        dictSendData.setObject(path, forKey: POLICY.KEY_ADD_POLICY as NSCopying)
        
    }
    
    @IBAction func delExternalVolumeNameButtonClicked(_ sender: NSButton) {
        
    }
    
    @IBAction func mountCallBackButtonClicked(_ sender: NSButton) {
        if isSetMountCallBack {
            textViewLineCount = setTextViewText(self.textView, "Already Mount CallBack Setted", textViewLineCount)
        }
        
        if !setMountCallBack({ [weak self] path in
            guard let self else { return }
            self.textViewLineCount = setTextViewText(self.textView, "Mount CallBack Succeed", self.textViewLineCount)
            self.isSetMountCallBack = true
        }) {
            textViewLineCount = setTextViewText(self.textView, "Mount CallBack Failed", textViewLineCount)
            return
        }
    }
    
    @IBAction func unMountCallBackButtonClicked(_ sender: NSButton) {
        if isSetUnMountCallBack {
            textViewLineCount = setTextViewText(self.textView, "Already unMount CallBack Setted", textViewLineCount)
        }
        
        if !setUnMountCallBack({ [weak self] path in
            guard let self else { return }
            self.textViewLineCount = setTextViewText(self.textView, "unMount CallBack Succeed", self.textViewLineCount)
            self.isSetUnMountCallBack = true
        }) {
            textViewLineCount = setTextViewText(self.textView, "unMount CallBack Failed", textViewLineCount)
            return
        }
    }
    
    private func checkItemSelected() -> Int {
        let index = externalDisk.indexOfSelectedItem
        
        if index == -1 {
            textViewLineCount = setTextViewText(self.textView, "NothingSelected", textViewLineCount)
        }
        
        return index
    }
    
}

