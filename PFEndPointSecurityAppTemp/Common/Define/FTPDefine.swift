//
//  FTPDefine.swift
//  PFEndPointSecurityAppTemp
//
//  Created by AlexHwang on 2023/05/22.
//

import Foundation

let FTP_APP: [PFSAppInfoFlags] = [
PFSAppInfoFlags("ch.sudo.cyberduck", "/Applications/Cyberduck.app/Contents/MacOS/Cyberduck", 0x1, true),
PFSAppInfoFlags("com.apple.sftp", "/usr/bin/sftp", 0x1, true),
PFSAppInfoFlags("com.binarynights.ForkLift2", "/Applications/ForkLift.app/Contents/MacOS/ForkLift", 0x1, true),
PFSAppInfoFlags("com.panic.transmit.mas", "/Applications/Transmit.app/Contents/MacOS/Transmit", 0x1, true),
PFSAppInfoFlags("com.skyjos.fileexplorerfree", "/Applications/Owlfiles.app/Contents/MacOS/Owlfiles", 0x1, true),
PFSAppInfoFlags("org.filezilla-project.filezilla", "/Applications/FileZilla.app/Contents/MacOS/filezilla", 0x1, true),
PFSAppInfoFlags("org.filezilla-project.filezilla.sandbox", "/Applications/FileZilla Pro.app/Contents/MacOS/filezilla", 0x1, true)
]

