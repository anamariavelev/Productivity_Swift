//
//  VisionOSToDoAppApp.swift
//  VisionOSToDoApp
//
//  Created by Ana Maria Velev on 21.06.2024.
//

import SwiftUI

@main
struct VisionOSToDoAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
