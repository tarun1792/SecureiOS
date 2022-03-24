//
//  BiometricControls.swift
//  SecureiOS
//
//  Created by Tarun Kaushik on 24/03/22.
//  Copyright © 2022 Tarun Kaushik. All rights reserved.
//

import Foundation
import LocalAuthentication

public struct BiometryStatus{
    public let isEnabled: Bool
    public let type: LockAndBiometryType
}

public enum LockAndBiometryType {
    case touchId
    case faceId
    case passcode
    case none
    
    public var name: String {
        switch self {
        case .faceId:
            return "Face ID"
        case .touchId:
            return "Touch ID"
        case .passcode:
            return "Passcode"
        case .none:
            return ""
        }
    }
}

public enum BiometryType {
    case touchId
    case faceId
    case none
    
    public var name: String {
        switch self {
        case .faceId:
            return "Face ID"
        case .touchId:
            return "Touch ID"
        case .none:
            return ""
        }
    }
}

class BiometricControl {
    
    private let context = LAContext()
    var supportedBiometryType: BiometryType {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) //need to call canEvaluatePolicy before checking biometryType
        let supportedBiometry = context.biometryType
        switch supportedBiometry {
        case .faceID: return .faceId
        case .touchID: return .touchId
        case .none: return .none
        default: return .none
        }
    }
    
    private func checkBiometryStatus() -> Bool{
        let isBiometryEnabled = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return isBiometryEnabled
    }
    
    private func checkPasscodeStatus() -> Bool{
        let isPasscodeEnabled = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        return isPasscodeEnabled
    }
    
    func checkDeviceLockAndBiomtryStatus() -> BiometryStatus{
        if (supportedBiometryType != .none) && checkBiometryStatus(){
            switch supportedBiometryType{
            case .touchId:
                return BiometryStatus(isEnabled: true, type: .touchId)
            case .faceId:
                return BiometryStatus(isEnabled: true, type: .faceId)
            case .none:
                break
            }
        }else if checkPasscodeStatus(){
            return BiometryStatus(isEnabled: true, type: .passcode)
        }
        return BiometryStatus(isEnabled: false, type: .none)
    }
}

