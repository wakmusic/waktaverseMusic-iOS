//
//  Enum.swift
//  WaktaverseMusic
//
//  Created by YoungK on 2022/10/02.
//

import Foundation
import SwiftUI

enum Device {
    static let isPhone = UIDevice.current.userInterfaceIdiom == .phone
    static let isPad = UIDevice.current.userInterfaceIdiom == .pad
}

enum ScreenSize {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.size.height
}

enum Tab {
    case home, artists, search, account

    func isSame(_ at: Tab) -> Bool { self == at }
}

enum SearchType {
    case title
    case artist
    case remix
}

enum PlayerSize {
    static let standardLen = ScreenSize.width > ScreenSize.height ? ScreenSize.width : ScreenSize.height
    static let miniWidth: CGFloat = ScreenSize.width * 0.3
    static let miniHeight: CGFloat = (ScreenSize.width * 0.3 * 9)/16
    static let defaultHeight: CGFloat = (ScreenSize.width * 9)/16

    static let miniSize: (width: CGFloat, height: CGFloat) = (miniWidth, miniHeight)
    static let defaultSize: (width: CGFloat, height: CGFloat) = (ScreenSize.width, defaultHeight)
}
