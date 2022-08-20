//
//  MainScreenView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/20.
//

import SwiftUI
import YouTubePlayerKit

enum Screen{
    case home
    case artists
    case search
    case account
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
    
    // PlayBar Slide 애니메이션을 위한 상태
    @GestureState var gestureState = CGSize.zero
    @State var gestureStore = CGSize.zero
    @State var editMode:Bool = false //playbackFullScreen에서 수정모드, 수정모드가 true일 때는 드래그 모션 멈춤
    //
    
    
    init() {
        //UITabBar.appearance().unselectedItemTintColor = .gray
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
            
        
            GeometryReader{ geometry in
                ZStack(alignment:.center) {
                    YotubeView().environmentObject(playState)
                        .opacity(0)
                    InvisibleRefreshView()
                        .opacity(0)
                    
                    VStack(spacing:0){
                        switch router.screen{
                        case .home:
                            HomeScreenView().environmentObject(playState)
                        case .artists:
                            ArtistScreenView().environmentObject(playState)
                        case .search:
                            SearchView().environmentObject(playState)
                            
                        case .account:
                            AccountView()
                        }
                        
                        
                        
                        PlaybackBarView(animation: animation,gestureStore:$gestureStore)
                            .environmentObject(playState)
                            .onTapGesture {
                                //PlayBar를 터치하면  store의 height,width을 0으로 초기화
                                gestureStore.height = 0
                                gestureStore.width = 0
                                withAnimation(Animation.spring(response: 0.7, dampingFraction: 0.85)) {
                                    
                                    playState.isPlayerViewPresented = true // Full Sreen 보이게
                                }
                            }
                        
                        
                        // - MARK: TabBar
                        HStack{
                            TabBarIcon(width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "home", assignedPage: .home,router: router)
                            
                            TabBarIcon(width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "magnifyingglass", assignedPage: .search,router: router)
                            
                            TabBarIcon(width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "microphone", assignedPage: .artists,router: router)
                            
                            TabBarIcon(width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "person", assignedPage: .account,router: router)
                            
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height/15)
                        .background(.ultraThinMaterial)
                        .shadow(radius: 2)
                        
                    }
                    
                    Group{
                        if playState.isPlayerViewPresented {
                            PlaybackFullScreenView(animation: animation,editMode: $editMode)
                            
                                .environmentObject(playState)
                                .offset(CGSize(width:0,height: gestureState.height + gestureStore.height))
                            //ofset을 이용하여 슬라이드 에니메이션 효과를 준다
                            //현재는   simultaneousGesture를 에서 height만 바뀌어서  위아래 슬라이드 효과만 준다.
                            // 위: - 아래 + , 좌우는  슬라이드 애니메이션을 넣지 않고 바꾼다
                        }
                            
                    
                    } //그룹
                   
                    
                    //드래그 제스쳐를 updating
                    .simultaneousGesture(DragGesture().updating($gestureState, body: { value, state, transaction in
                        
                        
                        
                        if value.translation.height > 0 && !editMode { // 아래로 드래그 하면 ,저장
                            //offset 방지 editMode가 false여야 저장
                            state.height = value.translation.height
                        }
                    })
                        .onEnded({ value in //드래그가 끝났을 때
                            
                            
                            if(editMode) //editMode가 켜져있으면 막음
                            {
                                return
                            }
                            let translationHeight = max(value.translation.height,value.predictedEndTranslation.height * 0.2)
                            
                            
                            let tranlationWidth = max(value.translation.width, value.predictedEndTranslation.width * 0.2)
                            
                            
                            
                            if translationHeight > 0 { //0보다 위면 그냥 트랙킹만
                                gestureStore.height = translationHeight
                            }
                            
                            if tranlationWidth > 0 {
                                gestureStore.width = tranlationWidth
                            }
                            
                            if translationHeight > 100 { //50보다 아래로 드래그 했으면 FullSreen 꺼짐
                                withAnimation(Animation.spring(response: 0.7, dampingFraction: 0.85)) {
                                    
                                    
                                    playState.isPlayerViewPresented = false
                                    playState.isPlayerListViewPresented  = false  //꺼질 때 list화면 도 같이
                                }
                            } else { //50 보다 작으면 다시 화면 꽉 채우게
                                withAnimation(Animation.spring(response: 0.7, dampingFraction: 0.85)) {
                                    gestureStore.height = 0
                                }
                            }
                            
                            //위에서 꺼지는 작업이 아닐 때
                            //width가  (왼->오) + (forWard)
                            //width가. (오->왼) - (backWard)
                            if tranlationWidth > 100 {
                                withAnimation(Animation.spring(response: 0.7, dampingFraction: 0.85)) {
                                    playState.forWard()
                                }
                            }
                            
                            if tranlationWidth < -100 {
                                withAnimation(Animation.spring(response: 0.7, dampingFraction: 0.85)) {
                                    playState.backWard()
                                }
                            }
                        }))
                }
            }
            
            
            
            
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

struct TabBarIcon: View{
    let width, height: CGFloat
    let systemIconName: String
    let assignedPage:Screen
    @StateObject var router:TabRouter
    
    var body: some View {
        VStack{
            Image(systemIconName)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                //.padding(.top,10)
            
        }
            .onTapGesture {
                router.screen = assignedPage
            }
        
            .foregroundColor(router.screen == assignedPage ? Color.primary : .gray)
    }
}




struct YotubeView: View {
    @EnvironmentObject var playState: PlayState
    var body: some View {
        VStack{
            YouTubePlayerView(self.playState.youTubePlayer) { state in
                // Overlay ViewBuilder closure to place an overlay View
                // for the current `YouTubePlayer.State`
                switch state {
                case .idle:
                    ProgressView()
                case .ready:
                    EmptyView()
                case .error(let error):
                    Text(verbatim: "YouTube player couldn't be loaded")
                }
            }.frame(width: 0, height: 0)
        }
    }
}
