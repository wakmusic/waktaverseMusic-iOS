//
//  ArtistScreenView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/12.
//

import SwiftUI
import Combine

struct ArtistScreenView: View {
    
    let columns:[GridItem] = [GridItem(.fixed(20),spacing: 20)]
    let window = UIScreen.main.bounds
    
    @StateObject var viewModel = ArtistScreenViewModel()
    
    
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
                                    
                                    LazyHGrid(rows: columns,alignment: .bottom,spacing: 0) {
                                        ForEach(viewModel.artists,id:\.self.id){ artist in
                                            
                                            CardView(artist: artist,selectedId: $viewModel.selectedid)
                                            
                                        }
                                    }
                                    
                                    
                                }.frame(height:window.height/6).zIndex(2)
                            }
                           
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
    var body: some View{
        
        
        Image("ine2")
            .resizable()
            .scaledToFill()
            //.clipped()
            //.frame(height:window.height/3)
            .overlay {
                ZStack() {
                    LinearGradient(colors: [.clear,.black.opacity(0.9)], startPoint: .top, endPoint: .bottom)
                   
                    
                }
            }
        
        
        
    }
    
}


extension ArtistScreenView{
    
    final class ArtistScreenViewModel:ObservableObject{
        
        @Published var selectedid:String = "ine"
        @Published var artists:[Artist]
        var cancelBag = Set<AnyCancellable>()
        
        init()
        {
            artists = [Artist(artistId: "ine", name: "아이네", artistGroup: .isedol, card: "",big: "i"),Artist(artistId: "jingburger", name: "징버거", artistGroup: .isedol, card: "",big: "j"),Artist(artistId: "lilpa", name: "릴파", artistGroup: .isedol, card: "",big: "l"),Artist(artistId: "jururu", name: "주르르", artistGroup: .isedol, card:"",big: ""),Artist(artistId: "gosegu", name: "고세구", artistGroup: .isedol, card: "",big: ""),Artist(artistId: "viichan", name: "비챤", artistGroup: .isedol, card: "",big: ""),Artist(artistId: "dandan", name:"단답", artistGroup: .isedol, card: "",big: ""),Artist(artistId: "pre", name: "프리터", artistGroup: .isedol, card: "",big: ""),]
        }
        
        func fetchArtist(){
            Repository.shared.fetchArtists().sink { completion in
                
            } receiveValue: { [weak self] (data:[Artist]) in
                guard let self = self else {return}
                print("Artist count: \(data.count)")
                
                self.artists = data
            }.store(in: &cancelBag)
            
        }
        
    }
    
}


struct ArtistScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistScreenView()
    }
}
