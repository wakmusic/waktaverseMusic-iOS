//
//  Enum.swift
//  WaktaverseMusic
//
//  Created by YoungK on 2022/10/02.
//

import Foundation
import SwiftUI

enum ScreenSize {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.size.height
}

enum Tab {
    case home, artists, search, account

    func isSame(_ at: Tab) -> Bool { self == at }
}
