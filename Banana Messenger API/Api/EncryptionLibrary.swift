//
//  EncryptionLibrary.swift
//  Auth0Test
//
//  Created by Philipp Gaßner on 30.04.22.
//

import Foundation
import LocalAuthentication

class EncryptionLibrary {
    var shared = EncryptionLibrary()
    
    init() {
        EncryptionLibrary.generateKeys()
    }
    
    func encrypt(receiverPublicKey: String, cleartextMessage: String) -> String{
        
        let encrypted = CryptoSingleton.sharedInstance.encryptECCPubKeySupplied(message: cleartextMessage, externalKeyB64String: receiverPublicKey)
        
        let signString =
                    CryptoSingleton.sharedInstance.signECCPrivKey(message: encrypted)
                print("signString", signString)
        
        return encrypted + ":" + signString
    }
    
    func decrypt(senderPublicKey: String, encryptedMessage: String) {
        let encryptedArray = encryptedMessage.components(separatedBy: ":")
        
        if encryptedArray.count == 2 {
            let encryptString = encryptedArray[0]
            let signString = encryptedArray[1]
            
            if CryptoSingleton.sharedInstance.verifySignECCPubKeySupplied(message: encryptString, signatueString: signString, externalKeyB64String: senderPublicKey) {
                
                CryptoSingleton.sharedInstance.decryptECCPrivKey(encryptedString: encryptString)
            }
        } else {
            print("failed to parse", encryptedArray.count, encryptedMessage)
            for stringElem in encryptedArray {
                print(stringElem)
            }
        }
    }
    
    static func generateKeys() -> ClientKeys {
        let eccKeys = CryptoSingleton.sharedInstance.generateECCKeys()
        let eccSignKeys = CryptoSingleton.sharedInstance.generateECCSignKeys()
        
        let keys = ClientKeys(eccKey: eccKeys, eccSignKey: eccSignKeys)
        print(keys)
        return keys
    }
    
    static func retrievePublicKey() -> String {
        let keys = generateKeys()
        return keys.eccKey
    }
    
//    static func retrieveSharablePublicKey() -> String {
////        if Api.shared.username == "" { return nil; }
//        return "retrievePublicKey"
//    }
    
//    static func registerOnServer(username: String) {
//        let k = generateKeys()
//
//        print(k)
//
//        Aj.shared.sendRequest(suffix: "/register_device", body: ["publicKey": k.eccKey, "username": username]) {
//            response in
//            print(response)
//        }
//    }
}
