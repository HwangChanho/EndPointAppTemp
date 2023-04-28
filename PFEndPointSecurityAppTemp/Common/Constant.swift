//
//  Constant.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/04/20.
//

import Foundation

enum Constant {
    enum AppKey {
        static let PF_ES_EXTENSION_ID = "com.jiran.pcfilter.esextension"
        static let APP_ID             = "PFEndPointSecurityApp"
        static let ALIAS_FILE_ID      = "com.apple.alias-file"
    }
    
    enum NSKey {
        static let KEY_NETWORK_EXTENSION              = "NetworkExtension"
        static let KEY_NE_MACH_SERVICE_NAME           = "NEMachServiceName"
        static let KEY_ENDPOINT_SECURITY_MACH_NAME    = "NSEndpointSecurityMachServiceName"
    }
}
