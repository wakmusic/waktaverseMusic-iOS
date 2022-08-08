//
//  ChartMoreView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/06.
//

import SwiftUI


struct ChartMoreView: View {
    @Binding var index:Int
    @EnvironmentObject var playState:PlayState
    @GestureState private var dragOffset = CGSize.zero // 스와이프하여 뒤로가기를 위해
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> // 스와이프하여 뒤로가기를 위해
    
    // MARK: For Smooth Sliding Effect


    var body: some View {
        
        
        
        VStack
        {
            ScrollView(.vertical,showsIndicators: false)
            {
               
                    HeaderView()
                
                
                LazyVStack(alignment:.center,pinnedViews:[.sectionHeaders])
                {
                    Section {
                        Text("Hello")
                    } header: {
                        PinnedHeaderView(selectedIndex: $index)
                    }

                }
                
            }
            .coordinateSpace(name: "SCROLL")
        }.navigationBarBackButtonHidden(true)
            .ignoresSafeArea(.container,edges:.vertical)
            .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
                
                if(value.translation.width > 100) // 왼 오 드래그가 만족할 때
                {
                    self.presentationMode.wrappedValue.dismiss() //뒤로가기
                }
                
                
            }))
        
    }
}

// - MARK: HeaderView
struct HeaderView: View{
    
    var body: some View{
        
        GeometryReader{ proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY //SCROLL 프레임의 최소Y(가장 위쪽 Y좌표)
            let size = proxy.size
            let hegith = (size.height+minY)
            Image("mainChartLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:size.width,height: hegith,alignment: .center)
                .opacity(0.3)
                .overlay(content: {
                    ZStack(alignment:.center)
                    {
                        VStack{
                            //텍스트 크기를 proxy를 기준으로 변경
                            Text("BILLBOARDOO CHART").font(.system(size: proxy.size.height/8, weight: .light, design: .default))
                            Text("HOT 100").font(.system(size: proxy.size.height/6, weight: .bold, design: .monospaced))
                        }
                        
                    }
                })
                .offset(y:-minY)
                
        }
        .frame(height:UIScreen.main.bounds.height/6) //frame 전체의 /6
    }
}

// - MARK: PinnedHeaderView
struct PinnedHeaderView:View{
    
    @Binding var selectedIndex:Int
    @Namespace var animation
    
    var body: some View{
        
        let types: [String] = ["누적","시간","일간","주간","월간"]
        ScrollView(.horizontal,showsIndicators: false)
        {
            HStack(spacing:20)
            {
                ForEach(types.indices, id: \.self){ idx in
                    
                    VStack(spacing:12){
                        
                        Text(types[idx])
                            .fontWeight(.semibold)
                            .foregroundColor(selectedIndex == idx ? Color("PrimaryColor") : .gray)
                        
                        ZStack{
                            if (selectedIndex == idx) {
                                RoundedRectangle(cornerRadius: 4 , style:  .continuous) .fill( Color("PrimaryColor"))
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            }
                            else{
                                RoundedRectangle(cornerRadius: 4 , style:  .continuous) .fill(.clear)
                            }
                        }
                        
                        .frame(height:4 )
                    }
                    .frame(width:UIScreen.main.bounds.width/6) // 중간에 넣기위해 width를 6등ㅂ으로
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeOut){
                            selectedIndex = idx
                        }
                    }
                }
            }
        }.padding(.horizontal)
    }
}



struct ChartItemView: View {
    
    
    var body: some View {
        
        
        Text("전체 듣기")
        
    }
    
}

extension ChartItemView{
    
    final class ChartItemViewModel{
        
    }
}




struct ChartMoreView_Previews: PreviewProvider {
    static var previews: some View {
        ChartMoreView(index: .constant(1))
    }
}

