//
//  Ajax.swift
//  Banana Messenger API
//
//  Created by Philipp Gaßner on 09.05.22.
//

import Foundation
import KeychainAccess

class Ajax: ObservableObject {
    static let shared = Ajax()
    @Published var keychain = Keychain(service: "nft.cyberpsych0siis.Banana-Messenger-API")
    
//#if DEBUG
    // Debug-only code
//    var serverUrl = "http://localhost:8080"
//#else
    var serverUrl = "https://rillo5000.com"
//#endif
    
    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    
    init() {
        let auth = keychain["accessToken"]
        
        self.isLoggedIn = auth != nil
        print(self.isLoggedIn)
    }
    
    func fetch<T: Codable>(type: T.Type, suffix: String, _ callback: @escaping (T) -> ()) {
        sendRequest(type: type, suffix: suffix, body: nil, callback)
    }
    
    func push<T: Codable>(type: T.Type, suffix: String, arguments: [String: String], _ callback: @escaping (T) ->()) {
        sendRequest(type: type, suffix: suffix, body: arguments, callback)
    }
    
    private func sendRequest<T: Codable>(type: T.Type, suffix: String, body: [String: String]?, _ cb: @escaping (T) -> ()) {
        guard let url = URL(string: "\(serverUrl)\(suffix)") else {
            print("Failed with: InvalidUrl")
            return
        }
        
        var r = URLRequest(url: url)
        if body != nil {
            r.httpMethod = "POST"
            r.httpBody = try! JSONEncoder().encode(body!)
        } else {
            r.httpMethod = "GET"
        }
        
        let auth = keychain[string: "accessToken"]
        if auth != nil {
            print("Auth token")
            r.setValue("Bearer \(auth!)", forHTTPHeaderField: "Authorization")
        }
        r.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("Sending request to \(r.url!)")
        
        URLSession.shared.dataTask(with: r) {
            data, response, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            
            do {
                let s = try decoder.decode(ServerAnswer<T>.self, from: data)
                if s.success {
                    print("[sendRequest] Success!")
                    cb(s.successData!)
                    return
                } else {
                    print(s.errorData!)
                    return
                }
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        .resume()
    }
}

extension Ajax {
    func login(username: String, password: String) {
        let args = ["username": username, "password": password]

        self.push(type: LoginToken.self, suffix: "/login", arguments: args) {
            data in
            print("[Login] Success!")
            self.isLoggedIn = true
            
            self.keychain["accessToken"] = data.token
            
            Ajax.shared.isLoggedIn = true
        }
    }
    
    func logout() {
        self.isLoggedIn = false
        Ajax.shared.isLoggedIn = false
        self.keychain["accessToken"] = nil
    }
    
    func signup(username: String, password: String) {
        let key = EncryptionLibrary.retrievePublicKey()
        
        let args = ["username": username, "password": password, "publickey": key]
        self.push(type: LoginToken.self, suffix: "/register", arguments: args) {
            data in
            print(data.token)
            self.keychain["accessToken"] = data.token
            self.isLoggedIn = true
            Ajax.shared.isLoggedIn = true
        }
    }
}
