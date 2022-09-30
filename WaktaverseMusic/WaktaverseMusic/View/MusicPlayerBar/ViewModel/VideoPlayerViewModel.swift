//
//  VideoPlayerViewModel.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/09/13.
//

import Foundation
import SwiftUI

class VideoPlayerViewModel: ObservableObject {
    
    @Published var showPlayer = false
    @Published var isPlayerListViewPresented = false //false = Image  ,true = PlayList
    @Published var offset: CGFloat = 0
    @Published var width: CGFloat = UIScreen.main.bounds.width
    @Published var isMiniPlayer = true
    
}
