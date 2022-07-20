//
//  MainScreenView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/20.
//

import SwiftUI
let window = UIScreen.main.bounds.size
struct MainScreenView: View {
    @EnvironmentObject var setting:Setting
    @State var isLoading: Bool = true
    @AppStorage("isDarkMode") var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "isDarkMode")
    
    var body: some View {
        NavigationView {
            
            if isLoading
            {
                LaunchScreenView().onAppear
                {
                    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                        withAnimation { isLoading.toggle() }
                    }
                }
            }
            else
            {
                

                //인터넷 처리
                VStack
                {
                    Text("Hello")
                }.onAppear
                {
                    print(isDarkMode)
                    changeMode(isDarkMode: isDarkMode)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                        
                        NavigationLogo()
                        
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        SettinButton(isDarkMode: $isDarkMode)
                    }
                }
            }
            
            
            
            
            
            
            
        }
    }
    
}



//- MARK: Preview

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}

//- MARK: SubView

struct NavigationLogo: View {
    var body: some View {
        Image("mainLogoWhite")
            .resizable()
            .renderingMode(.template)
            .foregroundColor(Color("PrimaryColor"))
            .frame(width: window.width*0.3, height: window.height*0.045 , alignment: .center) //
            .aspectRatio(contentMode: .fit)
    }
}

struct SettinButton: View {
    @Binding var isDarkMode:Bool
    var body: some View {
        NavigationLink {
            SettingScreenView() //Destination
        } label: {
            //보여질 방식, 버튼 이미지
            Image(systemName: "gearshape.fill")
                .foregroundColor(Color("PrimaryColor"))
        }
        
    }
}

//- MARK: Function

func changeMode(isDarkMode:Bool)
{
    if let window = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        if #available(iOS 15.0, *) {
            let windows = window.windows.first
            windows?.overrideUserInterfaceStyle = isDarkMode  == true ? .dark : .light
            UserDefaults.standard.set(!isDarkMode, forKey: "isDarkMode")
            
        }
    } else if let window = UIApplication.shared.windows.first {
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = isDarkMode == true ? .dark : .light
            UserDefaults.standard.set(!isDarkMode, forKey: "isDarkMode")
        } else { //IOS 13 미만은 dark모드 불가
            window.overrideUserInterfaceStyle = .light
        }
    }
}
