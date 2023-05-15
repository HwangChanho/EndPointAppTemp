//
//  OddViewController.swift
//  PFEndPointSecurityAppTemp
//
//  Created by AlexHwang on 2023/05/02.
//

import Cocoa

class OddViewController: NSViewController {
    
    @IBOutlet weak var BSDNameList: NSComboBox!
    @IBOutlet var textView: NSTextView!
    
    private var pairedDeviceListArr: [String] = []
    private var textViewLineCount = 0
    private var isSetConnectCallBack: Bool = false
    
    private let oddUtilManager = OddUtilManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBsdNameListButtonClick()
    }
    
    @IBAction func getNSDNameList(_ sender: NSButton) {
        getBsdNameListButtonClick()
    }
    
    @IBAction func ODDInformation(_ sender: NSButton) {
        getOddInfoFromSelected()
    }
    
    @IBAction func getSerialNumber(_ sender: NSButton) {
        getSerialNumberButtonClicked()
    }
    
    @IBAction func eject(_ sender: NSButton) {
        eject()
    }
    
    @IBAction func connectCallBack(_ sender: NSButton) {
        setCallBack()
    }
    
    @IBAction func disConnectCallBack(_ sender: NSButton) {
        desetCallBack()
    }
    
    @IBAction func setNonePolicy(_ sender: NSButton) {
        let oddPolicy = NSNumber(integerLiteral: ODD_POLICY_NONE)
        
        let dictSendData = NSMutableDictionary()
        dictSendData.setObject(NSNumber(integerLiteral: PolicyKinds.OddPolicy.rawValue), forKey: KEY_SET_POLICY as NSCopying)
        dictSendData.setObject(oddPolicy, forKey: KEY_POLICY_ITEM as NSCopying)
        
        // XPC 관련 확인 Method
        
        dictSendData.removeAllObjects()
        
        textViewLineCount = setTextViewText(self.textView, "Set OddPolicy None", textViewLineCount)
    }
    
    @IBAction func setReadOnlyPolicy(_ sender: NSButton) {
        let oddPolicy = NSNumber(integerLiteral: ODD_POLICY_READ_ONLY)
        
        let dictSendData = NSMutableDictionary()
        dictSendData.setObject(NSNumber(integerLiteral: PolicyKinds.OddPolicy.rawValue), forKey: KEY_SET_POLICY as NSCopying)
        dictSendData.setObject(oddPolicy, forKey: KEY_POLICY_ITEM as NSCopying)
        
        // XPC 관련 확인 Method
        
        dictSendData.removeAllObjects()
        
        textViewLineCount = setTextViewText(self.textView, "Set OddPolicy ReadOnly", textViewLineCount)
    }
    
    @IBAction func setPDRCheckPolicy(_ sender: NSButton) {
        textViewLineCount = setTextViewText(self.textView, "SetOddPolicy PrivateDataRecordCheck Not Develop !!!", textViewLineCount)
    }
    
    private func setCallBack() {
        if isSetConnectCallBack {
            textViewLineCount = setTextViewText(self.textView, "Already Connect CallBack", textViewLineCount)
            return
        }
        
        let detector = IODetector()
        
        detector?.callbackQueue = DispatchQueue.global()
        detector?.callback = { [self] (dector, event, service) in
            textViewLineCount = setTextViewText(self.textView, "connect dected :: \(event)", textViewLineCount)
        }
        
        if !(detector?.startDetection(.KIODBMediaClass))! {
            textViewLineCount = setTextViewText(self.textView, "Connect CallBack failed!!!", textViewLineCount)
        }
        
        if !(detector?.startDetection(.KIODVDMediaClass))! {
            textViewLineCount = setTextViewText(self.textView, "Connect CallBack failed!!!", textViewLineCount)
        }
        
        if !(detector?.startDetection(.KIOMediaClass))! {
            textViewLineCount = setTextViewText(self.textView, "Connect CallBack failed!!!", textViewLineCount)
        }
        
        isSetConnectCallBack = true
        textViewLineCount = setTextViewText(self.textView, "Connect CallBack Succeed", textViewLineCount)
    }
    
    private func desetCallBack() {
        if isSetConnectCallBack {
            textViewLineCount = setTextViewText(self.textView, "Already DisConnect CallBack", textViewLineCount)
            return
        }
        
        let detector = IODetector()
        
        detector?.callbackQueue = DispatchQueue.global()
        detector?.callback = { [self] (dector, event, service) in
            textViewLineCount = setTextViewText(self.textView, "connect dected :: \(event)", textViewLineCount)
        }
        
        if !(detector?.startDetection(.KIODBMediaClass))! {
            textViewLineCount = setTextViewText(self.textView, "DisConnect CallBack failed!!!", textViewLineCount)
        }
        
        if !(detector?.startDetection(.KIODVDMediaClass))! {
            textViewLineCount = setTextViewText(self.textView, "DisConnect CallBack failed!!!", textViewLineCount)
        }
        
        if !(detector?.startDetection(.KIOMediaClass))! {
            textViewLineCount = setTextViewText(self.textView, "DisConnect CallBack failed!!!", textViewLineCount)
        }
        
        isSetConnectCallBack = true
        textViewLineCount = setTextViewText(self.textView, "DisConnect CallBack Succeed", textViewLineCount)
    }
    
    private func eject() {
        guard let bsdName = getBSDName() else { return }
        
        if oddUtilManager.eject(bsdName) { // eject Fail 했을떄 핸들 안됨
            textViewLineCount = setTextViewText(self.textView, "Ejected", textViewLineCount)
        }
    }
    
    private func getBsdNameListButtonClick() {
        pairedDeviceListArr.removeAll()
        
        oddUtilManager.getConnectBsdNameList(&pairedDeviceListArr)
        
        print("pairedDevice :: ", pairedDeviceListArr)
        
        if pairedDeviceListArr.isEmpty {
            return
        }
        
        pairedDeviceListArr.forEach { device in
            textViewLineCount = setTextViewText(self.textView, "paired Device :: \(device))", textViewLineCount)
        }
        
        BSDNameList.selectItem(at: 0)
    }
    
    private func getOddInfoFromSelected() {
        guard let bsdName = getBSDName() else { return }
        let dictOddInfo = oddUtilManager.getOddInfo(bsdName)
        
        dictOddInfo?.forEach({ (key, value) in
            textViewLineCount = setTextViewText(self.textView, "key=[\(key)], value=[\(value)]", textViewLineCount)
        })
    }
    
    private func getSerialNumberButtonClicked() {
        guard let bsdName = getBSDName() else { return }
        let strSerialNumber = oddUtilManager.getSerialNumberOdd(bsdName)
        
        textViewLineCount = setTextViewText(self.textView, "SerialNumber :: [\(strSerialNumber)]", textViewLineCount)
    }
    
    private func getBSDName() -> String? {
        let selected = BSDNameList.indexOfSelectedItem
        
        if selected < 0 {
            textViewLineCount = setTextViewText(self.textView, "Nothing selected", textViewLineCount)
            return nil
        }
        
        let bsdName = pairedDeviceListArr[selected]
        return bsdName
    }
    
}
