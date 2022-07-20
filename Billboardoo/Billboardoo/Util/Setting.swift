//
//  Theme.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/20.
//

import SwiftUI



class Setting:ObservableObject {
    @Published var isDarkMode:Bool = UserDefaults.standard.bool(forKey: "isDarkMode")
}
