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
    var buttonModifier: FullScreenButtonImageModifier = FullScreenButtonImageModifier()
    let window = UIScreen.main.bounds
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
                        .frame(width:window.width*0.6, height: window.width*0.6)
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
                    
                    HStack(spacing: 20){
                        
                        Button {
                            print("List")
                        }label: {
                            Image(systemName: "music.note.list")
                                .resizable()
                                .modifier(buttonModifier)
                            
                        }
                        
                        
                        Button {
                            print("prev!!")
                        } label: {
                            Image(systemName: "backward.fill")
                                .resizable()
                                .modifier(buttonModifier)
                            
                        }
                        
                        PlayPuaseButton().environmentObject(playState)
                        
                        
                        
                        
                        Button {
                            print("next!!")
                        } label: {
                            Image(systemName: "forward.fill")
                                .resizable()
                                .modifier(buttonModifier)
                            
                        }
                        
                        
                        
                    }
                    .accentColor(Color("PrimaryColor"))
                    
                    
                }
            }
            
            .frame(width: window.width, height: window.height)
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



