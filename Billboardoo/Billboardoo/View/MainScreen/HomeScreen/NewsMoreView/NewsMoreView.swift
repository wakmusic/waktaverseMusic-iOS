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
    let columns:[GridItem] = Array(repeating: GridItem(.flexible()), count: Int(UIScreen.main.bounds.width)/180)
    @GestureState private var dragOffset = CGSize.zero // 스와이프하여 뒤로가기를 위해
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> // 스와이프하여 뒤로가기를 위해
    
    //GridItem 크기 130을 기기의 가로크기로 나눈 몫 개수로 다이나믹하게 보여줌
    
    //private var columns:[GridItem] = [GridItem]()
    
    
    
    var body: some View {
        ZStack{
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment:.center)
                {
                    
                    LazyVGrid(columns:columns)
                    {
                        ThreeColumnsGrid
                    }
                }

                
            }
        }
        
        .navigationTitle("NEWS")
            .navigationBarTitleDisplayMode(.large)
        .background()
        .highPriorityGesture((DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            
            if(value.translation.width > 100) // 왼 오 드래그가 만족할 때
            {
                self.presentationMode.wrappedValue.dismiss() //뒤로가기
            }
            
            
        }))) //부모 제스쳐가 먼져 ( swipe 하여 나가는게 NavigationLink의 클릭 이벤트 보다 우선)
      
          

    }
}

extension NewsMoreView{
    var ThreeColumnsGrid: some View{
        
        ForEach(news,id:\.self.id){ data in
            
            NavigationLink {
                CafeWebView(urlToLoad: "\(ApiCollections.newsCafe)\(data.newsId)")
            } label: {
                VStack(alignment:.leading,spacing: 5){
                    KFImage(URL(string: "\(ApiCollections.newsThumbnail)\(data.time).png")!)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(width: 180, height: 120,alignment: .center)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.8), radius: 10, x: 0, y: 0)
                    Text(data.title.replacingOccurrences(of: "이세돌포커스 -", with: "")).font(.system(size: 15, weight: .semibold, design: .default)).lineLimit(1)
                    
                }
            }.frame(width: 180)
                
            
            
            
            
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

