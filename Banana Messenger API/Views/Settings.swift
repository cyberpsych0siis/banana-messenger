//
//  Settings.swift
//  Banana Messenger API
//
//  Created by Philipp Gaßner on 10.05.22.
//

import SwiftUI

struct Settings: View {
    var body: some View {
        Button(action: logout) {
            Text("Logout")
        }
    }
    
    func logout() {
        Ajax.shared.logout()
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
