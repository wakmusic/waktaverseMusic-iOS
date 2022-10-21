//
//  BillboardooApp.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/18.
//

import SwiftUI
import UIKit
import Foundation
import FirebaseCore
import Kingfisher

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct WaktaverseMusicApp: App {
    @Environment(\.scenePhase) var scenePhase
    @AppStorage("isDarkMode") var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "isDarkMode")

    var playState = PlayState.shared

    // register app delegate for Firebase setup
      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(playState).onAppear {
                // 환경 객체 설정 
                changeMode(isDarkMode: isDarkMode) // 보여질 때 다크모드 확인 이벤트 등록
                // 네트워크 등록
            }

        }.onChange(of: scenePhase) { newScenePhase in
            if newScenePhase == .background {
                  let isPlayed = playState.isPlaying
                  DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                      if isPlayed == .playing {playState.youTubePlayer.play()}
                  })
            }
          }
    }

}

func changeMode(isDarkMode: Bool) {

    if let window = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        if #available(iOS 15.0, *) {
            let windows = window.windows.first
            windows?.overrideUserInterfaceStyle = isDarkMode  == true ? .dark : .light

        }
    } else if let window = UIApplication.shared.windows.first {
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = isDarkMode == true ? .dark : .light
        } else { // IOS 13 미만은 dark모드 불가
            window.overrideUserInterfaceStyle = .light
        }
    }
}

func clearCache() {
    ImageCache.default.clearCache()
}
