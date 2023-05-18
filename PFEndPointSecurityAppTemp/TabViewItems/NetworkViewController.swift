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
    private var activeNicNameListArrForSwitch: [String] = []
    private var textViewLineCount = 0
    private let networkUtilManager = NetworkUtil.shared
    private var statusChangeCallBack = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func ethernetSwitchClick(_ sender: NSSwitch) {
        if !networkUtilManager.getActiveNicName({ [self] interFaceName in
            activeNicNameListArrForSwitch = interFaceName
            for item in interFaceName {
                guard let info = networkUtilManager.getServiceInfo(item) else { continue }
                guard let hardwareName = info.object(forKey: NetworkNameSpace.HARDWARE.rawValue) else { continue }
                guard let hardwareName = hardwareName as? NSString else { return }
                
                if hardwareName.compare(NetworkNameSpace.HARDWARE_ETHERNET.rawValue, options: .caseInsensitive) == .orderedSame {
                    textViewLineCount = setTextViewText(self.textView, "Ethernet Nic Name : [\(item)]", textViewLineCount)
                }
            }
        }) {
            textViewLineCount = setTextViewText(self.textView, "GetActiveNicName failed!", textViewLineCount)
        }
        
        switchControl(sender: sender, originalSwitch: ethernetSwitch)
    }
    
    @IBAction func airPortSwitchClick(_ sender: NSSwitch) {
        if !networkUtilManager.getActiveNicName({ [self] interFaceName in
            activeNicNameListArrForSwitch = interFaceName
            for item in interFaceName {
                guard let info = networkUtilManager.getServiceInfo(item) else { continue }
                guard let hardwareName = info.object(forKey: NetworkNameSpace.HARDWARE.rawValue) else { continue }
                guard let hardwareName = hardwareName as? NSString else { return }
                
                if hardwareName.compare(NetworkNameSpace.HARDWARE_AIR_PORT.rawValue, options: .caseInsensitive) == .orderedSame {
                    textViewLineCount = setTextViewText(self.textView, "AirPort Nic Name : [\(item)]", textViewLineCount)
                }
            }
        }) {
            textViewLineCount = setTextViewText(self.textView, "GetActiveNicName failed!", textViewLineCount)
        }
        
        switchControl(sender: sender, originalSwitch: airPortSwitch)
    }
    
    @IBAction func modemSwitchClick(_ sender: NSSwitch) {
        if !networkUtilManager.getActiveNicName({ [self] interFaceName in
            activeNicNameListArrForSwitch = interFaceName
            for item in interFaceName {
                guard let info = networkUtilManager.getServiceInfo(item) else { continue }
                guard let hardwareName = info.object(forKey: NetworkNameSpace.HARDWARE.rawValue) else { continue }
                guard let hardwareName = hardwareName as? NSString else { return }
                
                if hardwareName.compare(NetworkNameSpace.HARDWARE_MODEM.rawValue, options: .caseInsensitive) == .orderedSame {
                    textViewLineCount = setTextViewText(self.textView, "Modem Nic Name : [\(item)]", textViewLineCount)
                }
            }
        }) {
            textViewLineCount = setTextViewText(self.textView, "GetActiveNicName failed!", textViewLineCount)
        }
        
        switchControl(sender: sender, originalSwitch: modemSwitch)
    }
    
    @IBAction func thunderboltSwitchClick(_ sender: NSSwitch) {
        if !networkUtilManager.getActiveNicName({ [self] interFaceName in
            activeNicNameListArrForSwitch = interFaceName
            for item in interFaceName {
                guard let info = networkUtilManager.getServiceInfo(item) else { continue }
                guard let hardwareName = info.object(forKey: NetworkNameSpace.HARDWARE.rawValue) else { continue }
                guard let hardwareName = hardwareName as? NSString else { return }
                
                if hardwareName.compare(NetworkNameSpace.HARDWARE_THUNDERBOLT.rawValue, options: .caseInsensitive) == .orderedSame {
                    textViewLineCount = setTextViewText(self.textView, "Modem Nic Name : [\(item)]", textViewLineCount)
                }
            }
        }) {
            textViewLineCount = setTextViewText(self.textView, "GetActiveNicName failed!", textViewLineCount)
        }
        
        switchControl(sender: sender, originalSwitch: thunderboltSwitch)
    }
    
    @IBAction func airDropSwitchClick(_ sender: NSSwitch) {
        if !networkUtilManager.getActiveNicName({ [self] interFaceName in
            activeNicNameListArrForSwitch = interFaceName
            for item in interFaceName {
                if item.contains(NetworkNameSpace.INTERFACE_APPLE_WIRELESS_DIRECT_LINK.rawValue) {
                    textViewLineCount = setTextViewText(self.textView, "AirDrop Nic Name : [\(item)]", textViewLineCount)
                }
            }
        }) {
            textViewLineCount = setTextViewText(self.textView, "GetActiveNicName failed!", textViewLineCount)
        }
        
        switchControl(sender: sender, originalSwitch: airDropSwitch)
    }
    
    @IBAction func bridgeSwitchClick(_ sender: NSSwitch) {
        if !networkUtilManager.getActiveNicName({ [self] interFaceName in
            activeNicNameListArrForSwitch = interFaceName
            for item in interFaceName {
                if item.contains(NetworkNameSpace.INTERFACE_BRIDGE.rawValue) {
                    textViewLineCount = setTextViewText(self.textView, "AirDrop Nic Name : [\(item)]", textViewLineCount)
                }
            }
        }) {
            textViewLineCount = setTextViewText(self.textView, "GetActiveNicName failed!", textViewLineCount)
        }
        
        switchControl(sender: sender, originalSwitch: bridgeSwitch)
    }
    
    @IBAction func fireWireSwitchClick(_ sender: NSSwitch) {
        if !networkUtilManager.getActiveNicName({ [self] interFaceName in
            activeNicNameListArrForSwitch = interFaceName
            for item in interFaceName {
                if item.contains(NetworkNameSpace.INTERFACE_FIRE_WIRE.rawValue) {
                    textViewLineCount = setTextViewText(self.textView, "AirDrop Nic Name : [\(item)]", textViewLineCount)
                }
            }
        }) {
            textViewLineCount = setTextViewText(self.textView, "GetActiveNicName failed!", textViewLineCount)
        }
        
        switchControl(sender: sender, originalSwitch: firewireSwitch)
    }
    
    @IBAction func usbSwitchClick(_ sender: NSSwitch) {
        if !networkUtilManager.getActiveNicName({ [self] interFaceName in
            activeNicNameListArrForSwitch = interFaceName
            for item in interFaceName {
                let _ = networkUtilManager.getServiceName(item) { [self] serviceName in
                    print(serviceName)
                    
                    if serviceName.contains(NetworkNameSpace.SERVICE_USB.rawValue) {
                        textViewLineCount = setTextViewText(self.textView, "USB Tethering Nic Name : [\(serviceName)]", textViewLineCount)
                    }
                }
            }
        }) {
            textViewLineCount = setTextViewText(self.textView, "GetActiveNicName failed!", textViewLineCount)
        }
        
        switchControl(sender: sender, originalSwitch: usbSwitch)
    }
    
    @IBAction func btSwitchClick(_ sender: NSSwitch) {
        if !networkUtilManager.getActiveNicName({ [self] interFaceName in
            activeNicNameListArrForSwitch = interFaceName
            for item in interFaceName {
                let _ = networkUtilManager.getServiceName(item) { [self] serviceName in
                    if serviceName.contains(NetworkNameSpace.SERVICE_BLUETOOTH_PAN.rawValue) {
                        textViewLineCount = setTextViewText(self.textView, "BluetoothPAN Nic Name : [\(serviceName)]", textViewLineCount)
                    }
                }
            }
        }) {
            textViewLineCount = setTextViewText(self.textView, "GetActiveNicName failed!", textViewLineCount)
        }
        
        switchControl(sender: sender, originalSwitch: bluetoothSwitch)
    }
    
    // killall sharedfilelistd, pgrep -x PFEndPointSecurityAppTemp
    @IBAction func getActiveNicName(_ sender: NSButton) {
        if !activeNicNameListArr.isEmpty {
            activeNicNameListArr.removeAll()
            activeNicNameComboBox.removeAllItems()
        }
        
        if !networkUtilManager.getActiveNicName({ [self] interFaceName in
            activeNicNameListArr = interFaceName
            interFaceName.forEach {
                textViewLineCount = setTextViewText(self.textView, "ActiveNicName : \($0)", textViewLineCount)
                activeNicNameComboBox.addItem(withObjectValue: $0)
                activeNicNameComboBox.selectItem(at: 0)
            }
            setSwitchStatus(interFaceName)
        }) {
            textViewLineCount = setTextViewText(self.textView, "GetActiveNicName failed!", textViewLineCount)
        }
    }
    
    @IBAction func getServiceName(_ sender: NSButton) {
        guard let nicName = getSelectedName() else { return }
        
        if !networkUtilManager.getServiceName(nicName, { [self] service in
            textViewLineCount = setTextViewText(self.textView, "Service Name : [\(service)]", textViewLineCount)
        }) {
            textViewLineCount = setTextViewText(self.textView, "GetServiceName failed!!!", textViewLineCount)
        }
    }
    
    @IBAction func getServiceInfo(_ sender: NSButton) {
        guard let nicName = getSelectedName() else { return }
        
        guard let dicServiceInfo = networkUtilManager.getServiceInfo(nicName) else {
            textViewLineCount = setTextViewText(self.textView, "not serviced", textViewLineCount)
            return
        }
        
        for key in dicServiceInfo.allKeys {
            let value = dicServiceInfo.value(forKey: key as! String)
            textViewLineCount = setTextViewText(self.textView, "Key=[\(key)], Value=[\(String(describing: value))]", textViewLineCount)
        }
    }
    
    @IBAction func powerOff(_ sender: NSButton) {
        if getuid() != 0 && geteuid() != 0 {
            textViewLineCount = setTextViewText(self.textView, "Permission denied", textViewLineCount)
            return
        }
        
        guard let nicName = getSelectedName() else { return }
        if !networkUtilManager.setPower(on: false, of: nicName) {
            textViewLineCount = setTextViewText(self.textView, "PowerOff failed : [\(nicName)]", textViewLineCount)
        } else {
            textViewLineCount = setTextViewText(self.textView, "PowerOff succeed : [\(nicName)]", textViewLineCount)
        }
        
    }
    
    @IBAction func getAllNicInfo(_ sender: NSButton) {
        textViewLineCount = setTextViewText(self.textView, networkUtilManager.getAllNicInfoKeyValue(), textViewLineCount)
        self.textView.scrollToEndOfDocument(self)
    }
    
    @IBAction func statusChangeCallBack(_ sender: NSButton) {
        if statusChangeCallBack {
            textViewLineCount = setTextViewText(self.textView, "Already SetStatusChange CallBack", textViewLineCount)
            return
        }
        
        if networkUtilManager.setNicStatusChangeCallBack() == false {
            textViewLineCount = setTextViewText(self.textView, "StatusChange CallBack failed!!!", textViewLineCount)
            return
        }
        
        statusChangeCallBack = true
        textViewLineCount = setTextViewText(self.textView, "StatusChange CallBack Succeed", textViewLineCount)
    }
    
    @IBAction func document(_ sender: NSButton) {
        let logString = "-------------------------------------------------- Network Interface -------------------------------------------------------\n" +
        "Type     : Ethernet, Firewire, 6to4, PPP(반드시 SubType 존재)\n" +
        "SubType  : PPPoE, PPPSerial, PPPSerial, PPTP, L2TP\n" +
        "Hardware : Ethernet, AirPort, Modem, Thunderbolt(? 확인 필요)\n" +
        "----------------------------------------------------------------------------------------------------------------------------\n" +
        "------------------------------------------------------ Device Name ---------------------------------------------------------\n" +
        "* Loop Back\n" +
        "- lo    [XNU]: 루프백 인터페이스  (루프백 네트워크 : 127.0.0.0/8, IP  주소:127.0.0.1)\n" +
        "- gif   [XNU]: IPv4 및 IPv6용 일반 터널링 장치 \n" +
        "- stf   [XNU]: 6to4 터널링 인터페이스\n" +
        "- utun  [XNU]: 터널링 인터페이스, 터널 트래픽에 대한 VPN 연결 그리고 Back To My Mac 같은 소프트웨어에 사용(User Mode)\n" +
        "- ipsec [XNU]: IPSec 터널링 인터페이스\n" +
        "\n* Ethernet\n" +
        "- en    [IONetworkingFaminly]: Ethernet( 유,무선 및 기타 미디어 )\n" +
        "- awdl  [IOgPTPPlugin.kext] : Apple Wireless Direct Link, AirDrop, AirPlay 등과 같은 Wifi p2p 연결 및 블루투스에서 사용\n" +
        "- p2p   [AppleBCMWLANCore] : AWDL 기능과 관련성이 있지만 AWDL 과는 다른 의미의 가상 인터페이스 , Wi-Fi peer to peer\n" +
        "- ppp   [PPP.kext]: Point-to-Point Protocol (/usr/sbin/pppd)\n" +
        "- bridge[XNU]: macOS 용 브릿징 인터페이스 (예:Thunderbolt Bridge)\n" +
        "- fw    [IOFireWireIP]: macOS IP over FireWire (FireWire Network Interface)\n" +
        "- rvi   [RemoveVirtualInterface]: macOS에서 패킷 캡쳐 용도로 사용(OS 의 연결 된 장치의 패킷)\n" +
        "- ap    : Access Point (personal hotspot, WiFi Tethering), 맥북 연결을 공유하는 무선 호스트로 사용\n" +
        "- llw   : 저 지연 WLAN 인터페이스 Skywalk 시스템에서 사용\n" +
        "- vmnet : 가상 인터페이스, 가상 머신에서 사용\n" +
        "- vmenet: 가상 인터페이스, bridge와 같은 가상 장치에서 사용\n" +
        "\n* Cell\n" +
        "- pdp_ip[AppleBasebandPCI[ICE/MAV]PDP]: iOS/WatchOS : Cellular connection ( if applicable )\n" +
        "\n* USB\n" +
        "- XHC   [AppleUSBHostPacketFilter]: macOS USB Packet Capture\n" +
        "\n* Capture\n" +
        "- [pk/ip]tap0 [XNU]: Packet or IP Layer capture from multiple interfaces\n" +
        "----------------------------------------------------------------------------------------------------------------------------"
        
        DispatchQueue.main.async {
            self.textViewLineCount = setTextViewText(self.textView, logString, self.textViewLineCount)
            self.textView.scrollToEndOfDocument(self)
        }
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
    
    private func setSwitchStatus(_ activeNicNameList: [String]) {
        setHardWareSwitchStatus(activeNicNameList)
        setInterfaceSwitchStatus(activeNicNameList)
        setServiceSwitchStatus(activeNicNameList)
    }
    
    private func setHardWareSwitchStatus(_ activeNicNameList: [String]) {
        ethernetSwitch.state = .off
        airPortSwitch.state = .off
        modemSwitch.state = .off
        thunderboltSwitch.state = .off
        
        for list in activeNicNameList {
            guard let dictServiceInfo = networkUtilManager.getServiceInfo(list) else { continue }
            
            let hardwareName: NSString = ((dictServiceInfo.object(forKey: NetworkNameSpace.HARDWARE.rawValue) as? NSString)!)
            
            if hardwareName.compare(NetworkNameSpace.HARDWARE_ETHERNET.rawValue, options: .caseInsensitive) == .orderedSame {
                ethernetSwitch.state = .on
            } else if hardwareName.compare(NetworkNameSpace.HARDWARE_AIR_PORT.rawValue, options: .caseInsensitive) == .orderedSame {
                airPortSwitch.state = .on
            } else if hardwareName.compare(NetworkNameSpace.HARDWARE_MODEM.rawValue, options: .caseInsensitive) == .orderedSame {
                modemSwitch.state = .on
            } else if hardwareName.compare(NetworkNameSpace.HARDWARE_THUNDERBOLT.rawValue, options: .caseInsensitive) == .orderedSame {
                thunderboltSwitch.state = .on
            }
            
        }
    }
    
    private func setInterfaceSwitchStatus(_ activeNicNameList: [String]) {
        airDropSwitch.state = .off
        bridgeSwitch.state = .off
        firewireSwitch.state = .off
        
        for list in activeNicNameList {
            if list.contains(NetworkNameSpace.INTERFACE_APPLE_WIRELESS_DIRECT_LINK.rawValue) {
                airDropSwitch.state = .on
            } else if list.contains(NetworkNameSpace.INTERFACE_BRIDGE.rawValue) {
                bridgeSwitch.state = .on
            } else if list.contains(NetworkNameSpace.INTERFACE_FIRE_WIRE.rawValue) {
                firewireSwitch.state = .on
            }
        }
    }
    
    private func setServiceSwitchStatus(_ activeNicNameList: [String]) {
        usbSwitch.state = .off
        bluetoothSwitch.state = .off
        
        for list in activeNicNameList {
            let _ = networkUtilManager.getServiceName(list, { [self] strServiceName in
                if list.contains(NetworkNameSpace.SERVICE_USB.rawValue) {
                    usbSwitch.state = .on
                } else if list.contains(NetworkNameSpace.SERVICE_BLUETOOTH_PAN.rawValue) {
                    bluetoothSwitch.state = .on
                }
            })
        }
    }
    
    private func switchControl(sender: NSSwitch, originalSwitch: NSSwitch) {
        switch sender.state {
        case .off:
            originalSwitch.state = .on
        case .on:
            originalSwitch.state = .off
        default:
            print("none")
        }
    }
    
}
