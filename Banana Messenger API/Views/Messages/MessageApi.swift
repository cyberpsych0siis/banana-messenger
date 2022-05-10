//
//  MessageApi.swift
//  Banana Messenger API
//
//  Created by Philipp Gaßner on 10.05.22.
//

import Foundation

extension Ajax {
    func sendMessage(to: String, msg: String) {
        
        //encryption here
        
        let args = ["msg": msg]
        self.push(type: MessageFromServer.self, suffix: "/messages/\(to)", arguments: args) {
            data in
            print(data)
        }
    }
}
