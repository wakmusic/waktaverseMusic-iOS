//
//  InvisibleRefreshView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/29.
//

import SwiftUI
import YouTubePlayerKit
struct InvisibleRefreshView: View {

    @EnvironmentObject var playState: PlayState

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    // every: 0.1초 , on: main스레드 ,
    // .common모드의 경우, 타이머가 다른 일반적인 이벤트와 나란히 실행하는 것을 허용 합니다 - 예를들어, 스크롤뷰에 있는 텍스트가 움직이는 경우입니다.
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        Text(" ")
            .onReceive(timer) { _ in
                if let nowPlayingSong = playState.nowPlayingSong { // 트랙킹 다를 경우 .load

                    playState.youTubePlayer.getPlaybackState { completion in
                        switch completion {
                        case .success(let state):

                            if(playState.isPlaying != state) // 만약 현재상태와 다를 때
                            {
                                playState.isPlaying = state // state를 저장하고

                                // 노래할당이 끝난 후
                                if(state == .ended) // 만약 끝났을 때 다음 곡으로 넘겨준다.
                                {
                                    playState.forWard()
                                }

                                playState.youTubePlayer.getDuration { completion in

                                    switch completion {
                                    case .success(let time):
                                        playState.endProgress = time

                                    case .failure:
                                        playState.endProgress = 0.0
                                    }
                                }

                            }

                        case.failure(let err):
                            print(err)

                        }

                    }

                    if playState.currentSong != nowPlayingSong // 값이 다를경우
                    {
                        print("curr: \(playState.currentSong) now:  \(nowPlayingSong)")
                        playState.currentSong = nowPlayingSong // 곡 을 변경 후

                        playState.youTubePlayer.load(source: .url(nowPlayingSong.url)) // 바로 load

                    }

                }

            }
    }
}
