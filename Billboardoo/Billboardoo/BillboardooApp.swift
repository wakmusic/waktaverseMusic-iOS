//
//  BillboardooApp.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/18.
//

import SwiftUI

@main
struct BillboardooApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
        }
    }
}
