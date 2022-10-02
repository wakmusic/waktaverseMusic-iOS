//
//  MainScreenView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/20.
//

import SwiftUI
import YouTubePlayerKit
import AVFAudio
import AVFoundation

struct MainView: View {

    @State var isLoading: Bool = true
    @StateObject var viewModel: MainViewModel = MainViewModel()
    @StateObject var networkManager = NetworkManager()
    @StateObject var player = VideoPlayerViewModel()
    @EnvironmentObject var playState: PlayState
    @Namespace var animation
    @GestureState var gestureOffset: CGFloat = 0

    @State var musicCart: [SimpleSong] = [SimpleSong]() // 리스트에서 클릭했을 때 템프 리스트

    init() {
        // UITabBar.appearance().unselectedItemTintColor = .gray
        // UITabBar.appearance().backgroundColor = .green 탭 바 배경 색
        // UITabBar.appearance().barTintColor = .orange
    }

    var body: some View {

        if isLoading {
            LaunchScreenView().onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    withAnimation { isLoading.toggle() }
                }
            }
        } else {

            GeometryReader { geometry in

                let width = min(geometry.size.width, geometry.size.height)
                let height = max(geometry.size.width, geometry.size.height)
                let tabHeight = UIDevice.current.hasNotch ?  geometry.size.height/15 : geometry.size.height/13
                ZStack(alignment: .bottom) {
//                    YoutubeView().environmentObject(playState)
//                        .opacity(0)
                    InvisibleRefreshView()
                        .opacity(0)

                    VStack(spacing: 0) {

                        if !networkManager.isConnected {
                            NetworkView()
                        } else {
                            switch viewModel.currentTab {
                            case .home:
                                HomeView(musicCart: $musicCart).environmentObject(playState)
                                    .padding(.bottom, (player.isMiniPlayer&&playState.nowPlayingSong != nil)  ?   tabHeight : 0)

                            case .artists:
                                ArtistScreenView(musicCart: $musicCart).environmentObject(playState)
                                    .padding(.bottom, (player.isMiniPlayer&&playState.nowPlayingSong != nil)  ?   tabHeight : 0)
                            case .search:
                                SearchView(musicCart: $musicCart).environmentObject(playState)
                                    .padding(.bottom, (player.isMiniPlayer&&playState.nowPlayingSong != nil)  ?   tabHeight : 0)

                            case .account:
                                AccountView()
                                    .padding(.bottom, (player.isMiniPlayer&&playState.nowPlayingSong != nil)  ?  tabHeight : 0)

                            }
                        }

                        Group {
                            if musicCart.isEmpty {
                                VStack(spacing: 0) {

                                    // - MARK: TabBar
                                    HStack(alignment: .center) {
                                        Spacer()
                                        TabBarIcon(width: width/5, height: height/28, systemIconName: "home", text: "Home", assignedPage: .home, viewModel: viewModel)
                                        Spacer()
                                        TabBarIcon(width: width/5, height: height/28, systemIconName: "magnifyingglass", text: "Search", assignedPage: .search, viewModel: viewModel)
                                        Spacer()
                                        TabBarIcon(width: width/5, height: height/28, systemIconName: "microphone", text: "Artist", assignedPage: .artists, viewModel: viewModel)
                                        Spacer()
                                        TabBarIcon(width: width/5, height: height/28, systemIconName: "person", text: "Account", assignedPage: .account, viewModel: viewModel)
                                        Spacer()
                                    }

                                    .frame(width: geometry.size.width, height: tabHeight)
                                    .background(Color.tabBar)

                                }
                                .transition(.move(edge: .bottom))
                                .animation(.easeOut, value: musicCart.count)
                                .zIndex(musicCart.isEmpty ? 2.0 : 1.0) // 내려가는 애니메이션이 리스트 탭바와 겹치지 않기 위해

                            } else {
                                // - MARK: 리스트 탭 바

                                HStack(alignment: .center) {

                                    ZStack {
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
                                    .offset(x: 3, y: -geometry.size.height/10/8)

                                    // 재생 바
                                    Spacer()
                                    Button {
                                        let simpleSong = musicCart[0]
                                        playState.currentSong =  simpleSong // 강제 배정
                                        playState.youTubePlayer.load(source: .url(simpleSong.url)) // 강제 재생
                                        playState.uniqueAppend(item: simpleSong)

                                        for song in musicCart {
                                            playState.appendList(item: song)
                                        }

                                        musicCart.removeAll()

                                    } label: {
                                        ListBarIcon(width: width/5, height: height/28, systemIconName: "play.fill", text: "재생")
                                    }

                                    Spacer()

                                    // 카운팅

                                    Button {
                                        musicCart.removeAll()
                                    } label: {
                                        ListBarIcon(width: width/5, height: height/28, systemIconName: "trash", text: "전체선택 해제")
                                    }
                                    Spacer()
                                    Button {

                                        for song in musicCart {
                                            playState.appendList(item: song)
                                        }

                                        musicCart.removeAll()

                                    } label: {
                                        ListBarIcon(width: width/5, height: height/28, systemIconName: "plus", text: "담기")
                                    }
                                    Spacer()

                                }.frame(width: geometry.size.width, height: tabHeight)
                                    .background(Color.wak)
                                    .shadow(radius: 2)
                                    .transition(.move(edge: .bottom))
                                    .animation(.easeOut, value: musicCart.count)
                                    .zIndex(!musicCart.isEmpty ? 2.0 : 1.0)

                                // 내려가는 애니메이션이 탭바와 겹치지 않기 위해

                            }
                        }.animation(.easeInOut, value: musicCart.isEmpty) // 탭바 두개를 한번에 묶어 에니메이션 적용

                    }

                    if playState.nowPlayingSong != nil {
                        MiniPlayer(animation: animation)

                            .environmentObject(playState)
                            .environmentObject(player)
                            .transition(.move(edge: .bottom))
                            .offset(y: player.isMiniPlayer ? -tabHeight : 0)
                            // miniPlayer 일 때 offset 아니면 그냥 적용
                    }

                }// Z
            }

        }

    }

}

