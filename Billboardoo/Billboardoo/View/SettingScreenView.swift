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
                Toggle("Dark Mode", isOn: $isDarkMode).onChange(of: isDarkMode) { result in
                    print(" disAppear \(result)")
                    UserDefaults.standard.set(result, forKey: "isDarkMode")
                    changeMode(isDarkMode: result)
                }
                
                if isDarkMode
                {
                    Text("DARK")
                }
                else
                {
                    Text("White")
                }
            }
        }
        .navigationTitle("Setting")
        
        
    }
}



struct SettingScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SettingScreenView()
    }
}

