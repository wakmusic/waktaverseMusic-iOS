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
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.searchBaraccentColor)
                
                TextField("검색어를 입력해주세요",text: $vm.currentValue)
            }
            .font(.headline)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    //.fill(Color(")
                    .shadow(color: .black, radius: 10, x: 0, y: 0)
            )
            .padding()
        }
        
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


