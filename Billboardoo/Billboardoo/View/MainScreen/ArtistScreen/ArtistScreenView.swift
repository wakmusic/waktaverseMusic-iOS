//
//  ArtistScreenView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/12.
//

import SwiftUI
import Combine
import Kingfisher
import ScalingHeaderScrollView

struct ArtistScreenView: View {
    
    let columns:[GridItem] = [GridItem(.fixed(20),spacing: 20)]
    let window = UIScreen.main.bounds
    let device = UIDevice.current.userInterfaceIdiom
    let hasNotch = UIDevice.current.hasNotch
    
    @StateObject var viewModel = ArtistScreenViewModel()
    @EnvironmentObject var playState:PlayState
    @Binding var musicCart:[SimpleSong]
    @State var scrollToTop:Bool = false
    @State var selectedIndex:Int = 0
    
    
    
    
    var body: some View {
        
        
        ZStack(alignment: .top){
            
            ScalingHeaderScrollView {
                ZStack{
                    Color.forced
                    
                    VStack(spacing:0){
                        ArtistHeaderVIew(artists: $viewModel.artists,selectedid: $viewModel.selectedid)
                        
                            .overlay {
                                
                                VStack{
                                    Text("ARTIST").foregroundColor(.white).font(.system(size: device == . phone ? window.size.height/30 : window.size.height/35 , weight: .light, design: .default)).padding(.top,UIDevice.current.hasNotch ? 150 :  100)
                                    Text(viewModel.selectedid.uppercased()).foregroundColor(.white).font(.custom("LeferiPoint-Special", size:device == . phone ? window.size.height/25 : window.size.height/30 )).bold()
                                    // .padding(.top,UIDevice.current.hasNotch ? 30 : 50)
                                    Spacer()
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        
                                        LazyHGrid(rows: columns,alignment: device == .phone ? .top : .bottom,spacing: 10) {
                                            ForEach(viewModel.artists,id:\.self.id){ artist in
                                                
                                                CardView(artist: artist,selectedId: $viewModel.selectedid)
                                                
                                            }
                                        }
                                        
                                        
                                    }.frame(height: device == .phone ? window.height/4 : window.height/7  )
                                    
                                    
                                }
                                
                            }
                       
                        ArtistPinnedHeader(selectedIndex: $selectedIndex,chart: $viewModel.currentShowChart,scrollToTop: $scrollToTop).environmentObject(playState)
                    }
                }
            } content: {
                LazyVStack(spacing: 0){
                    
                    ForEach(viewModel.currentShowChart,id:\.self.id){ (song:NewSong) in
                        ArtistSongListItemView(song: song,accentColor: .primary,musicCart: $musicCart).environmentObject(playState)
                        
                    }
                    
                
                }.onChange(of: viewModel.selectedid) { newValue in
                    viewModel.fetchSongList(newValue)
                    scrollToTop = true
                    selectedIndex = 0 // 아티스트 변경시 최신순으로
                    
                    
                }
                .animation(.ripple(), value: viewModel.currentShowChart)
                
            }
            
            .height(min: hasNotch == true ?  window.height/4.5 : window.height/5, max: hasNotch == true ? window.height/2 : window.height/1.8)
            .scrollToTop(resetScroll: $scrollToTop)
            
            
            
        }
        
        .ignoresSafeArea(.container, edges: .all)
        
        
    }
}

struct ArtistHeaderVIew: View{
    let columns:[GridItem] = [GridItem(.fixed(0))]
    @Binding var artists:[Artist]
    @Binding var selectedid:String
    let window = UIScreen.main.bounds
    let url = "https://billboardoo.com/artist/image/big/"
    let hasNotch:Bool = UIDevice.current.hasNotch
    var body: some View{
        
        
        KFImage(URL(string: "\(url)\(selectedid).jpg")!)
            .placeholder({
                Image("bigholder")
                    .resizable()
                    .scaledToFill()
            })
            .resizable()
            .scaledToFill()
            .overlay {
                ZStack() {
                    LinearGradient(colors: [.clear,.normal.opacity(1)], startPoint: .top, endPoint: .bottom)
                    
                    
                }
            }
            
        
        
        
        
    }
    
}


