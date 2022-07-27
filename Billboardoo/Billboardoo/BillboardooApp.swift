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
    @AppStorage("isDarkMode") var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "isDarkMode")
    @StateObject var router = TabRouter()
    
    
    var body: some Scene {
        WindowGroup {
            MainScreenView().onAppear{
                changeMode(isDarkMode: isDarkMode) //보여질 때 다크모드 확인 이벤트 등록
                //네트워크 등록
            }

            
            
            
        }
    }
}


func changeMode(isDarkMode:Bool)
{
    if let window = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        if #available(iOS 15.0, *) {
            let windows = window.windows.first
            windows?.overrideUserInterfaceStyle = isDarkMode  == true ? .dark : .light
            
        }
    } else if let window = UIApplication.shared.windows.first {
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = isDarkMode == true ? .dark : .light
        } else { //IOS 13 미만은 dark모드 불가
            window.overrideUserInterfaceStyle = .light
        }
    }
}
