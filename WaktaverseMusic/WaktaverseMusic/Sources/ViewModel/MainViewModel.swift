//
//  MainViewModel.swift
//  WaktaverseMusic
//
//  Created by YoungK on 2022/10/02.
//

import Foundation

// final class TabRouter: ObservableObject { // Tab State관련 클래스
//    @Published var screen: Screen = .home
//
//    func change(to screen: Screen) {
//        self.screen = screen
//    }
// }

final class MainViewModel: ObservableObject {
    @Published var currentTab: Tab = .home

    func change(to tab: Tab) {
        self.currentTab = tab
    }
}
