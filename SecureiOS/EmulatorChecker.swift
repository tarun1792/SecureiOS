//
//  EmulatorChecker.swift
//  SecureiOS
//
//  Created by Tarun Kaushik on 20/02/22.
//  Copyright © 2022 Tarun Kaushik. All rights reserved.
//

import Foundation

internal class EmulatorChecker {
    
    static func emulatorCheck() -> Bool{
        return checkRuntime() || checkCompile()
    }
    
    private static func checkRuntime() -> Bool {
        return ProcessInfo().environment["SIMULATOR_DEVICE_NAME"] != nil
    }

    private static func checkCompile() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}
