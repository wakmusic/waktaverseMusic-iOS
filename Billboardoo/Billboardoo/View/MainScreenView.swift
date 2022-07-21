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
}

final class TabRouter: ObservableObject { //Tab State관련 클래스
    @Published var screen:Screen = .home
    
    func change(to screen:Screen)
    {
        self.screen = screen
    }
}

let window = UIScreen.main.bounds.size
struct MainScreenView: View {
    @State var isLoading: Bool = true
    @StateObject var router:TabRouter = TabRouter()
    
    init() {
        //UITabBar.appearance().unselectedItemTintColor = .red
        //UITabBar.appearance().backgroundColor = .green 탭 바 배경 색
        //UITabBar.appearance().barTintColor = .orange
    }
    
    
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
                
                //- MARK: TabView
                TabView(selection: $router.screen){
                    HomeScreenView().tag(Screen.home).tabItem {
                        TabBarItem(title: "Home", imageName: "house.fill")

                    }
                    
                    HomeScreenView().tag(Screen.albums).tabItem {
                        Label("albumns", systemImage: "house.fill")
                        
                    }
                }.accentColor(Color("PrimaryColor")) //Should Refactor
                
                
                //- MARK: Navigation Setting
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                        
                        NavigationLogo()
                        
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        SettinButton()
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