struct ArtistSongListItemView: View {
    
    
    var song:NewSong
    @EnvironmentObject var playState:PlayState
    var accentColor:Color
    @Binding var musicCart:[SimpleSong]
    var body: some View {
        let simpleSong = SimpleSong(song_id:song.song_id, title: song.title, artist: song.artist, image: song.image, url: song.url)
        
        
        HStack{
            
            KFImage(URL(string: song.image.convertFullThumbNailImageUrl()))
                .placeholder({
                    Image("placeHolder")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .transition(.opacity.combined(with: .scale))
                })
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width:45,height: 45)
                .clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
                .padding(.leading,5)
            
            VStack(alignment:.leading,spacing: 8)
            {
                Text(song.title).foregroundColor(accentColor).font(.caption2).bold().lineLimit(1)
                Text(song.artist).foregroundColor(accentColor).font(.caption2).lineLimit(1)
            }.frame(maxWidth: .infinity ,alignment: .leading)
            
            
            
            
            
            // -Play and List Button
            
            Text(convertTimeStamp2(song.date)).foregroundColor(accentColor).font(.caption2).lineLimit(1)
            
            
            
            
            
            
            
            
            
            Spacer()
            
        }
        .padding(.vertical,5)
        
        .contentShape(Rectangle()) // 빈곳을 터치해도 탭 인식할 수 있게, 와 대박 ...
        .onTapGesture {
            
            if(musicCart.contains(simpleSong))
            {
                musicCart = musicCart.filter({$0 != simpleSong})
            }
            else
            {
                musicCart.append(simpleSong)
            }
        }
        
        
        .background(musicCart.contains(simpleSong) == true ? Color.tabBar : .clear)
        
        
        
    }
    
}

struct ArtistPinnedHeader: View {
    @Binding var selectedIndex:Int
    @EnvironmentObject var playState:PlayState
    @Binding var chart:[NewSong]
    let window = UIScreen.main.bounds.size
    let hasNotch = UIDevice.current.hasNotch
    @Namespace var animation
    @Binding var scrollToTop:Bool
  
    
    let sorting:[String] = ["최신순","인기순","오래된 순"]
    
