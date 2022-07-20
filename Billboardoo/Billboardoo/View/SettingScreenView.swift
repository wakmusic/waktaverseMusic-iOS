//
//  SettingScreenView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/20.
//

import SwiftUI

struct SettingScreenView: View {
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "isDarkMode")
    
    var body: some View {
        NavigationView
        {
            
            VStack
            {
                Toggle("Dark Mode", isOn: $isDarkMode)
                
                if isDarkMode
                {
                    Text("DARK")
                }
                else
                {
                    Text("White")
                }
            }
        }.onDisappear
        {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
            print(isDarkMode)
        }
        .navigationTitle("Setting")
        
        
    }
}

struct SettingScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SettingScreenView()
    }
}
