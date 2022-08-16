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
    let device = UIDevice.current.userInterfaceIdiom
    let url = "https://billboardoo.com/artist/image/card/"
    var body: some View {
        
      
           
            VStack()
            {
                KFImage(URL(string: "\(url)\(artist.artistId!).png")!)
                    .placeholder({
                        Image("cardholder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    })
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .mask(Circle())
                    //.frame(maxWidth:.infinity,maxHeight: .infinity)
                    .shadow(color: Color(hexcode: artist.color!), radius: 8, x: 0, y: 3)
                    .shadow(color: Color(hexcode: artist.color!), radius: 2, x: 0, y: 1)
                
                Text(artist.name!).font(.title3).foregroundColor(.white).lineLimit(1)
            }.onTapGesture {
                
                    selectedId = artist.artistId!
                
                
            }
            
        
       
            .frame(width:device == .phone ? window.width/6 : window.width/7 ,height:device == .phone ? window.height/7 : window.height/10)
        .padding(.horizontal,10)
        .padding(.vertical,20)
        .scaleEffect(selectedId == artist.artistId ? 1 : 0.8)
        
        
        
        
    }
}


