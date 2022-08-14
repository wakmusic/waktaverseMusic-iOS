//
//  CardView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/13.
//

import SwiftUI

struct CardView: View {
    
    var artist:Artist
    var body: some View {
       
        ZStack() {
            let artwork = UIImage(named: artist.artistId)
                
            let shadowcolor = artwork?.averageColor
           VStack
            {
                Image(artist.artistId)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .mask(RoundedRectangle(cornerRadius: 30,style: .continuous))
                    .frame(maxWidth:.infinity,maxHeight: .infinity)
                    .shadow(color: Color(uiColor: shadowcolor ?? .black), radius: 8, x: 0, y: 12)
                    .shadow(color: Color(uiColor: shadowcolor ?? .black), radius: 2, x: 0, y: 1)
                
                Text(artist.name).font(.title).foregroundColor(.white)
            }
            
        }
        
        .padding(30)
        .frame(width:200,height: 280)
        
        
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(artist: Artist(artistId: "ine", name: "아이네", artistGroup: .isedol, image: ""))
    }
}
