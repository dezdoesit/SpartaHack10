//
//  InterViewApp.swift
//  InterView
//
//  Created by Dezmond Blair on 2/1/25.
//

import SwiftUI

@main
struct InterViewApp: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }

    }
}
