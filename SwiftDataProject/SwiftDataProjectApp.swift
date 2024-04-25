//
//  SwiftDataProjectApp.swift
//  SwiftDataProject
//
//  Created by Kenneth Oliver Rathbun on 4/23/24.
//

import SwiftUI

@main
struct SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
