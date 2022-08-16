//
//  ArtistScreenView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/12.
//

import SwiftUI
import Combine
import Kingfisher

struct ArtistScreenView: View {
    
    let columns:[GridItem] = [GridItem(.fixed(20),spacing: 20)]
    let window = UIScreen.main.bounds
    
    @StateObject var viewModel = ArtistScreenViewModel()
    @EnvironmentObject var playState:PlayState
    
    
    var body: some View {
       
            ZStack {
                Color.black
                
                
                
                ScrollView(.vertical,showsIndicators: false)
                {
                    ArtistHeaderVIew(artists: $viewModel.artists,selectedid: $viewModel.selectedid)
                        .overlay {
                            
                            VStack{
                                Spacer()
                                Text("BILLBOARDOO CHART").foregroundColor(.white).font(.system(size: window.size.height/40, weight: .light, design: .default)).padding(.top,UIDevice.current.hasNotch ? 150 :  100)
                                Text("ARTISTS").foregroundColor(.white).font(.custom("LeferiPoint-Special", size: window.height/30)).bold()
                                   // .padding(.top,UIDevice.current.hasNotch ? 30 : 50)
                                Spacer()
                                ScrollView(.horizontal, showsIndicators: false) {
                                    
                                    LazyHGrid(rows: columns,alignment: .bottom) {
                                        ForEach(viewModel.artists,id:\.self.id){ artist in
                                            
                                            CardView(artist: artist,selectedId: $viewModel.selectedid)
                                            
                                        }
                                    }
                                    
                                    
                                }.frame(height:window.height/5).zIndex(2)
                            }
                           
                        }
                    
                    Spacer(minLength: 50)
                    LazyVStack(alignment:.center,pinnedViews: .sectionHeaders){
                        Section {
                            ForEach(viewModel.currentShowChart,id:\.self.id){ (song:NewSong) in
                                SongListItemView(song: song).environmentObject(playState)
                                
                            }
                            
                        } header: {
                            
                            ArtistPinnedHeader(chart: $viewModel.currentShowChart).environmentObject(playState)
                            
                            
                        }
                    }.onChange(of: viewModel.selectedid) { newValue in
                        viewModel.fetchSongList(newValue)
                    }
                    
                    
                    
                    Spacer(minLength: 100)
                    if(playState.nowPlayingSong != nil) // 플레이어 바 나올 때 그 만큼 올리기 위함
                    {
                        
                        Spacer(minLength: 30)
                    }
            
                    
                    
                    
                }
                
                
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
                    LinearGradient(colors: [.clear,.black.opacity(0.9)], startPoint: .top, endPoint: .bottom)
                   
                    
                }
            }
            
        
        
        
    }
    
}


struct SongListItemView: View {
    
    
    var song:NewSong
    @EnvironmentObject var playState:PlayState
    @State var showAlert = false
    var body: some View {
        
        
        HStack{
            
            KFImage(URL(string: song.image))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width:45,height: 45)
                .clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
            
            VStack(alignment:.leading,spacing: 8)
            {
                Text(song.title).foregroundColor(.white).font(.caption2).bold().lineLimit(1)
                Text(song.artist).foregroundColor(.white).font(.caption2).lineLimit(1)
            }.frame(maxWidth: .infinity ,alignment: .leading)
            
            
            
            
            // -Play and List Button
            
            Text(convertTimeStamp2(song.date)).foregroundColor(.white).font(.caption2).lineLimit(1)
            
            
            
            
            
            
            
            Menu { //메뉴
                
                
                Button() {
                    showAlert = playState.appendList(item: SimpleSong(song_id: song.song_id, title: song.title, artist: song.artist, image: song.image, url: song.url))
                } label: {
                    Label {
                        Text("담기")
                    } icon: {
                        Image(systemName: "text.badge.plus").foregroundColor(.white).font(.title2)
                    }
                    
                    
                }
                
                Button {
                    let simpleSong = SimpleSong(song_id:song.song_id, title: song.title, artist: song.artist, image: song.image, url: song.url)
                    playState.currentSong = simpleSong//강제 배정
                    playState.youTubePlayer.load(source: .url(song.url)) //강제 재생
                    playState.uniqueAppend(item: simpleSong) //현재 누른 곡 담기
                } label: {
                    Label {
                        Text("재생")
                    } icon: {
                        Image(systemName: "play.fill")
                    }
                    
                }
                
                
                
            } label: {
                Image(systemName: "ellipsis").foregroundColor(.white)
            }.foregroundColor(Color("PrimaryColor"))
            
            
            Spacer()
            
        }.alert("이미 재생목록에 포함되어있습니다.", isPresented: $showAlert) {
            Text("확인")
        }
        
        
    }
    
}

struct ArtistPinnedHeader: View {
    
    @EnvironmentObject var playState:PlayState
    @Binding var chart:[NewSong]
    
    var body: some View{
        VStack(spacing:10){
            
            
            
            HStack{
                ImageButton(text: "셔플 재생", imageSource: "angelGosegu").onTapGesture {
                    playState.playList.removeAll() //전부 지운후
                    playState.youTubePlayer.stop() // stop
                    playState.playList = castingFromNewSongToSimple(newSongList: chart) // 현재 해당 chart로 덮어쓰고
                    
                    shuffle(playlist: &playState.playList)  //셔플 시킨 후
                    
                    playState.currentPlayIndex = 0 // 인덱스 0으로 맞춤
                    playState.youTubePlayer.load(source: .url(chart[0].url)) //첫번째 곡 재생
                    playState.youTubePlayer.play()
                    
                }
                ImageButton(text: "전체 듣기", imageSource: "jingboy").onTapGesture {
                    playState.playList.removeAll() //전부 지운후
                    playState.youTubePlayer.stop() // stop
                    playState.playList = castingFromNewSongToSimple(newSongList: chart)  // 현재 해당 chart로 덮어쓰고
                    playState.currentPlayIndex = 0 // 인덱스 0으로 맞춤
                    playState.youTubePlayer.load(source: .url(chart[0].url)) //첫번째 곡 재생
                    playState.youTubePlayer.play()
                    
                    
                }
            }
        }.frame(width:UIScreen.main.bounds.width,height: UIDevice.current.hasNotch ? 130 : 100).background(.black).padding(.bottom)
       
    }
}

extension ArtistScreenView{
    
    final class ArtistScreenViewModel:ObservableObject{
        
        @Published var selectedid:String = "woowakgood"
        @Published var artists:[Artist] = [Artist] ()
        @Published var currentShowChart:[NewSong] = [NewSong]()
        var cancelBag = Set<AnyCancellable>()
        
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
               
                
            }.store(in: &cancelBag)
         
        }
        
        func fetchSongList(_ name:String)
        {
            Repository.shared.fetchSearchSongsList(name).sink { completion in
                
            } receiveValue: { [weak self] (data:[NewSong]) in
                guard let self = self else {return}
                
               
                
                self.currentShowChart = data
            }.store(in: &cancelBag)

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


struct ArtistScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistScreenView()
    }
}
