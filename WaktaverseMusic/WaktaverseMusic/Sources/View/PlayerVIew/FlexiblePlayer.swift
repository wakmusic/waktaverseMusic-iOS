//
//  PlaybackFullScreenView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/29.
//

import SwiftUI
import Kingfisher
import UIKit
import PopupView
import YouTubePlayerKit

struct FlexiblePlayer: View {

    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var player: PlayerViewModel
    var animation: Namespace.ID
    let hasNotch: Bool = UIDevice.current.hasNotch

    var body: some View {
        if let currentSong = playState.currentSong {
            VStack(spacing: player.playerMode.isMiniPlayer ? 0 : nil) {

                // Spacer(minLength: 0)
                /*
                 .aspectRatio(contentMode: .fit) == scaledToFit() ⇒ 이미지의 비율을 유지 + 이미지의 전체를 보여준다.
                 .aspectRatio(contentMode: .fill) ⇒ 이미지의 비율을 유지 + 이미지가 잘리더라도 꽉채움
                 */
                //

                if player.playerMode.isFullPlayer {
                    if ScreenSize.height <= 600 {
                        Spacer(minLength: ScreenSize.height*0.2)
                    } else {
                        Spacer(minLength: ScreenSize.height*0.3)
                    }
                }

                HStack {
                    YoutubeView().environmentObject(playState)
                        .frame(maxWidth: player.playerMode.isMiniPlayer ?
                               PlayerSize.miniSize.width : PlayerSize.defaultSize.width,
                               maxHeight: player.playerMode.isMiniPlayer ?
                               PlayerSize.miniSize.height : PlayerSize.defaultSize.height)
                        .opacity(player.playerMode.isPlayListPresented ? 0 : 1) // 플레이리스트 보여질땐 플레이어 감추기

                    if player.playerMode.isMiniPlayer { // 미니 플레이어 시 보여질 컨트롤러
                        VStack(alignment: .leading) { // 리스트 보여주면 .leading
                            Text(currentSong.title)
                                .modifier(PlayBarTitleModifier())
                            Text(currentSong.artist)
                                .modifier(PlayBarArtistModifer())
                        }

                        Spacer()

                        HStack(spacing: 0) {
                            PlayPuaseButton().environmentObject(playState)

                            Button {
                                playState.playList.removeAll()
                                playState.currentSong = nil

                                print("✅ key: currentPlayList에 저장된 데이터를 제거합니다.")
                                UserDefaults.standard.set(nil, forKey: "currentPlayList")
                                print("✅ key: lastPlayedSong에 저장된 데이터를 제거합니다.")
                                UserDefaults.standard.set(nil, forKey: "lastPlayedSong")
                            } label: {
                                Image(systemName: "xmark").modifier(PlayBarButtonImageModifier()).padding()
                            }
                        }.padding(.horizontal, 5)

                    }

                }.frame(maxWidth: player.playerMode.isPlayListPresented ? 0 : ScreenSize.width, maxHeight: player.playerMode.isMiniPlayer ? PlayerSize.miniHeight : player.playerMode.isPlayListPresented ? 0 : PlayerSize.defaultHeight, alignment: .leading)

                VStack {
                    Group { // 그룹으로 묶어 조건적으로 보여준다.

                        if player.playerMode.isPlayListPresented {

                            PlayListView().environmentObject(playState).padding(.top, UIDevice.current.hasNotch ? 30 : 0) // notch에 따라 패팅 top 줌 (

                        } else {

                            VStack(alignment: .center) { // 리스트 보여주면 .leading
                                Text(currentSong.title)
                                    .modifier(FullScreenTitleModifier())

                                Text(currentSong.artist)
                                    .modifier(FullScreenArtistModifer())
                            }
                        }

                    }

                    Spacer(minLength: 0)

                    ProgressBar().padding(.horizontal)

                    PlayerButtonBar().environmentObject(playState)
                        .padding(.bottom, hasNotch ? 40 :  20) // 밑에서 띄우기
                        .padding(.horizontal)
                }.frame(width: player.playerMode.isMiniPlayer ? 0 : ScreenSize.width, height: player.playerMode.isMiniPlayer ? 0 : nil) // notch 없는 것들 오른쪽 치우침 방지..
                    .opacity(player.playerMode.isMiniPlayer ? 0 : 1)

            }.frame(maxHeight: player.playerMode.isMiniPlayer ? PlayerSize.miniHeight : .infinity) // notch 없는 것들 오른쪽 치우침 방지..

            .background(

                VStack(spacing: 0) {

                    BlurView()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                player.playerMode.mode = .full
                                UIApplication.shared.endEditing() // 키보드 닫기
                            }
                        }

                }

            )
            .edgesIgnoringSafeArea(.all)
            .offset(y: player.offset)
            .gesture(DragGesture().onEnded(onEnded(value:)).onChanged(onChanged(value:)))

        }

    }

    func onChanged(value: DragGesture.Value) {
        if value.translation.height > 0 && !player.playerMode.isMiniPlayer {
            player.offset = value.translation.height
        }
    }

    func onEnded(value: DragGesture.Value) {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.95, blendDuration: 0.96)) {

            if value.translation.height > ScreenSize.height/3 {
                player.playerMode.mode = .mini
                // player.playerMode.isPlayListPresented = false
            }
            player.offset = 0
        }
    }
}

