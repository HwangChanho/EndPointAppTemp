//
//  CloudDefine.swift
//  PFEndPointSecurityAppTemp
//
//  Created by AlexHwang on 2023/05/22.
//

import Foundation

let CLOUD_STORAGE_APP: [PFSAppInfoFlags] = [
            PFSAppInfoFlags("com.apple.bird", "/System/Library/PrivateFrameworks/CloudDocsDaemon.framework/Versions/A/Support/bird", 0x208005, true),
            PFSAppInfoFlags("com.apple.cloudphotod", "/System/Library/PrivateFrameworks/CloudPhotoLibrary.framework/Versions/A/Support/cloudphotod", 0x1, true),
            PFSAppInfoFlags("com.auguronsystems.mobile", "/Applications/Auguron.app/Contents/MacOS/Auguron", 0x1, true),
            PFSAppInfoFlags("com.i-smartsolutions.mRainbow", "/Applications/Rainbow.app/Contents/MacOS/Rainbow", 0x1, true),
            PFSAppInfoFlags("com.microsoft.OneDrive-mac", "/Applications/OneDrive.app/Contents/MacOS/OneDrive", 0x1, true),
            PFSAppInfoFlags("com.promise.ApolloExt", "/Applications/Apollo Cloud.app/Contents/MacOS/Apollo Cloud", 0x1, true),
            PFSAppInfoFlags("com.rackspace.apps.mac.clouddrive", "/Applications/Rackspace Cloud Drive.app/Contents/MacOS/Rackspace Cloud Drive", 0x1, true),
            PFSAppInfoFlags("com.rackspace.apps.mac.clouddrive-wl", "/Applications/Cloud Drive Desktop.app/Contents/MacOS/Cloud Drive Desktop", 0x1, true),
            PFSAppInfoFlags("com.jio.cloud.mac", "/Applications/JioCloud.app/Contents/MacOS/JioCloud", 0x1, true),
            PFSAppInfoFlags("maccatalyst.net.icedrive.app", "/Applications/Icedrive.app/Contents/MacOS/Icedrive", 0x1, true),
            PFSAppInfoFlags("yizhuo.gfile", "/Applications/Share Docs for Google Drive.app/Contents/MacOS/Share Docs for Google Drive", 0x1, true),
]
