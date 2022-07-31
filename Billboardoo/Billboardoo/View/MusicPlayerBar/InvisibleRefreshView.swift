//
//  InvisibleRefreshView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/29.
//

import SwiftUI
import YouTubePlayerKit
struct InvisibleRefreshView: View {
    
    @EnvironmentObject var playState:PlayState
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onReceive(timer) { _ in
                if let nowPlayingSong = playState.nowPlayingSong
                { //트랙킹 다를 경우 .load
                    
                    if playState.currentSong != nowPlayingSong // 값이 다를경우
                    {
                        playState.currentSong = nowPlayingSong //곡 을 변경 후
                        
                        if playState.isPlaying == .play { //만약 재새중에 옮겼다면  load
                            playState.youTubePlayer.load(source: .url(nowPlayingSong.url)) //바로 load
                        }
                        else //멈춘 경우에 옮겼다면 .cue
                        {
                            playState.youTubePlayer.cue(source: .url(nowPlayingSong.url))
                        }
                        
                       
                    }
                    
                }
                
            }
    }
}

