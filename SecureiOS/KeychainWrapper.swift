//
//  KeychainFacade.swift
//  SecureiOS
//
//  Created by Tarun Kaushik on 28/02/22.
//  Copyright © 2022 Tarun Kaushik. All rights reserved.
//

import Foundation
enum KeychainWrapperError: Error{
    case keyGenerationError(String)
    case failure(status: OSStatus)
    case noPublicKey
    case noPrivateKey
    case unsupported(algorithm: SecKeyAlgorithm)
    case unsupportedInput
    case forwarded(Error)
    case unknown
}

extension KeychainWrapperError: LocalizedError {
    public var errorDescription: String? {
        switch self  {
        case .keyGenerationError(let value):
            return "Key Generation Error : \(value)"
        case .failure(let osStatus):
            return osStatus.description
        case .noPublicKey:
            return "No public key available"
        case .noPrivateKey:
            return "No private key available"
        case .unsupported(_):
            return "unsupportted algorithem"
        case .unsupportedInput:
            return "Input type is not supported"
        case .forwarded(_):
            return "Forward error"
        case .unknown:
            return "unknown error"
        }
    }
}


class KeychainWrapper {
    private static let tag = "com.secureios.keys.mykey".data(using: .utf8)!
    private let attributes: [String:Any] = [kSecAttrType as String: kSecAttrKeyTypeRSA,
                                                       kSecAttrKeySizeInBits as String: 2048,
                                                      kSecAttrApplicationTag as String:tag,
                                                      kSecPrivateKeyAttrs as String: [kSecAttrIsPermanent as String: true]]
    
    lazy var privateKey: SecKey? = {
        guard let key = try? retreivePrivateKey() else {
            return try? generatePrivateKey()
        }
        return key
    }()
    
    lazy var publicKey: SecKey? = {
        guard let key = privateKey else {
            return nil
        }
        return SecKeyCopyPublicKey(key)
    }()
    
    private func generatePrivateKey() throws -> SecKey {
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            if let generationError = error?.takeRetainedValue(){
                throw KeychainWrapperError.keyGenerationError(generationError.localizedDescription)
            }else{
                throw KeychainWrapperError.keyGenerationError("Something went wrong")
            }
        }
        return privateKey
    }
    
    private func retreivePrivateKey() throws -> SecKey? {
        let privateKeyQuery: [String : Any] = [kSecClass as String: kSecClassKey,
                                               kSecAttrApplicationTag as String: KeychainWrapper.tag,
                                               kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                                               kSecReturnRef as String: true]
        var privateKeyRef: CFTypeRef?
        let status = SecItemCopyMatching(privateKeyQuery as CFDictionary, &privateKeyRef)
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                return nil
            }else{
                throw KeychainWrapperError.failure(status: status)
            }
        }
        return privateKeyRef != nil ? (privateKeyRef as! SecKey) : nil
    }
    
    func encrypt(text: String) throws -> Data? {
        guard let secKey = publicKey else {
            throw KeychainWrapperError.noPublicKey
        }
        
        let algorithm = SecKeyAlgorithm.rsaEncryptionOAEPSHA512
        
        guard SecKeyIsAlgorithmSupported(secKey, .encrypt, algorithm) else {
            throw KeychainWrapperError.unsupported(algorithm: algorithm)
        }
        
        guard let textData = text.data(using: .utf8) else {
            throw KeychainWrapperError.unsupportedInput
        }
        
        var error: Unmanaged<CFError>?
        guard let encryptedTextData = SecKeyCreateEncryptedData(secKey, algorithm, textData as CFData, &error) as Data? else {
            if let encryptionError = error {
                throw KeychainWrapperError.forwarded(encryptionError.takeRetainedValue() as Error)
            }else{
                throw KeychainWrapperError.unknown
            }
        }
        
        return encryptedTextData
    }
    
    func decrypt(data: Data) throws -> Data? {
        
        guard let secKey = privateKey else {
            throw KeychainWrapperError.noPrivateKey
        }
        
        let algorithm = SecKeyAlgorithm.rsaEncryptionOAEPSHA512
        
        guard SecKeyIsAlgorithmSupported(secKey, .decrypt, algorithm) else {
            throw KeychainWrapperError.unsupported(algorithm: algorithm)
        }
        
        var error: Unmanaged<CFError>?
        guard let decryptedData = SecKeyCreateDecryptedData(secKey, algorithm, data as CFData, &error) as Data? else{
            if let decruptionError = error {
                throw KeychainWrapperError.forwarded(decruptionError.takeRetainedValue() as Error)
            }else{
                throw KeychainWrapperError.unknown
            }
        }
        return decryptedData
    }
}
