//
//  SearchView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/16.
//

import SwiftUI
import Combine

struct SearchView: View {
    
    
    @StateObject private var vm = SearchViewModel(initalValue: "",delay: 0.3)
    @EnvironmentObject var playState:PlayState
    
    var body: some View {
        
        ZStack {
            VStack{
                
                SearchBarView(currentValue: $vm.currentValue).padding()
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

struct SearchVView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group{
            SearchView().previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            SearchView().previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}


