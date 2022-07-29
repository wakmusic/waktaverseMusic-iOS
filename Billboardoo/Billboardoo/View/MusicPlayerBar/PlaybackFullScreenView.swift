//
//  PlaybackFullScreenView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/29.
//

import SwiftUI
import Kingfisher

struct PlaybackFullScreenView: View {
    
    var animation: Namespace.ID //화면전환을 위한 애니메이션 Identify
    @EnvironmentObject var playState:PlayState
    
    var body: some View {
        let window = UIScreen.main.bounds
        if let currentSong = playState.nowPlayingSong
        {
            
            HStack{
                VStack {
                    
                    Spacer(minLength: 0)
                    
                    KFImage(URL(string: currentSong.image)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .matchedGeometryEffect(id: currentSong.song_id + "art", in: animation)
                        .frame(width:300, height: 300)
                        .padding()
                        .scaleEffect(playState.isPlaying == .play ? 1.0 : 0.7)
                        .shadow(color: .black.opacity(playState.isPlaying == .play ? 0.2:0.0), radius: 30, x: -60, y: 60)
                        //각 종 애니메이션
                    
                    
                    VStack{
                        Text(currentSong.title)
                            .font(.headline)
                        
                        Text(currentSong.artist)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .matchedGeometryEffect(id: currentSong.song_id + "details" , in: animation)
                    
                    
                    Spacer(minLength: 0)
                    
                    HStack(spacing: 15){
                        
                        Button {
                            print("prev!!")
                        } label: {
                            Image(systemName: "backward.fill")
                            
                        }
                        
                        PlayPuaseButton().environmentObject(playState)
                            .matchedGeometryEffect(id: currentSong.song_id + "playButton" , in: animation)
                            .padding()
                            .padding(.horizontal)
                        
                        
                        Button {
                            print("next!!")
                        } label: {
                            Image(systemName: "forward.fill")
                            
                        }
                        
                        
                        
                        
                        
                    }.padding()
                        .accentColor(Color("PrimaryColor"))
                    
                }.onTapGesture {
                    playState.isPlayerViewPresented.toggle()
                }
            }
            .frame(width: window.width, height: window.height, alignment: .center)
            .background(
                .ultraThickMaterial,
                in: RoundedRectangle(cornerRadius: 8, style: .continuous)
            )
            
            
            
        }
        
        
    }
}


