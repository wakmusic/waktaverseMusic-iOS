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


struct NewSongMoreView: View {
    
    @EnvironmentObject var playState:PlayState
    @Binding var newsongs:[NewSong]
    let columns:[GridItem] = Array(repeating: GridItem(.fixed(130)), count: Int(UIScreen.main.bounds.width)/130)
    
    //GridItem 크기 130을 기기의 가로크기로 나눈 몫 개수로 다이나믹하게 보여줌
    
    //private var columns:[GridItem] = [GridItem]()
    
    
    
    var body: some View {
        
        if(newsongs.count == 0)
        {
            VStack{
                Text("이달의 신곡이 아직 없습니다.").modifier(PlayBarTitleModifier())
            }.frame(width:.infinity,height: .infinity, alignment: .center)
            
        }
        else
        {
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment:.center)
                {
                    
                    
                    
                    LazyVGrid(columns:columns)
                    {
                        ThreeColumnsGrid
                    }
                    
                    
                }
                
                
            }.navigationTitle("이달의 신곡")
        }
       
    }
}

extension NewSongMoreView{
    var ThreeColumnsGrid: some View{
        
        ForEach(newsongs,id:\.self.id){ song in
            
            VStack(alignment:.center){
                
                
                
                KFImage(URL(string: song.image)!)
                    .resizable()
                    .frame(width:100,height: 100)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(10)
                    .overlay {
                        ZStack{
                            Button {
                                let simpleSong = SimpleSong(song_id: song.song_id, title: song.title, artist: song.artist, image: song.image, url: song.url)
                                
                                if(playState.currentSong != simpleSong)
                                {
                                    playState.currentSong =  simpleSong //강제 배정
                                    playState.youTubePlayer.load(source: .url(simpleSong.url)) //강제 재생
                                    playState.uniqueAppend(item: simpleSong) //현재 누른 곡 담기
                                }
                                
                                
                            } label: {
                                Image(systemName: "play.fill").foregroundColor(.white)
                            }
                            
                        }.frame(width:85,height:85,alignment: .topTrailing)
                    }
                    .frame(width: 100, height: 100,alignment: .center)
                
                VStack(alignment:.leading) {
                    Text(song.title).font(.system(size: 13, weight: .semibold, design: Font.Design.default)).lineLimit(1)
                    Text(song.artist).font(.caption).lineLimit(1)
                    Text(convertTimeStamp(song.date)).font(.caption2).foregroundColor(.gray).lineLimit(1)
                }.frame(width: 100)
                
            }.padding()
            
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

