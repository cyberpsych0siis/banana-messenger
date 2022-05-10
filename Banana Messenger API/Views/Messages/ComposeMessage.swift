//
//  ComposeMessage.swift
//  Banana Messenger API
//
//  Created by Philipp Gaßner on 10.05.22.
//

import SwiftUI

struct ComposeMessage: View {
    @State var to: String = ""
    @State var textBody: String = ""
    @State var showMe: Bool
    var body: some View {
        Form {
            TextField("To", text: $to)
            TextEditor(text: $textBody)
            Button("Send") {
                Ajax.shared.sendMessage(to: to, msg: textBody)
            }
        }
    }
}

struct ComposeMessage_Previews: PreviewProvider {
    static var previews: some View {
        ComposeMessage(showMe: true)
    }
}
