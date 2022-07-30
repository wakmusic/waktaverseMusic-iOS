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
                
             
                if let nowPlayingSong = playState.nowPlayingSong { //트랙킹 다를 경우 .load
                    if playState.currentSong != nowPlayingSong  {
                        playState.youTubePlayer.load(source: .url(nowPlayingSong.url))
                        playState.currentSong = nowPlayingSong
                    }
                }
                
                
                
                
            }
    }
}

