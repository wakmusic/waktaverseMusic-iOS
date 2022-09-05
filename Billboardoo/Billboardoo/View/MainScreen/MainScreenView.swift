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
    @StateObject var networkManager = NetworkManager()
    @EnvironmentObject var playState: PlayState
    @Namespace var animation
    
    // PlayBar Slide 애니메이션을 위한 상태
    @GestureState var gestureState = CGSize.zero
    @State var gestureStore = CGSize.zero
    
    @State var musicCart:[SimpleSong] = [SimpleSong] () // 리스트에서 클릭했을 때 템프 리스트
    
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
            
            
            
            
            GeometryReader{ geometry in
                
                let width = min(geometry.size.width,geometry.size.height)
                let height = max(geometry.size.width,geometry.size.height)
                ZStack(alignment:.center) {
                    YoutubeView().environmentObject(playState)
                        .opacity(0)
                    InvisibleRefreshView()
                        .opacity(0)
                    
                    VStack(spacing:0){
                        
                        if(!networkManager.isConnected)
                        {
                            NetworkView()
                        }
                        else{
                            switch router.screen{
                            case .home:
                                HomeScreenView(musicCart: $musicCart).environmentObject(playState)
                            case .artists:
                                ArtistScreenView(musicCart: $musicCart).environmentObject(playState)
                            case .search:
                                SearchView(musicCart: $musicCart).environmentObject(playState)
                                
                            case .account:
                                AccountView()
                                
                                
                            }
                        }
                        
                        
                        Group{
                            if(musicCart.isEmpty)
                            {
                                VStack(spacing:0){
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
                                    HStack(alignment:.center){
                                        Spacer()
                                        TabBarIcon(width: width/5, height: height/28, systemIconName: "home",text: "Home", assignedPage: .home,router: router)
                                        Spacer()
                                        TabBarIcon(width: width/5, height: height/28, systemIconName: "magnifyingglass",text:"Search", assignedPage: .search,router: router)
                                        Spacer()
                                        TabBarIcon(width: width/5, height: height/28, systemIconName: "microphone",text:"Artist",assignedPage: .artists,router: router)
                                        Spacer()
                                        TabBarIcon(width: width/5, height: height/28, systemIconName: "person",text: "Account",assignedPage: .account,router: router)
                                        Spacer()
                                    }
                                    
                                    .frame(width: geometry.size.width, height: UIDevice.current.hasNotch ?  geometry.size.height/15 : geometry.size.height/13)
                                    .background(.ultraThinMaterial)
                                    
                                    .shadow(radius: 2)
                                    
                                }
                                
                                .transition(.move(edge: .bottom))
                                .animation(.easeOut,value:musicCart.count)
                                .zIndex(musicCart.isEmpty ? 2.0 : 1.0) //내려가는 애니메이션이 리스트 탭바와 겹치지 않기 위해
                                
                            }
                            else
                            {
                                // - MARK: 리스트 탭 바
                                
                                HStack(alignment: .center){
                                    
                                    ZStack{
                                        Circle()
                                            .foregroundColor(.white)
                                            .frame(width: geometry.size.width/13, height: geometry.size.width/13)
                                            .shadow(radius: 4)
                                        
                                        Image(systemName: "circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width/13-6, height: geometry.size.width/13-6)
                                            .foregroundColor(.wak)
                                            .overlay(Text("\(musicCart.count)").font(.caption2).foregroundColor(.white))
                                    }
                                    .offset(x:3,y:-geometry.size.height/10/3)
                                    
                                    //재생 바
                                    Spacer()
                                    Button {
                                        let simpleSong = musicCart[0]
                                        playState.currentSong =  simpleSong //강제 배정
                                        playState.youTubePlayer.load(source: .url(simpleSong.url)) //강제 재생
                                        playState.uniqueAppend(item: simpleSong)
                                        
                                        
                                        
                                        for song in musicCart{
                                            playState.appendList(item: song)
                                        }
                                        
                                        
                                        musicCart.removeAll()
                                        
                                    } label: {
                                        ListBarIcon(width: width/5, height: height/28, systemIconName: "play.fill",text: "재생")
                                    }
                                    
                                    Spacer()
                                    
                                    //카운팅
                                    
                                    
                                    
                                    
                                    Button {
                                        musicCart.removeAll()
                                    } label: {
                                        ListBarIcon(width: width/5, height: height/28, systemIconName: "trash",text: "전체선택 해제")
                                    }
                                    Spacer()
                                    Button {
                                        
                                        for song in musicCart{
                                            playState.appendList(item: song)
                                        }
                                        
                                        musicCart.removeAll()
                                        
                                    } label: {
                                        ListBarIcon(width: width/5, height: height/28, systemIconName: "plus",text: "담기")
                                    }
                                    Spacer()
                                    
                                }.frame(width: geometry.size.width, height: UIDevice.current.hasNotch ?  geometry.size.height/14 : geometry.size.height/12 )
                                    .background(Color.wak)
                                    .shadow(radius: 2)
                                    .transition(.move(edge: .bottom))
                                    .animation(.easeOut,value:musicCart.count)
                                    .zIndex(!musicCart.isEmpty ? 2.0 : 1.0)
                                
                                
                                
                                //내려가는 애니메이션이 탭바와 겹치지 않기 위해
                                
                                
                                
                                
                            }
                        }.animation(.easeInOut,value:$musicCart.isEmpty) // 탭바 두개를 한번에 묶어 에니메이션 적용
                        
                        
                        
                        
                        
                        
                    }
                    
                    Group{
                        if playState.isPlayerViewPresented {
                            PlaybackFullScreenView(animation: animation)
                            
                                .environmentObject(playState)
                                .offset(CGSize(width:0,height: gestureState.height + gestureStore.height))
                            //ofset을 이용하여 슬라이드 에니메이션 효과를 준다
                            //현재는   simultaneousGesture를 에서 height만 바뀌어서  위아래 슬라이드 효과만 준다.
                            // 위: - 아래 + , 좌우는  슬라이드 애니메이션을 넣지 않고 바꾼다
                        }
                        
                        
                    } //그룹
                    
                    
                    //드래그 제스쳐를 updating
                    .simultaneousGesture(DragGesture().updating($gestureState, body: { value, state, transaction in
                        
                        
                        
                        if value.translation.height > 0 && !playState.isPlayerListViewPresented { // 아래로 드래그 하면 ,저장 //리스트 켜졌을 때 offset 방지
                            
                            state.height = value.translation.height
                        }
                    })
                        .onEnded({ value in //드래그가 끝났을 때
                            
                            if(playState.isPlayerListViewPresented) //리스트 켜졌을 때 커짐 방지
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


struct ListBarIcon: View{
    let width, height: CGFloat
    let systemIconName,text: String
    let hasNotch:Bool = UIDevice.current.hasNotch
    
    var body: some View
    {
        VStack(spacing:3){
            
            Image(systemName: systemIconName)
                .font(.title3)
                .foregroundColor(.white)
                .padding(.top,hasNotch ? 10 : 5 )
            
            
            Text(text).font(.footnote).foregroundColor(.white)
            
            
        }.padding(.vertical,10)
    }
    
    
}

struct TabBarIcon: View{
    let width, height: CGFloat
    let systemIconName,text: String
    let assignedPage:Screen
    @StateObject var router:TabRouter
    let hasNotch:Bool = UIDevice.current.hasNotch
    
    var body: some View {
        VStack(spacing:0){
            
            Image(systemIconName)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .padding(.top,hasNotch ? 10 : 5 )
            
            
            Text(text).font(.footnote)
            
            
            
            
            
            
            
        }
        
        .onTapGesture {
            router.screen = assignedPage
            
        }
        
        .foregroundColor(router.screen == assignedPage ? Color.primary : .gray)
    }
}




struct YoutubeView: View {
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
                case .error(_):
                    EmptyView()
                }
            }.frame(width: 0, height: 0)
        }
    }
}
