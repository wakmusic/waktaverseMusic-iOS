//
//  SwiftUIView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/11.
//

import SwiftUI
import Foundation
import Combine
import Kingfisher


struct NewsMoreView: View {
    
    @EnvironmentObject var playState:PlayState
    @Binding var news:[NewsModel]
    //let columns:[GridItem] = [GridItem(.fixed(220))] //row 높이
    let columns:[GridItem] = Array(repeating: GridItem(.fixed(180),spacing: 20), count: Int(UIScreen.main.bounds.width)/180)
    
    //GridItem 크기 130을 기기의 가로크기로 나눈 몫 개수로 다이나믹하게 보여줌
    
    //private var columns:[GridItem] = [GridItem]()
    
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(alignment:.center)
            {
                
                LazyVGrid(columns:columns)
                {
                    ThreeColumnsGrid
                }
            }
            if(playState.nowPlayingSong != nil) // 플레이어 바 나올 때 그 만큼 올리기 위함
            {
                
                Spacer(minLength: 60)
                
                
            }
            
        }.navigationTitle("NEWS")
            .navigationBarTitleDisplayMode(.large)
    }
}

extension NewsMoreView{
    var ThreeColumnsGrid: some View{
        
        ForEach(news,id:\.self.id){ data in
            
            NavigationLink {
                CafeWebView(urlToLoad: "\(ApiCollections.newsCafe)\(data.newsId)")
            } label: {
                VStack(alignment:.leading,spacing: 20){
                    KFImage(URL(string: "\(ApiCollections.newsThumbnail)\(data.time).png")!)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(width: 180, height: 120,alignment: .center)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.8), radius: 10, x: 0, y: 0)
                    Text(data.title.replacingOccurrences(of: "이세돌포커스 -", with: "")).font(.title3).lineLimit(1)
                }.frame(width: 180)
            }
            
            
            
            
        }
        
    }
    
    func convertTimeStamp(_ time:Int) -> String{
        let convTime:String = String(time)
        let year:String = convTime.substring(from: 0, to: 1)
        let month:String = convTime.substring(from: 2, to: 3)
        let day:String = convTime.substring(from: 4, to: 5)
        
        
        return "20\(year).\(month).\(day)"
        
    }
    
}

