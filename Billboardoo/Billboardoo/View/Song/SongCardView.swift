//
//  SongCardView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/29.
//

import SwiftUI
import Kingfisher

struct SongCardView: View {
    
    @EnvironmentObject var playState:PlayState
    var body: some View {
        let currentSong =  playState.nowPlayingSong
        HStack{
            
            KFImage(URL(string: currentSong!.image)!).resizable()
                .frame(width: 50, height: 50)
            
            VStack(alignment:.leading){
                Text(currentSong?.title ?? "")
                    .font(.headline)
                
                Text(currentSong?.artist ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            
            Button {
                
            } label: {
                Image(systemName: "backward.fill")
                
            }
            
            Button {
               
            } label: {
                Image(systemName: "play.fill")
                
            }
            
            Button {
                
            } label: {
                Image(systemName: "forward.fill")
                
            }
            
            
            Spacer()
            
        }.padding(10)
    }
}

struct SongCardView_Previews: PreviewProvider {
    static var previews: some View {
        SongCardView().environmentObject(PlayState())
    }
}

