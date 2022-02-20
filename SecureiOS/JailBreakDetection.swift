//
//  JailBreakDetection.swift
//  SecureiOS
//
//  Created by Tarun Kaushik on 29/08/20.
//  Copyright © 2020 Tarun Kaushik. All rights reserved.
//

import Foundation

internal class JailBreakDetection{
    // do something here
    
    internal static func check()->Bool{        
        let suspicousFileCheck = suspicousFilesCheck()
        let privateDirectories = restrictedDirectoriesWriteableCheck()
        let checkSuspiciousFilesCanOpen = checkSuspiciousFilesCanBeOpened()
        let checkRestrictedDirectorieWriteable = checkRestrictedDirectoriesWriteable()
        
        return suspicousFileCheck || privateDirectories || checkSuspiciousFilesCanOpen || checkRestrictedDirectorieWriteable
    }
    
    private static func suspicousFilesCheck()->Bool{
        
        let paths = [
            "/usr/sbin/frida-server",
            "/etc/apt/sources.list.d/electra.list",
            "/etc/apt/sources.list.d/sileo.sources",
            "/.bootstrapped_electra",
            "/usr/lib/libjailbreak.dylib",
            "/jb/lzma",
            "/.cydia_no_stash",
            "/.installed_unc0ver",
            "/jb/offsets.plist",
            "/usr/share/jailbreak/injectme.plist",
            "/etc/apt/undecimus/undecimus.list",
            "/var/lib/dpkg/info/mobilesubstrate.md5sums",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/jb/jailbreakd.plist",
            "/jb/amfid_payload.dylib",
            "/jb/libjailbreak.dylib",
            "/usr/libexec/cydia/firmware.sh",
            "/var/lib/cydia",
            "/etc/apt",
            "/private/var/lib/apt",
            "/private/var/Users/",
            "/var/log/apt",
            "/Applications/Cydia.app",
            "/private/var/stash",
            "/private/var/lib/apt/",
            "/private/var/lib/cydia",
            "/private/var/cache/apt/",
            "/private/var/log/syslog",
            "/private/var/tmp/cydia.log",
            "/Applications/Icy.app",
            "/Applications/MxTube.app",
            "/Applications/RockApp.app",
            "/Applications/blackra1n.app",
            "/Applications/SBSettings.app",
            "/Applications/FakeCarrier.app",
            "/Applications/WinterBoard.app",
            "/Applications/IntelliScreen.app",
            "/private/var/mobile/Library/SBSettings/Themes",
            "/Library/MobileSubstrate/CydiaSubstrate.dylib",
            "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
            "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
            "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
            "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist"
        ]
        
        
        for path in paths{
            if FileManager.default.fileExists(atPath: path){
                return true
            }
        }
        
        return false
    }
    
    
    
    private static func restrictedDirectoriesWriteableCheck()->Bool{
        
        let paths = [
            "/",
            "/root/",
            "/private/",
            "/jb/"
        ]
        
        // Checks if the restricted directories are writeable.
        for path in paths{
            do{
                let filePath = path + UUID().uuidString
                try "i escaped the Jail".write(toFile: filePath, atomically: true, encoding: .utf8)
                try FileManager.default.removeItem(atPath: filePath)
                return true
            }catch let error{print(error.localizedDescription)}
        }
         return false
    }
    
    private static func checkSuspiciousFilesCanBeOpened() -> Bool{

        let paths = [
            "/.installed_unc0ver",
            "/.bootstrapped_electra",
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/etc/apt",
            "/var/log/apt"
        ]

        for path in paths {

            if FileManager.default.isReadableFile(atPath: path) {
                return false
            }
        }

        return true
    }
    
    
    private static func checkRestrictedDirectoriesWriteable() -> Bool {

         let paths = [
             "/",
             "/root/",
             "/private/",
             "/jb/"
         ]

         // If library won't be able to write to any restricted directory the return(false, ...) is never reached
         // because of catch{} statement
         for path in paths {
             do {
                 let pathWithSomeRandom = path+UUID().uuidString
                 try "AmIJailbroken?".write(toFile: pathWithSomeRandom, atomically: true, encoding: String.Encoding.utf8)
                 try FileManager.default.removeItem(atPath: pathWithSomeRandom) // clean if succesfully written
                 return false
             } catch {}
         }

         return true
     }
    
}
