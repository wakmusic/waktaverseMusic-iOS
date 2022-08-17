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
    var buttonModifier: PlayBarButtonImageModifier = PlayBarButtonImageModifier()
    var xWardButton: FullScreenButtonImageModifier = FullScreenButtonImageModifier()
    @Binding var gestureStore:CGSize
    let myDevice = UIDevice.current.userInterfaceIdiom
    var body: some View {
        
        if let currentSong = playState.nowPlayingSong
        {
           
            VStack(alignment: .leading) {
                
               
                
                HStack{
                    
                    Button {
                        withAnimation(Animation.spring(response: 0.7, dampingFraction: 0.85)) {
                            
                            //offset에 영향없게 상위 뷰의 gestureStore의 값을 0 으로
                            gestureStore.height = 0
                            gestureStore.width  = 0
                            playState.isPlayerViewPresented = true //play화면을 보여주고
                            playState.isPlayerListViewPresented = true // 리스트 화면까지 같이
                        }
                        
                        
                    }label: {
                        Image(systemName: "music.note.list")
                            .resizable()
                            .modifier(buttonModifier)
                        
                        
                    }
                    
                    VStack(alignment:.leading){
                        Text(currentSong.title)
                            .font(.custom("PretendardVariable-Regular", size: 18)).bold().lineLimit(1)
                        
                        Text(currentSong.artist)
                            .modifier(PlayBarArtistModifer())
                    }.padding(.vertical,2)
                    
                    
                    Spacer()
                    
                    HStack(spacing:15){
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
                        
                        
                    }
                    
                    
                }
                .padding(.horizontal)
                .background(.blue.opacity(0.5),in: RoundedRectangle(cornerRadius: 8))
                
            }

        }
        
        
    }
}




