//
//  PlaybackBarView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/29.
//

import SwiftUI
import Kingfisher
import UIKit

struct PlaybackBarView: View {
    
    var animation: Namespace.ID // 화면전환을 위한 애니메이션 Identify
    @EnvironmentObject var playState:PlayState
    
    var body: some View {
        
        if let currentSong = playState.nowPlayingSong
        {
            VStack {
                
                Spacer(minLength: 0)
                HStack{
                    
                    KFImage(URL(string: currentSong.image)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .matchedGeometryEffect(id: currentSong.song_id  + "art", in: animation)
                        .frame(width: 50, height: 50)
                    
                    
                    VStack(alignment:.leading){
                        Text(currentSong.title)
                            .font(.headline)
                        
                        Text(currentSong.artist)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }.matchedGeometryEffect(id: currentSong.song_id + "details" , in: animation)
                    
                    
                    
                    Spacer()
                    
                    HStack{
                        
                        Button {
                            print("prev!!")
                        } label: {
                            Image(systemName: "backward.fill")
                                .foregroundColor(Color("PrimaryColor"))
                            
                        }
                        
                        PlayPuaseButton().environmentObject(playState)
                            .matchedGeometryEffect(id: currentSong.song_id + "playButton" , in: animation)
                        
                    }

                }.background(.ultraThickMaterial,in: RoundedRectangle(cornerRadius: 8))
            }.onTapGesture {
                playState.isPlayerViewPresented.toggle()
            }
            
        }
        
        
    }
}




