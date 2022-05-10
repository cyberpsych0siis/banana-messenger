//
//  MainView.swift
//  Banana Messenger API
//
//  Created by Philipp Gaßner on 09.05.22.
//

import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var username: String = "root"
    @State var password: String = "root"
    @State var showSignupSheet: Bool = false
    @ObservedObject var ajax = Ajax()
    
    var body: some View {
        VStack {
            if ajax.isLoggedIn {
//                VStack {
//                    Spacer()
//                    Text("You are logged in!")
//
//                    Spacer()
//
//                    Button(action: doSomething) {
//                        Text("Send test request")
//                    }
//
//                    Spacer()
//
//                    Button(action: logout) {
//                        Text("Logout")
//                    }
//
//                    Spacer()
//                }
                TabView {
                    MessagesView()
                        .tabItem {
                            VStack {
                             Image(systemName: "message")
                                Text("Messages")
                            }
                        }
                        .tag(0)
                    Settings()
                        .tabItem {
                            VStack {
                                Image(systemName: "gear")
                                Text("Settings")
                            }
                        }
                }
                
            } else {
                VStack {
                    Spacer()
                    
                    Text("Banana Messenger")
                        .bold()
                        .dynamicTypeSize(.accessibility1)
                    
                    Spacer()
                    
                    VStack {
                        TextField("Username", text: $username)
                            .autocapitalization(.none)
                            .textFieldStyle(.roundedBorder)
                        SecureField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: login) {
                        Text("Login")
                    }
                    .disabled(username == "" && password == "")
                    .buttonStyle(.borderedProminent)

                    Button(action: showSignup) {
                        Text("Signup")
                    }
                    
                    Spacer()
                }
            }
        }
        .sheet(isPresented: self.$showSignupSheet) {
            SignupView(isShown: self.$showSignupSheet, ajax: self.ajax)
        }
    }
    
    func showSignup() {
        self.showSignupSheet.toggle()
    }
    
    func login() {
        ajax.login(username: username, password: password)
    }
    
    func logout() {
        ajax.logout()
    }
    
    func doSomething() {
        Ajax.shared.fetch(type: TestReply.self, suffix: "/nocrash") {
            data in
            print(data.msg)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


