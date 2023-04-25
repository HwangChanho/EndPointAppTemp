//
//  BlueToothClassDescription.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/04/25.
//

import Foundation
import IOBluetooth

// MARK: BlueToot Descriptions

let BTD_CLASS_DICT_EMPTY: NSDictionary = [:]

let BTD_CLASS_MAJOR_DESCRIPTION_DICT: NSDictionary = [
    Int(kBluetoothDeviceClassMajorMiscellaneous): "Miscellaneous",
    Int(kBluetoothDeviceClassMajorComputer): "Desktop, Notebook, PDA, Organizers, etc...",
    Int(kBluetoothDeviceClassMajorPhone): "Cellular, Cordless, Payphone, Modem, etc...",
    Int(kBluetoothDeviceClassMajorLANAccessPoint): "LAN Access Point",
    Int(kBluetoothDeviceClassMajorAudio): "Headset, Speaker, Stereo, etc...",
    Int(kBluetoothDeviceClassMajorPeripheral): "Mouse, Joystick, Keyboards, etc...",
    Int(kBluetoothDeviceClassMajorImaging): "Printing, scanner, camera, display, etc...(Reserved)",
    Int(kBluetoothDeviceClassMajorWearable): "Wearable (Reserved)",
    Int(kBluetoothDeviceClassMajorToy): "Toy (Reserved)",
    Int(kBluetoothDeviceClassMajorHealth): "Health devices (Reserved)",
    Int(kBluetoothDeviceClassMajorUnclassified): "Specific device code not assigned",
]

let BTD_CLASS_MINOR_COMPUTER_DESCRIPTION_DICT: NSDictionary = [
    Int(kBluetoothDeviceClassMinorComputerUnclassified): "Specific device code not assigned",
    Int(kBluetoothDeviceClassMinorComputerDesktopWorkstation): "Desktop workstation",
    Int(kBluetoothDeviceClassMinorComputerServer): "Server-class computer",
    Int(kBluetoothDeviceClassMinorComputerLaptop): "Laptop",
    Int(kBluetoothDeviceClassMinorComputerHandheld): "Handheld PC/PDA (clam shell)",
    Int(kBluetoothDeviceClassMinorComputerPalmSized): "Palm-sized PC/PDA",
    Int(kBluetoothDeviceClassMinorComputerWearable): "Wearable computer (watch sized)",
]

let BTD_CLASS_MINOR_PHONE_DESCRIPTION_DICT: NSDictionary = [
    Int(kBluetoothDeviceClassMinorPhoneUnclassified): "Specific device code not assigned",
    Int(kBluetoothDeviceClassMinorPhoneCellular): "Cellular",
    Int(kBluetoothDeviceClassMinorPhoneCordless): "Cordless",
    Int(kBluetoothDeviceClassMinorPhoneSmartPhone): "Smart phone",
    Int(kBluetoothDeviceClassMinorPhoneWiredModemOrVoiceGateway): "Wired modem or voice gateway",
    Int(kBluetoothDeviceClassMinorPhoneCommonISDNAccess): "Common ISDN Access",
]

let BTD_CLASS_MINOR_AUDIO_DESCRIPTION_DICT: NSDictionary = [
    Int(kBluetoothDeviceClassMinorAudioUnclassified): "Specific device code not assigned",
    Int(kBluetoothDeviceClassMinorAudioHeadset): "Device conforms to the Headset profile",
    Int(kBluetoothDeviceClassMinorAudioHandsFree): "Hands-free",
    Int(kBluetoothDeviceClassMinorAudioReserved1): "Reserved",
    Int(kBluetoothDeviceClassMinorAudioMicrophone): "Microphone",
    Int(kBluetoothDeviceClassMinorAudioLoudspeaker): "Loudspeaker",
    Int(kBluetoothDeviceClassMinorAudioHeadphones): "Headphones",
    Int(kBluetoothDeviceClassMinorAudioPortable): "Portable Audio",
    Int(kBluetoothDeviceClassMinorAudioCar): "Car Audio",
    Int(kBluetoothDeviceClassMinorAudioSetTopBox): "Set-top box",
    Int(kBluetoothDeviceClassMinorAudioHiFi): "HiFi Audio Device",
    Int(kBluetoothDeviceClassMinorAudioVCR): "VCR",
    Int(kBluetoothDeviceClassMinorAudioVideoCamera): "Video Camera",
    Int(kBluetoothDeviceClassMinorAudioCamcorder): "Camcorder",
    Int(kBluetoothDeviceClassMinorAudioVideoMonitor): "Video Monitor",
    Int(kBluetoothDeviceClassMinorAudioVideoDisplayAndLoudspeaker): "Video Display and Loudspeaker",
    Int(kBluetoothDeviceClassMinorAudioVideoConferencing): "Video Conferencing",
    Int(kBluetoothDeviceClassMinorAudioReserved2): "Reserved",
    Int(kBluetoothDeviceClassMinorAudioGamingToy): "Gaming/Toy",
]

