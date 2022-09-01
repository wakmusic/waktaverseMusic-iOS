//
//  SearchView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/16.
//

import SwiftUI
import Combine
import Kingfisher

struct SearchView: View {
    
    
    @StateObject private var vm = SearchViewModel(initalValue: "",delay: 0.3)
    @EnvironmentObject var playState:PlayState
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    @Binding var musicCart:[SimpleSong]
    
    var body: some View {
        
       
            VStack{
                
                SearchBarView(currentValue: $vm.currentValue).padding(10)
                ScrollViewReader { (proxy:ScrollViewProxy) in
                    ScrollView(.vertical,showsIndicators: false) {
                        
                        LazyVStack(alignment:.center){
                            Section {
                                ForEach(vm.results,id:\.self.id){ (song:NewSong) in
                                    SongListItemView(song: song,accentColor: .primary).environmentObject(playState)
                                    
                                }
                                
                            }
                        }.onChange(of: vm.debouncedValue) { newValue in
                            vm.fetchSong(newValue)
                        }
                        
                        
                    }.onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                    .padding(5)
               
                }
                
               
                
                
                
                
                
            }
        
        
        
    }
    
}

struct SearchBarView: View {
    
    
    @Binding var currentValue:String
    
    var body: some View {
        
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundColor( currentValue.isEmpty ? .searchBaraccentColor : .primary)
            
            TextField("검색어를 입력해주세요",text: $currentValue)
                .foregroundColor(Color.primary)
                .disableAutocorrection(true) // 자동완성 끄기
            
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.primary)
                .opacity(currentValue.isEmpty ? 0.0 : 1.0)
            
                .onTapGesture {
                    UIApplication.shared.endEditing()
                    currentValue = ""
                }.frame(alignment: .trailing)
            
        }
        .font(.headline)
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.searchBarBackground)
                .shadow(color: Color.primary.opacity(0.5), radius: 10, x: 0, y: 0)
        )
        
        
        
        
    }
    
}


extension SearchView{
    
    final private class SearchViewModel: ObservableObject{
        @Published var currentValue: String
        @Published var debouncedValue: String
        @Published var results:[NewSong] = [NewSong]()
        var subscription = Set<AnyCancellable>()
        
        init(initalValue:String, delay: Double = 0.5)
        {
            _currentValue = Published(initialValue: initalValue)
            _debouncedValue = Published(initialValue: initalValue)
            
            $currentValue
                .removeDuplicates()
                .debounce(for: .seconds(delay), scheduler: RunLoop.main)
                .assign(to: &$debouncedValue)
        }
        
        func fetchSong(_ keyword:String)
        {
            Repository.shared.fetchSearchWithKeyword(keyword)
                .sink { (_) in
                    
                } receiveValue: { [weak self] (data:[NewSong]) in
                    self?.results = data
                }.store(in: &subscription)
            
        }
    }
}

struct SongListItemView: View {
    
    
    var song:NewSong
    @EnvironmentObject var playState:PlayState
    var accentColor:Color
    var body: some View {
        
        
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
            
            VStack(alignment:.leading,spacing: 8)
            {
                Text(song.title).foregroundColor(accentColor).font(.caption2).bold().lineLimit(1)
                Text(song.artist).foregroundColor(accentColor).font(.caption2).lineLimit(1)
            }.frame(maxWidth: .infinity ,alignment: .leading)
            
            
            
            
            
            // -Play and List Button
            
            Text(convertTimeStamp2(song.date)).foregroundColor(accentColor).font(.caption2).lineLimit(1)
            
            
            
            
            
            
            
           
            
            Spacer()
            
        }.contentShape(Rectangle()).padding(.horizontal,5).onTapGesture {
            let simpleSong = SimpleSong(song_id: song.song_id, title: song.title, artist: song.artist, image: song.image, url: song.url)
            if(playState.currentSong != simpleSong)
            {
                playState.currentSong =  simpleSong //강제 배정
                playState.youTubePlayer.load(source: .url(simpleSong.url)) //강제 재생
                playState.uniqueAppend(item: simpleSong) //현재 누른 곡 담기
            }
        }
        
        
    }
    
}

extension SearchView{
    final class KeyboardHeightHelper: ObservableObject {
        @Published var keyboardHeight: CGFloat = 0
        
        init()
        {
            self.listenForKeyboardNotifications()
        }
        
        
        private func listenForKeyboardNotifications() {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification,
                                                   object: nil,
                                                   queue: .main) { (notification) in
                guard let userInfo = notification.userInfo,
                      let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                
                self.keyboardHeight = keyboardRect.height
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification,
                                                   object: nil,
                                                   queue: .main) { (notification) in
                self.keyboardHeight = 0
            }
        }
    }
    
    
}




