//
//  ArtistScreenView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/12.
//

import SwiftUI

struct ArtistScreenView: View {
    
    let dummyDate:[Artist] = [Artist(artistId: "ine", name: "아이네", artistGroup: .isedol, image: ""),Artist(artistId: "jingburger", name: "징버거", artistGroup: .isedol, image: ""),Artist(artistId: "lilpa", name: "릴파", artistGroup: .isedol, image: ""),Artist(artistId: "jururu", name: "주르르", artistGroup: .isedol, image: ""),Artist(artistId: "gosegu", name: "고세구", artistGroup: .isedol, image: ""),Artist(artistId: "viichan", name: "비챤", artistGroup: .isedol, image: "")]
    
    let columns:[GridItem] = [GridItem(.fixed(300))]
    
    var body: some View {
        ZStack {
            Color.black
            ScrollView(.vertical,showsIndicators: false)
            {
                VStack(alignment:.leading){
                    
                    Text("ARTIST").font(.title).bold().foregroundColor(.white).frame(width: .infinity, alignment: .leading)
                    
                    //- MARK: CardView
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: columns) {
                            ForEach(dummyDate,id:\.self.id){ artist in
                                GeometryReader{ proxy in
                                    CardView(artist: artist)
                                        .rotation3DEffect(Angle(degrees: Double(proxy.frame(in: .global).minX) / -20), axis: (x: 0, y: 10.0, z: 0.0))
                                }
                                .frame(width:200,height: 300).padding(.horizontal)
                                
                                
                            }
                        }
                        
                    }.coordinateSpace(name: "CardViews")
                    
                    
                    
                    
                }
                
               
                
                
            }.padding(.top)
        }
        
    }
}


struct ArtistScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistScreenView()
    }
}
