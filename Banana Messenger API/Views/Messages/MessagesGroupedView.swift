//
//  MessagesGroupedView.swift
//  Banana Messenger API
//
//  Created by Philipp Gaßner on 11.05.22.
//

import SwiftUI
import CoreData

struct MessagesGroupedView: View {
    @Environment(\.managedObjectContext) private var moc
    @State var results: [BMessage]? = nil
    
    var body: some View {
        List {
//            ForEach() {
//                r in
                
//            }
        }
        .onAppear {
            let request = BMessage.fetchRequest()
            request.returnsObjectsAsFaults = false
            request.propertiesToGroupBy = ["fromUser"]
            request.propertiesToFetch = ["fromUser"]
            request.resultType = .dictionaryResultType
            

            do {
                var res: [BMessage] = try moc.fetch(request) as [BMessage]
                print(res[0])
//                results = res
            } catch let error {
                print(error.localizedDescription)
                return
            }

        }
    }
}

struct MessagesGroupedView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesGroupedView()
    }
}
