//
//  SecureUserDefault.swift
//  SecureiOS
//
//  Created by Tarun Kaushik on 15/09/20.
//  Copyright © 2020 Tarun Kaushik. All rights reserved.
//

import Foundation
import UIKit
import CryptoKit

public class SecureUserDefaults{
    
    private static let iv = ChaChaPoly.Nonce()
    private static let key = SymmetricKey(size: .bits256)
    
    public init(){}
    
    public static var standard:SecureUserDefaults {return SecureUserDefaults()}
    
    private func getKey(){
        let string = SHA256.hash(data: "password".data(using:.utf8)!)
      //  let data = string.data(using:.utf8)
        print(string)
       // print(data)
    }
    
    public func saveData(forKey key:String,value:String){
        getKey()
        let userDefault = UserDefaults.standard
        // Perform some private encryption logic here
        if let data = self.encryptData(value:value) {
             // finish the encrption
            userDefault.setValue(data, forKey: key)
        }
    }
    
    public func getData(for key:String) -> String?{
        let userDefault = UserDefaults.standard
        
        if let data = userDefault.value(forKey: key) as? Data{
            // perform some decryption logic here
            let decryptedString = self.decryptData(data:data)
            // finshed getting the decoded data
            return decryptedString
        }
    
       return nil
    }
    
    
    private func encryptData(value:String)->Data?{
        var encryptData:Data?
        
        do
        {
            let dataToEncrypt = value.data(using: .utf8)
            let secureSealBox = try ChaChaPoly.seal(dataToEncrypt!,using:SecureUserDefaults.key,nonce:SecureUserDefaults.iv)
            encryptData = secureSealBox.combined
        }catch{
            print("catch: \(error)")
        }
        
        return encryptData
    }
    
    private func decryptData(data:Data)->String?{
       
        var decryptedString:String?
        
        print(data)

        let sealedBoxToOpen = try! ChaChaPoly.SealedBox(combined: data)
    
        do {
            let decryptedData = try ChaChaPoly.open(sealedBoxToOpen, using: SecureUserDefaults.key)
            if let decryptedStr = String(data: decryptedData, encoding: .utf8){
                decryptedString = decryptedStr
            }
        }catch{
            print("catch",error)
        }

        return decryptedString
    }
    
}

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}