let BTD_CLASS_MINOR_PERIPHERAL_DESCRIPTION_DICT: NSDictionary = [
    Int(kBluetoothDeviceClassMinorPeripheral1Keyboard): "Keyboard",
    Int(kBluetoothDeviceClassMinorPeripheral1Pointing): "Pointing device",
    Int(kBluetoothDeviceClassMinorPeripheral1Combo): "Combo keyboard/pointing device",
    Int(kBluetoothDeviceClassMinorPeripheral2Unclassified): "Uncategorized device",
    Int(kBluetoothDeviceClassMinorPeripheral2Joystick): "Joystick",
    Int(kBluetoothDeviceClassMinorPeripheral2Gamepad): "Gamepad",
    Int(kBluetoothDeviceClassMinorPeripheral2RemoteControl): "Remote control",
    Int(kBluetoothDeviceClassMinorPeripheral2SensingDevice): "Sensing device",
    Int(kBluetoothDeviceClassMinorPeripheral2DigitizerTablet): "Digitizer Tablet",
    Int(kBluetoothDeviceClassMinorPeripheral2CardReader): "Card Reader",
    Int(kBluetoothDeviceClassMinorPeripheral2DigitalPen): "Digital Pen",
    Int(kBluetoothDeviceClassMinorPeripheral2HandheldScanner): "Handheld scanner for bar-codes, RFID, etc.",
    Int(kBluetoothDeviceClassMinorPeripheral2GesturalInputDevice): "Handheld gestural input device (e.g., \"wand\" form factor)",
    Int(kBluetoothDeviceClassMinorPeripheral2AnyPointing): "Anything under MinorPeripheral1Pointing",
]

let BTD_CLASS_MINOR_IMAGING_DESCRIPTION_DICT: NSDictionary = [
    Int(kBluetoothDeviceClassMinorImaging1Display): "Display",
    Int(kBluetoothDeviceClassMinorImaging1Camera): "Camera",
    Int(kBluetoothDeviceClassMinorImaging1Scanner): "Scanner",
    Int(kBluetoothDeviceClassMinorImaging1Printer): "Printer",
    Int(kBluetoothDeviceClassMinorImaging2Unclassified): "Uncategorized, default",
]

let BTD_CLASS_MINOR_WEARABLE_DESCRIPTION_DICT: NSDictionary = [
    Int(kBluetoothDeviceClassMinorWearableWristWatch): "Watch",
    Int(kBluetoothDeviceClassMinorWearablePager): "Pager",
    Int(kBluetoothDeviceClassMinorWearableJacket): "Jacket",
    Int(kBluetoothDeviceClassMinorWearableHelmet): "Helmet",
    Int(kBluetoothDeviceClassMinorWearableGlasses): "Glasses",
]

let BTD_CLASS_MINOR_TOY_DESCRIPTION_DICT: NSDictionary = [
    Int(kBluetoothDeviceClassMinorToyRobot): "Robot",
    Int(kBluetoothDeviceClassMinorToyVehicle): "Vehicle",
    Int(kBluetoothDeviceClassMinorToyDollActionFigure): "Doll / Action Figure",
    Int(kBluetoothDeviceClassMinorToyController): "Controller",
    Int(kBluetoothDeviceClassMinorToyGame): "Game",
]

let BTD_CLASS_MINOR_HEALTH_DESCRIPTION_DICT: NSDictionary = [
    Int(kBluetoothDeviceClassMinorHealthUndefined): "Undefined",
    Int(kBluetoothDeviceClassMinorHealthBloodPressureMonitor): "Blood Pressure Monitor",
    Int(kBluetoothDeviceClassMinorHealthThermometer): "Thermometer",
    Int(kBluetoothDeviceClassMinorHealthScale): "Scale",
    Int(kBluetoothDeviceClassMinorHealthGlucoseMeter): "Glucose Meter",
    Int(kBluetoothDeviceClassMinorHealthPulseOximeter): "Pulse Oximeter",
    Int(kBluetoothDeviceClassMinorHealthHeartRateMonitor): "Heart Rate Monitor",
    Int(kBluetoothDeviceClassMinorHealthDataDisplay): "Display",
]

let BTD_CLASS_DESCRIPTION_DICT: NSDictionary = [
    Int(kBluetoothDeviceClassMajorMiscellaneous): BTD_CLASS_DICT_EMPTY,
    Int(kBluetoothDeviceClassMajorComputer): BTD_CLASS_MINOR_COMPUTER_DESCRIPTION_DICT,
    Int(kBluetoothDeviceClassMajorPhone): BTD_CLASS_MINOR_PHONE_DESCRIPTION_DICT,
    Int(kBluetoothDeviceClassMajorLANAccessPoint): BTD_CLASS_DICT_EMPTY,
    Int(kBluetoothDeviceClassMajorAudio): BTD_CLASS_MINOR_AUDIO_DESCRIPTION_DICT,
    Int(kBluetoothDeviceClassMajorPeripheral): BTD_CLASS_MINOR_PERIPHERAL_DESCRIPTION_DICT,
    Int(kBluetoothDeviceClassMajorImaging): BTD_CLASS_MINOR_IMAGING_DESCRIPTION_DICT,
    Int(kBluetoothDeviceClassMajorWearable): BTD_CLASS_MINOR_WEARABLE_DESCRIPTION_DICT,
    Int(kBluetoothDeviceClassMajorToy): BTD_CLASS_MINOR_TOY_DESCRIPTION_DICT,
    Int(kBluetoothDeviceClassMajorHealth): BTD_CLASS_MINOR_HEALTH_DESCRIPTION_DICT,
    Int(kBluetoothDeviceClassMajorUnclassified): BTD_CLASS_DICT_EMPTY,
]
