//
//  Messages.swift
//  Banana Messenger API
//
//  Created by Philipp Gaßner on 09.05.22.
//

import SwiftUI

struct MessagesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var messages: FetchedResults<BMessage>
    
    @State var showComposeScreen = false
    
    var body: some View {
//        NavigationView {
//        .onAppear() {
//            print("Ajax.shared.isLoggedIn: \(Ajax.shared.isLoggedIn)")
//            Ajax.shared.fetch(type: [MessageFromServer].self, suffix: "/messages/inbox") {
//                messages in
//
//                insertNewMessages(messages)
//            }
//        }
        NavigationView {
            List {
                ForEach(messages) {
                    message in
                    NavigationLink(message.fromUser!) {
                        Text(message.body!)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                Button("Add") {
                    showComposeScreen.toggle()
                }
            }
            
        }
        .onAppear() {
            print("Ajax.shared.isLoggedIn: \(Ajax.shared.isLoggedIn)")
            Ajax.shared.fetch(type: [MessageFromServer].self, suffix: "/messages/inbox") {
                messages in
    insertNewMessages(messages)
            }
        }
        .sheet(isPresented: $showComposeScreen) {
            ComposeMessage(showMe: showComposeScreen)
        }
    }
    
    func logMeOut() {
        Ajax.shared.logout()
    }
    
    func insertNewMessages(_ messages: [MessageFromServer]) {
        print(messages)
        
        messages.forEach {
            m in
            
            print(m)
            
            let savedMessage = BMessage(context: viewContext)
            savedMessage.id = UUID()
            savedMessage.fromUser = m.fromUser
            savedMessage.body = m.textBody

            savedMessage.timestamp = Date.now
            do {
                try self.viewContext.save()
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { messages[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch let error {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                print(error.localizedDescription)
                return
            }
        }
    }
    
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
