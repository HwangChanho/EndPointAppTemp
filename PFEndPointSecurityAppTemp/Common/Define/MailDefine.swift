//
//  MainDefine.swift
//  PFEndPointSecurityAppTemp
//
//  Created by AlexHwang on 2023/05/22.
//

import Foundation

let MAIL_APP: [PFSAppInfoFlags] = [
            PFSAppInfoFlags("com.apple.mail", "/System/Applications/Mail.app/Contents/MacOS/Mail", 0x01, true),
            PFSAppInfoFlags("com.edisonmail.edisonmail", "/Applications/Edison Mail.app/Contents/MacOS/Edison Mail", 0x01, false),
            PFSAppInfoFlags("com.edisonmail.edisonmail.helper", "/Applications/Edison Mail.app/Contents/Frameworks/Edison Mail Helper (Renderer).app/Contents/MacOS/Edison Mail Helper (Renderer)", 0x01, true),
            PFSAppInfoFlags("com.microsoft.Outlook", "/Applications/Microsoft Outlook.app/Contents/MacOS/Microsoft Outlook", 0x01, true),
            PFSAppInfoFlags("com.readdle.smartemail-Mac", "/Applications/Spark.app/Contents/MacOS/Spark", 0x01, true),
            PFSAppInfoFlags("com.rockysandstudio.DeskApp-for-Gmail", "/Applications/Mail for Gmail.app/Contents/MacOS/Mail for Gmail", 0x01, false),
            PFSAppInfoFlags("com.sovapps.gmailnotifier", "/Applications/Mia for Gmail.app/Contents/MacOS/Mia for Gmail", 0x01, true),
            PFSAppInfoFlags("com.CloudMagic.MacMail", "/Applications/Newton.app/Contents/MacOS/Newton", 0x01, false),
            PFSAppInfoFlags("com.CloudMagic.MacMail.helper.Renderer", "/Applications/Newton.app/Contents/Frameworks/Newton Helper (Renderer).app/Contents/MacOS/Newton Helper (Renderer)", 0x01, true),
            PFSAppInfoFlags("io.canarymail.mac", "/Applications/Canary Mail.app/Contents/MacOS/Canary Mail", 0x01, true),
            PFSAppInfoFlags("it.bloop.airmail2", "/Applications/Airmail.app/Contents/MacOS/Airmail", 0x01, true),
]
