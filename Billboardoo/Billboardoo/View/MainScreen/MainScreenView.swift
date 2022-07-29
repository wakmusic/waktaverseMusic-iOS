//
//  MainScreenView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/20.
//

import SwiftUI
enum Screen{
    case home
    case albums
    case artists
    case setting
}

final class TabRouter: ObservableObject { //Tab State관련 클래스
    @Published var screen:Screen = .home
    
    func change(to screen:Screen)
    {
        self.screen = screen
    }
}


struct MainScreenView: View {

    
    @State var isLoading: Bool = true
    @StateObject var router:TabRouter = TabRouter()
    @EnvironmentObject var playState: PlayState
    @Namespace var animation
    
    init() {
        //UITabBar.appearance().unselectedItemTintColor = .red
        //UITabBar.appearance().backgroundColor = .green 탭 바 배경 색
        //UITabBar.appearance().barTintColor = .orange
    }
    
    
    var body: some View {
        
        
        
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
            
            //- MARK: TabView
            ZStack {
                
                InvisibleRefreshView()
                    .opacity(0.0001)

                TabView(selection: $router.screen){
                    
                    ZStack() {
                        HomeScreenView()
                        
                        if !playState.isPlayerViewPresented
                        {
                            PlaybackBarView(animation: animation).environmentObject(playState)
                        }
                        
                    }.tag(Screen.home)
                        .tabItem {
                            TabBarItem(title: "Home", imageName: "house.fill")
                        }
                    
                    ZStack{
                        SettingScreenView()
                        if !playState.isPlayerViewPresented
                        {
                            PlaybackBarView(animation: animation).environmentObject(playState)
                        }
                    }.tag(Screen.setting)
                        .tabItem {
                            TabBarItem(title: "Setting", imageName: "gearshape.fill")
                        }
                    
                }
                    .zIndex(1.0)
                
                if playState.isPlayerViewPresented {
                     PlaybackFullScreenView(animation: animation)
                        .environmentObject(playState)
                        .edgesIgnoringSafeArea(.horizontal)
                        .zIndex(2.0)
                }
                
                
            }.accentColor(Color("PrimaryColor"))
    
                .animation(.default)
            // 재생창 띄울 때 움직이는 애니메이션 설정
            //Should Refactor
            
            
            //- MARK: Navigation Setting
            //                    .navigationBarTitleDisplayMode(.inline)
            //                    .toolbar {
            //                        ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
            //
            //                            NavigationLogo()
            //
            //                        }
            //                        ToolbarItem(placement: .navigationBarTrailing) {
            //                            SettinButton()
            //                        }
            //                    }
            
        }
        
        
        
    }
    
}



//- MARK: Preview

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView().environmentObject(PlayState())
    }
}

//- MARK: Function



struct TabBarItem: View {
    var title:String
    var imageName:String
    var body: some View {
        VStack {
            Text(title)
            Image(systemName: imageName)
        }
    }
}
