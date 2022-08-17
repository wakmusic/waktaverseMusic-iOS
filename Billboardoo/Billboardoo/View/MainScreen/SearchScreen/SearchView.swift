//
//  SearchView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/16.
//

import SwiftUI
import Combine

struct SearchView: View {
    
    
    @StateObject private var viewModel = SearchViewModel(initalValue: "",delay: 0.3)
    
    
    
    
    
    
    var body: some View {
        NavigationView{
            VStack
            {
                
                if(!viewModel.currentValue.isEmpty && viewModel.results.count == 0)
                {
                    Text("결과가 없습니다.")
                }
                else
                {
                    
                    List{
                        ForEach(viewModel.results, id:\.self.id){ song in
                            Text(song.title)
                        }
                    }
                    
                    
                    
                }
                
                
                
            } .navigationTitle("SearchView")
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(.stack)
        .searchable(text: $viewModel.currentValue,prompt:"검색어를 입력해주세요", suggestions: {
            ForEach(viewModel.results,id:\.self.id){ result in
                Text("\(result.title)").searchCompletion(result.title)
            }
        })
        .onChange(of: viewModel.debouncedValue, perform: { newValue in
            
            print(newValue)
            viewModel.fetchSong(newValue)
        })
        
        .accentColor(.blue)
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


