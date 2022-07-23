//
//  FiveRowSongGridMoreView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/22.
//

import SwiftUI

struct FiveRowSongGridView: View {
    private let rows = [GridItem(.fixed(40), spacing: 20), //fixed 행 크기 ,spacing, 행간의 거리
                        GridItem(.fixed(40), spacing: 20),
                        GridItem(.fixed(40), spacing: 20),
                        GridItem(.fixed(40), spacing: 20),
                        GridItem(.fixed(40), spacing: 20)]
    
    var temp_data : [SimpleViwer] = [SimpleViwer(id: "0", title: "리와인드 (RE:WIND)", artist: "이세계아이돌", image: "https://i.imgur.com/pobpfa1.png", url: "https://youtu.be/fgSXAKsq-Vo", last: 100),SimpleViwer(id: "1", title: "팬서비스", artist: "고세구", image: "https://i.ytimg.com/vi/DPEtmqvaKqY/hqdefault.jpg", url: "https://youtu.be/DPEtmqvaKqY", last: 2),SimpleViwer(id: "2", title: "겨울봄", artist: "이세계아이돌", image: "https://i.imgur.com/8Y10Qq9.png", url: "https://youtube/JY-gJkMuJ94", last: 2),SimpleViwer(id: "10", title: "Promise", artist: "릴파", image: "https://i.ytimg.com/vi/6hEvgKL0ClA/hqdefault.jpg", url: "https://youtu.be/6hEvgKL0ClA", last: 4),SimpleViwer(id: "4", title: "왁맥송 #Shorts", artist: "우왁굳", image: "https://i.ytimg.com/vi/08meo6qrhFc/hqdefault.jpg", url: "https://youtu.be/08meo6qrhFc", last: 5),SimpleViwer(id: "5", title: "SCIENTIST", artist: "주르르 (ft. 아이네)", image: "https://i.ytimg.com/vi/rFxJjpSeXHI/hqdefault.jpg", url: "https://youtu.be/rFxJjpSeXHI", last: 6)]
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(alignment: .leading) {
                LazyHGrid(rows: rows,spacing: 30){ //GridItem 형태와, 요소간 옆 거리
                    fiveRowSongGridItemViews
                }
            }
        }.padding()
        
    }
}


private extension FiveRowSongGridView {
    var fiveRowSongGridItemViews: some View {
        ForEach(temp_data.indices){ index in
            ZStack() {
                HStack() {
                    AlbumImageView(url: temp_data[index].image)
                    RankView(now: index+1, last: temp_data[index].last)
                    
                    
                    //타이틀 , Artist 영역
                    VStack(alignment: .leading) {
                        Text("\(temp_data[index].title)").font(.system(size:13))
                        Text("\(temp_data[index].artist)").font(.system(size:11))
                    }.frame(width:150)
                    
                    
                    Button {
                        print(temp_data[index].url)
                    } label: {
                        Image(systemName: "play.fill").foregroundColor(Color("PrimaryColor"))
                    }
                    
                }
            }
        }
    }
}

struct FiveRowSongGridView_Previews: PreviewProvider {
    static var previews: some View {
        FiveRowSongGridView()
    }
}

struct AlbumImageView: View {
    
    var url:String
    var body: some View {
        AsyncImage(url: URL(string:url), transaction: .init(animation: .spring())) { phase in
            
            switch phase{
            case .empty:
                Image("placeHolder")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .transition(.opacity.combined(with: .scale))
                
                
            case .success(let image):
                image
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                
            case .failure(let error):
                Image("placeHolder")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .transition(.opacity.combined(with: .scale))
                
                
                
            }
            
        }
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
            
            
            Text("\(now_rank)").font(.system(size:18,weight: .bold))
            
            Text(change_rank).font(.system(size: 15, weight: .bold)).foregroundColor(color)
        }.frame(width: 40)
    }
}


