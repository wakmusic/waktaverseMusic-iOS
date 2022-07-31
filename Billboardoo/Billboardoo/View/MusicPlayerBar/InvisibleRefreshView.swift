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
        Text(" ")
            .onReceive(timer) { _ in
                if let nowPlayingSong = playState.nowPlayingSong
                { //트랙킹 다를 경우 .load
                    
                    playState.youTubePlayer.getPlaybackState { completion in
                        switch completion{
                        case .success(let state):
                            if(playState.isPlaying != state) //만약 현재상태와 다를 때
                            {
                                print(state)
                                playState.isPlaying = state //state를 저장하고
                                
                                if(state == .ended) //만약 끝났을 때 다음 곡으로 넘겨준다.
                                {
                                    playState.forWard()
                                }
                            }
                            
                            
                        case.failure(let err):
                            print(err)
                            
                        }
                        
                    }
                    
                    if playState.currentSong != nowPlayingSong // 값이 다를경우
                    {
                        playState.currentSong = nowPlayingSong //곡 을 변경 후
                        if (playState.isPlaying == .playing || playState.isPlaying == .unstarted || playState.isPlaying == .ended)   {
                            
                            //playing , unstarted , ended 때만 load
                            
                            //만약 재새중에 옮겼다면  load
                            playState.youTubePlayer.load(source: .url(nowPlayingSong.url)) //바로 load
                        }
                        else //나머지는 cue
                        {
                            
                            playState.youTubePlayer.cue(source: .url(nowPlayingSong.url))
                        }
                    }
                    
                }
                
            }
    }
}

