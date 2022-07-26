//
//  FiveRowSongGridMoreView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/22.
//

import SwiftUI
import Kingfisher

struct FiveRowSongGridView: View {
    private let rows = [GridItem(.fixed(40), spacing: 20), //fixed 행 크기 ,spacing, 행간의 거리
                        GridItem(.fixed(40), spacing: 20),
                        GridItem(.fixed(40), spacing: 20),
                        GridItem(.fixed(40), spacing: 20),
                        GridItem(.fixed(40), spacing: 20)]
    
    @Binding var displayChart:[SimpleViwer]
    
    
    
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(alignment: .leading) {
                LazyHGrid(rows: rows,spacing: 30){ //GridItem 형태와, 요소간 옆 거리
                    fiveRowSongGridItemViews
                }
            }
        }.padding().onAppear{
            print(displayChart.count)
        }
        
    }
}


private extension FiveRowSongGridView {
    var fiveRowSongGridItemViews: some View {
    
        
        ForEach(displayChart.indices){ index in
            ZStack{
                HStack() {
                    AlbumImageView(url: displayChart[index].image)
                    RankView(now: index+1, last: displayChart[index].last)
                    
                    
                    //타이틀 , Artist 영역
                    VStack() {
                        Text("\(displayChart[index].title)").font(.system(size:13)).frame(width:150,alignment: .leading)
                        Text("\(displayChart[index].artist)").font(.system(size:11)).frame(width:150,alignment: .leading)
                    }
                    Button {
                        print(displayChart[index].url)
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
        
        
        FiveRowSongGridView(displayChart: .constant([SimpleViwer]()))
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
                print("Image Fetch success")
            }
            .onFailure { err in
                print("Error: ,\(err)")
            }
            
            .resizable()
            .frame(width: 40, height: 40) //resize
    }
}
            

        //        AsyncImage(url: URL(string:url), transaction: .init(animation: .spring())) { phase in
        //
        //            switch phase{
        //            case .empty:
        //                Image("placeHolder")
        //                    .resizable()
        //                    .frame(width: 40, height: 40, alignment: .center)
        //                    .transition(.opacity.combined(with: .scale))
        //
        //
        //            case .success(let image):
        //                image
        //                    .resizable()
        //                    .frame(width: 40, height: 40, alignment: .center)
        //
        //            case .failure(let error):
        //                Image("placeHolder")
        //                    .resizable()
        //                    .frame(width: 40, height: 40, alignment: .center)
        //                    .transition(.opacity.combined(with: .scale))
        
        
        



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
            
            
            Text("\(now_rank)").font(.system(size:16,weight: .bold))
            
            Text(change_rank).font(.system(size: 13, weight: .bold)).foregroundColor(color)
        }.frame(width: 40)
    }
}


