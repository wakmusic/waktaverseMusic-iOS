//
//  NewSongOfTheMonth.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/11.
//

import SwiftUI

struct NewSongOfTheMonth: View {
    
    @EnvironmentObject var playState:PlayState
    
    var body: some View {
        AlbumHeader().environmentObject(playState)
        Divider()
        ScrollView(.horizontal, showsIndicators: false) {
            
        }
    }
}


struct AlbumHeader: View {
    
    @EnvironmentObject var playState:PlayState
    
    
    var body: some View {
        
        
        VStack(alignment:.leading,spacing: 5){
            HStack {
                Text("이달의 신곡").bold().foregroundColor(Color("PrimaryColor"))
                Spacer()
                
                NavigationLink {
                    Text("Move")
                } label: {
                    Text("더보기").foregroundColor(.gray)
                }
                
                
            }
        }.padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
    }
}

struct NewSongOfTheMonth_Previews: PreviewProvider {
    static var previews: some View {
        NewSongOfTheMonth().environmentObject(PlayState())
    }
}
