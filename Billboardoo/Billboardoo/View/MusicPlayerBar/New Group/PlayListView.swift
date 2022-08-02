//
//  PlayListView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/01.
//

import SwiftUI

struct PlayListView: View {
    
    @EnvironmentObject var playState:PlayState
    
    var body: some View {
       
        NavigationView{
            VStack{
                if (playState.playList.count == 0)
                {
                    Text("Empty")
                }
                else
                {
                    List(playState.playList){ song in
                        Text(song.title)
                    }
                    
                }
            }
            
        }.navigationViewStyle(.stack)
        
        
        
    }
}

struct PlayListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayListView().environmentObject(PlayState())
    }
}
