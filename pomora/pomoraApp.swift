//
//  pomoraApp.swift
//  pomora
//
//  Created by Amanda Lee on 8/22/26.
//
//App's entry point, the @main struct is what iOS launches first when the app opens

import SwiftUI
import SwiftData

@main
struct pomoraApp: App {
    //sets up swiftdata's storage container for the item model
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .tint(.PBrown)
                .foregroundStyle(Color.PBrown)
                .background(Color.background)
        }
        .modelContainer(sharedModelContainer)
    }
}
