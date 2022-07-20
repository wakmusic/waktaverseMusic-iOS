//
//  BillboardooApp.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/18.
//

import SwiftUI
import RxSwift
@main
struct BillboardooApp: App {
    let persistenceController = PersistenceController.shared
    var setting:Setting = Setting()
    var body: some Scene {
        WindowGroup {
            MainScreenView()
                .environmentObject(setting)
        }
    }
}
