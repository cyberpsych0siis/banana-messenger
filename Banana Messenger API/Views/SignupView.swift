//
//  SignupView.swift
//  Banana Messenger API
//
//  Created by Philipp Gaßner on 09.05.22.
//

import SwiftUI

struct SignupView: View {
    @State var username: String = ""
    @State var password: String = ""
    @Binding var isShown: Bool
    var ajax: Ajax
    
    var body: some View {
        VStack {
            Spacer()
            
                Text("Create new Account")
                VStack {
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                        .textFieldStyle(.roundedBorder)
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                }
                .padding()
            Spacer()
            Button(action: signup) {
                Text("Signup")
            }
                .disabled(username == "" && password == "")
                .buttonStyle(.borderedProminent)
            Spacer()
        }
    }
    
    func signup() {
        ajax.signup(username: username, password: password)
        self.isShown.toggle()
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(isShown: .constant(true), ajax: Ajax())
    }
}
