//
//  moodyApp.swift
//  moody
//
//  Created by 김두리 on 2021/06/18.
//

import SwiftUI

@main
struct moodyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
