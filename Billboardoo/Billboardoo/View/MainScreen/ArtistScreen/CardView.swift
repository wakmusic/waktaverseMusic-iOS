//
//  CardView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/13.
//

import SwiftUI
import Kingfisher

struct CardView: View {
    
    var artist:Artist
    @Binding var selectedId:String
   // var size:CGSize
    let window = UIScreen.main.bounds
    var body: some View {
        
      
           
            VStack()
            {
                Image(artist.artistId)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .mask(Circle())
                    //.frame(maxWidth:.infinity,maxHeight: .infinity)
                    //.shadow(color: Color(uiColor: shadowcolor ?? .black), radius: 8, x: 0, y: 3)
                    //.shadow(color: Color(uiColor: shadowcolor ?? .black), radius: 2, x: 0, y: 1)
                
                Text(artist.name).font(.title3).foregroundColor(.white)
            }.onTapGesture {
                
                withAnimation(.default)
                {
                    selectedId = artist.artistId
                }
                
                
            }
            
        
       
        .frame(width:window.width/6,height:window.height/6)
        .padding(.horizontal,30)
        .scaleEffect(selectedId == artist.artistId ? 1 : 0.8)
        
        
        
        
    }
}


