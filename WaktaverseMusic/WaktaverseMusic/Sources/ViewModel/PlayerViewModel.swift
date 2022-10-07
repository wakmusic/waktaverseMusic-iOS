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
    @Published var isPlayerListViewPresented = false // false = Image  ,true = PlayList
    @Published var offset: CGFloat = 0
    @Published var playerMode = PlayerMode()

}

extension PlayerViewModel {
    struct PlayerMode {
        enum Mode { case full, mini }
        var mode: Mode = .mini

        var isFullPlayer: Bool { return mode == .full }
        var isMiniPlayer: Bool { return mode == .mini }

    }
}