struct PlayerButtonBar: View {
    @EnvironmentObject var playState: PlayState
    @EnvironmentObject var player: PlayerViewModel
    @State var isLike: Bool = false

    var body: some View {
        HStack {
            playListButton
            Spacer()
            backwardButton
            Spacer()
            PlayPuaseButton().environmentObject(playState)
            Spacer()
            forwardButton
            Spacer()
            heartButton
        }
        .modifier(FullScreenButtonImageModifier())
    }

    var playListButton: some View {
        Button {  // 리스트 버튼을 누를 경우 animation과 같이 toggle
            withAnimation(.easeInOut) {
                player.playerMode.mode = player.playerMode.mode == .playlist ? .full : .playlist
            }
        } label: {
            Image(systemName: "music.note.list").padding(5)
        }
    }
    var backwardButton: some View {
        Button {
            playState.backWard()
        } label: {
            Image(systemName: "backward.fill").padding(5)
        }
    }
    var forwardButton: some View {
        Button {
            playState.forWard()
        } label: {
            Image(systemName: "forward.fill").padding(5)
        }
    }
    var heartButton: some View {
        Button {
            withAnimation(.easeInOut) {
                isLike.toggle()
            }
        } label: {
            Image(systemName: isLike == true ? "heart.fill" : "heart").padding(5)
        }
    }
}

struct ProgressBar: View {

    @EnvironmentObject var playState: PlayState
    var currentTime: String = PlayState.shared.progress.currentProgress.convertTimetoString()
    var endTime: String = PlayState.shared.progress.endProgress.convertTimetoString()

    var body: some View {

        if playState.currentSong != nil {
            VStack {
                // Sldier 설정 및 바인딩
                Slider(value: $playState.progress.currentProgress, in: 0...playState.progress.endProgress) { change in
                    // onEditChanged
                    if change == false { // change == true는 slider를 건들기 시작할 때 false는 slider를 내려 놓을 때
                        playState.youTubePlayer.seek(to: playState.progress.currentProgress, allowSeekAhead: true) // allowSeekAhead = true 서버로 요청
                    }
                }.onAppear {
                    // 슬라이더 볼 사이즈 수정
                    let progressCircleConfig = UIImage.SymbolConfiguration(scale: .medium)
                    UISlider.appearance()
                        .setThumbImage(UIImage(systemName: "circle.fill",
                                               withConfiguration: progressCircleConfig), for: .normal)
                }

                HStack {
                    Text(currentTime).modifier(FullScreenTimeModifer())
                    Spacer()
                    Text(endTime).modifier(FullScreenTimeModifer())
                }

            }
        }
    }
}