// - MARK: Function

struct TabBarItem: View {
    var title: String
    var imageName: String
    var body: some View {
        VStack {
            Text(title)
            Image(systemName: imageName)
        }
    }
}

struct ListBarIcon: View {
    let width, height: CGFloat
    let systemIconName, text: String
    let hasNotch: Bool = UIDevice.current.hasNotch

    var body: some View {
        VStack(spacing: 3) {

            Image(systemName: systemIconName)
                .font(.title3)
                .foregroundColor(.white)
                .padding(.top, hasNotch ? 10 : 5 )

            Text(text).font(.footnote).foregroundColor(.white)

        }.padding(.vertical, 10)
    }

}

struct TabBarIcon: View {
    let width, height: CGFloat
    let systemIconName, text: String
    let assignedPage: Tab
    @ObservedObject var viewModel: MainViewModel
    let hasNotch: Bool = UIDevice.current.hasNotch

    var body: some View {
        VStack(spacing: 0) {

            Image(systemIconName)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .padding(.top, hasNotch ? 10 : 5 )

            Text(text).font(.footnote)

        }

        .onTapGesture {
            viewModel.change(to: assignedPage)
        }
        .foregroundColor(assignedPage.isSame(viewModel.currentTab) ? Color.primary : .gray)
    }
}

struct YoutubeView: View {
    @EnvironmentObject var playState: PlayState
    var body: some View {
        VStack {
            YouTubePlayerView(self.playState.youTubePlayer) { state in
                // Overlay ViewBuilder closure to place an overlay View
                // for the current `YouTubePlayer.State`
                switch state {
                case .idle:
                    EmptyView()
                case .ready:
                    EmptyView()
                case .error:
                    EmptyView()
                }
            }
        }
    }
}