    var body: some View{
        
        VStack(alignment:.leading,spacing: hasNotch ? 30 :10){
            
            HStack(spacing:5)
            {
                ForEach(sorting.indices, id: \.self){ idx in
                    
                    VStack(spacing:10){
                        
                        Text(sorting[idx])
                            .font(.system(size: 15)) //
                            .foregroundColor(selectedIndex == idx ? Color.primary : .gray)
                        
                        ZStack{ //움직이는 막대기
                            if (selectedIndex == idx) {
                                RoundedRectangle(cornerRadius: 4 , style:  .continuous).fill( Color.primary).matchedGeometryEffect(id: "FILLTERTAB", in: animation)
                                
                                
                            }
                            else{
                                RoundedRectangle(cornerRadius: 4 , style:  .continuous) .fill(.clear)
                                
                            }
                        }
                       
                        .frame(height:4)
                        .padding(.horizontal)
                    }
                    .frame(width:window.width/3) // 중간에 넣기위해 width를 6등분
                    .contentShape(Rectangle())
                    .padding(.top)
                    .onTapGesture {
                        
                        withAnimation(.easeInOut){ // 처음에 불러왔을 때는 최신 순 이므로 selectedIndex = 0 그리고 ripple 말고 tranistion 이용
                            
                           
                            
                            if(selectedIndex != idx)
                            {
                                selectedIndex = idx
                                switch(selectedIndex){
                                
                                case 0:
                                    chart.sort {
                                        $0.date > $1.date // 최신 순 (뒤에가 작은게 참) 최신순일 수록 값이 큼
                                    }
                                
                                case 1:
                                    chart.sort {
                                        $0.views > $1.views // 인기순
                                    }
                                    
                                case 2:
                                    chart.sort {
                                        $0.date < $1.date // 오래된 순 (뒤에가 큰게 참)
                                    }
                                    
                                default:
                                    print("현재 선택된 필터 값\(selectedIndex)")
                                    
                                }
                                scrollToTop = true
                                
                                
                                
                               
                            }
                            
                        }
                    }
                }
            }
            
            
            HStack{
                Spacer()
                RoundedRectangleButton(width: window.width/2.5, height: window.width/15, text: "전체 재생", color: .tabBar ,textColor: .primary, imageSource: "play.fill")
                    .onTapGesture {
                        playState.playList.removeAll() //전부 지운후
                        playState.playList = castingFromNewSongToSimple(newSongList: chart)  // 현재 해당 chart로 덮어쓰고
                        playState.currentPlayIndex = 0 // 인덱스 0으로 맞춤
                        playState.youTubePlayer.load(source: .url(chart[0].url)) //첫번째 곡 재생
                      
                        
                    }
                Spacer()
                
                RoundedRectangleButton(width: window.width/2.5, height: window.width/15, text: "셔플 재생", color:.tabBar,textColor: .primary, imageSource: "shuffle")
                    .onTapGesture {
                        
                        playState.playList.removeAll() //전부 지운후
                        playState.playList = castingFromNewSongToSimple(newSongList: chart) // 현재 해당 chart로 덮어쓰고
                        shuffle(playlist: &playState.playList)  //셔플 시킨 후
                        playState.currentPlayIndex = 0 // 인덱스 0으로 맞춤
                        playState.youTubePlayer.load(source: .url(chart[0].url)) //첫번째 곡 재생
                        
                        
                    }
                Spacer()
            }
            
            //.offset(y: hasNotch == true ? 20 : 0)
            
            

    
            
        }.frame(height:window.height/5)
    }
}

extension ArtistScreenView{
    
    final class ArtistScreenViewModel:ObservableObject{
        
        @Published var selectedid:String = "woowakgood"
        @Published var artists:[Artist] = [Artist] ()
        @Published var currentShowChart:[NewSong] = [NewSong]()
        var subscription = Set<AnyCancellable>()
        
        init()
        {
            fetchArtist()
            fetchSongList("woowakgood")
        }
        
        
        
        func fetchArtist(){
            Repository.shared.fetchArtists().sink { completion in
                
                
                
            } receiveValue: { [weak self] (data:[Artist]) in
                guard let self = self else {return}
                
                self.artists = data.filter { (artist:Artist) in
                    artist.artistId != nil //더미데이터 제거
                }
                
                
            }.store(in: &subscription)
            
        }
        
        func fetchSongList(_ name:String)
        {
            Repository.shared.fetchSearchSongsList(name).sink { completion in
                
            } receiveValue: { [weak self] (data:[NewSong]) in
                guard let self = self else {return}
                
                
                
                self.currentShowChart = data
            }.store(in: &subscription)
            
        }
        
        
        
    }
    
}

func convertTimeStamp2(_ time:Int) -> String{
    let convTime:String = String(time)
    let year:String = convTime.substring(from: 0, to: 1)
    let month:String = convTime.substring(from: 2, to: 3)
    let day:String = convTime.substring(from: 4, to: 5)
    
    
    return "20\(year).\(month).\(day)"
    
}

func castingFromNewSongToSimple(newSongList:[NewSong]) ->[SimpleSong]
{
    var simpleList:[SimpleSong] = [SimpleSong]()
    
    
    for nSong in newSongList {
        simpleList.append(SimpleSong(song_id: nSong.song_id, title: nSong.title, artist: nSong.artist, image: nSong.image, url: nSong.url))
    }
    
    return simpleList
}



