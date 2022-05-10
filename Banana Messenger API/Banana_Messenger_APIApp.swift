//
//  Banana_Messenger_APIApp.swift
//  Banana Messenger API
//
//  Created by Philipp Gaßner on 09.05.22.
//

import SwiftUI

@main
struct Banana_Messenger_APIApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
