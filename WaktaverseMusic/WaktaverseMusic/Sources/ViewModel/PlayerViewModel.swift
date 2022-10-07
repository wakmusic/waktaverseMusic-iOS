//
//  VideoPlayerViewModel.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/09/13.
//

import Foundation
import SwiftUI

class PlayerViewModel: ObservableObject {

    @Published var showPlayer = false
    @Published var offset: CGFloat = 0
    @Published var playerMode = PlayerMode()

}

extension PlayerViewModel {
    struct PlayerMode {
        enum Mode { case full, mini, playlist } // 모드가 겹치지 않음
        var mode: Mode = .mini

        var isFullPlayer: Bool { return mode == .full }
        var isMiniPlayer: Bool { return mode == .mini }
        var isPlayListPresented: Bool { return mode == .playlist }

    }
}
