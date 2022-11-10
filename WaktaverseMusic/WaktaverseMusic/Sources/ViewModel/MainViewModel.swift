//
//  MainViewModel.swift
//  WaktaverseMusic
//
//  Created by YoungK on 2022/10/02.
//

import Foundation
import Combine
import SwiftUI

// final class TabRouter: ObservableObject { // Tab State관련 클래스
//    @Published var screen: Screen = .home
//
//    func change(to screen: Screen) {
//        self.screen = screen
//    }
// }

final class MainViewModel: ObservableObject {
    @Published var currentTab: Tab
    @Published private(set) var keyboardHeight: CGFloat = 0
    private var subscription: AnyCancellable?

    private let keyboardWillShow =  NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .compactMap { output in
            (output.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height
            // 유저 정보 맵에서 keyboard 높이를 얻는다.

        }

    private let keyboardWillHide = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map { _ in CGFloat.zero}

    init() {
        currentTab = .home
        subscription = Publishers.Merge(keyboardWillShow, keyboardWillHide)
            .subscribe(on: DispatchQueue.main) // UI 변화 이므로 메인. 쓰레드
            .assign(to: \.self.keyboardHeight, on: self)

    }

    func change(to tab: Tab) {
        self.currentTab = tab
    }

    func loadToCurrentPlayList() -> [SimpleSong] {
        guard let datas = UserDefaults.standard.array(forKey: "currentPlayList") as? [Data] else { return [] }
        let playList = datas.map { try! JSONDecoder().decode(SimpleSong.self, from: $0) }
        return playList
    }

    func loadToLastPlayedSong() -> SimpleSong? {
        guard let data = UserDefaults.standard.object(forKey: "lastPlayedSong") as? Data else { return nil }
        let lastPlayedSong = try! JSONDecoder().decode(SimpleSong.self, from: data)
        return lastPlayedSong
    }
}
