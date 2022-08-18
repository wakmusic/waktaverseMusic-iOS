//
//  FiveRowSongGridMoreView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/22.
//

import SwiftUI
import Kingfisher

struct FiveRowSongGridView: View {
    
    
    
    private let rows = [GridItem(.fixed(40), spacing: 10), //fixed 행 크기 ,spacing, 행간의 거리
                        GridItem(.fixed(40), spacing: 10),
                        GridItem(.fixed(40), spacing: 10),
                        GridItem(.fixed(40), spacing: 10)]
    
    @Binding var nowChart:[RankedSong]
    @EnvironmentObject var playState:PlayState
    
    
    
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(alignment: .leading) {
                LazyHGrid(rows: rows,spacing: 30){ //GridItem 형태와, 요소간 옆 거리
                    fiveRowSongGridItemViews.environmentObject(playState)
                }
            }
        }.padding()
        
    }
}


private extension FiveRowSongGridView {
    
    var fiveRowSongGridItemViews: some View {
        
        
        ForEach(nowChart.indices,id: \.self){ index in //여기서 id설정이 굉장히 중요하다. indices로 접근하기 때문에 속성의 id 말고 \.self를 사용함
            let song = nowChart[index]
            ZStack{
                HStack() {
                    AlbumImageView(url: nowChart[index].image)
                    RankView(now: index+1, last: nowChart[index].last)
                    
                    
                    //타이틀 , Artist 영역
                    VStack() {
                        Text("\(nowChart[index].title)").font(.system(size:13)).frame(width:150,alignment: .leading)
                        Text("\(nowChart[index].artist)").font(.system(size:11)).frame(width:150,alignment: .leading)
                    }
                    Button {
                        //FiveRowSong Grid에서는 재생 버튼 누르면 일단 load와 currentSong을 바꿈
                        let simpleSong = SimpleSong(song_id: song.song_id, title: song.title, artist: song.artist, image: song.image, url: song.url)
                        if(playState.currentSong != simpleSong)
                        {
                            playState.currentSong =  simpleSong //강제 배정
                            playState.youTubePlayer.load(source: .url(simpleSong.url)) //강제 재생
                            playState.uniqueAppend(item: simpleSong) //현재 누른 곡 담기
                        }
                        
                        
                        
                    } label: {
                        Image(systemName: "play.fill").foregroundColor(Color.primary)
                    }
                    
                }
            }
        }
    }
}


struct AlbumImageView: View {
    
    var url:String
    var body: some View {
        KFImage(URL(string: url)!)
            .cancelOnDisappear(true)
            .placeholder {
                Image("placeHolder")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .transition(.opacity.combined(with: .scale))
            }
            .onSuccess { result in
                
            }
            .onFailure { err in
                print("Error: ,\(err)")
            }
        
            .resizable()
            .frame(width: 40, height: 40) //resize
    }
}






struct RankView: View {
    
    var now_rank:Int
    var color:Color = .accentColor
    var change_rank:String = " "
    
    
    init(now:Int,last:Int)
    {
        self.now_rank = now
        if(now_rank>last) //랭크가 낮아지면
        {
            color = Color("RankDownColor")
            change_rank = "▼ \(self.now_rank - last)"
        }
        else if(now_rank==last)
        {
            color = Color("RankNotChangeColor")
            change_rank = "-"
        }
        else
        {
            color = Color("RankUpColor")
            change_rank = "▲ \(last - self.now_rank)"
        }
    }
    
    var body: some View {
        
        
        
        VStack(alignment: .center){
            
            
            Text("\(now_rank)").font(.system(size:13,weight: .bold))
            
            Text(change_rank).font(.system(size: 10, weight: .bold)).foregroundColor(color)
        }.frame(width: 35)
    }
}


