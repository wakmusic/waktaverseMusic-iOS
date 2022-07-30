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
    var titleModifier = FullScreenTitleModifier()
    var artistModifier = FullScreenArtistModifer()
    
    let window = UIScreen.main.bounds
    var body: some View {
        let window = UIScreen.main.bounds
        let standardLen = window.width > window.height ? window.width : window.height
        if let currentSong = playState.nowPlayingSong
        {
            HStack{
                VStack {
                    Spacer(minLength: 0)
                    KFImage(URL(string: currentSong.image)!)
                        .resizable()
                        .scaledToFit()
                        .frame(width:standardLen*0.6,height: standardLen*0.6)
                        .padding()
                        .scaleEffect(playState.isPlaying == .play ? 1.0 : 0.8)
                        .shadow(color: .black.opacity(playState.isPlaying == .play ? 0.2:0.0), radius: 30, x: -60, y: 60)
                    //각 종 애니메이션
                    VStack{
                        Text(currentSong.title)
                            .modifier(titleModifier)
                        
                        Text(currentSong.artist)
                            .modifier(artistModifier)
                    }
                    .padding()
                    
                    Spacer(minLength: 0)
                    
                    PlayBar().environmentObject(playState)
                    
                    
                    
                    
                }
            }
            
            .frame(width: window.width, height: window.height)
            .padding(.horizontal)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 8)
                //백그라운드를 늘린 후  onTapGesture
            ).onTapGesture {
                playState.isPlayerViewPresented.toggle()
            }
            
            
            
        }
        
        
    }
}




struct PlayBar: View {
    
    
    
    var buttonModifier: FullScreenButtonImageModifier = FullScreenButtonImageModifier()
    @EnvironmentObject var playState:PlayState
    
    var body: some View {
        HStack
        {
            
            Button {
                print("List")
            }label: {
                Image(systemName: "music.note.list")
                    .resizable()
                    .modifier(buttonModifier)
            }
            
            
            Spacer()
            
            Button {
                playState.backWard()
                //토스트 메시지 필요
            } label: {
                Image(systemName: "backward.fill")
                    .resizable()
                    .modifier(buttonModifier)
                
            }
            
            PlayPuaseButton().environmentObject(playState)
            
            
            
            
            Button {
                playState.forWard()
                //토스트 메시지 필요
            } label: {
                Image(systemName: "forward.fill")
                    .resizable()
                    .modifier(buttonModifier)
                
            }
            
            Spacer()
            
            Button {
                print("Sound!!")
            } label: {
                Image(systemName: "speaker.wave.3.fill")
                    .resizable()
                    .modifier(buttonModifier)
                
            }
            
            
            
            
            
        }
        .accentColor(Color("PrimaryColor"))
    }
}
