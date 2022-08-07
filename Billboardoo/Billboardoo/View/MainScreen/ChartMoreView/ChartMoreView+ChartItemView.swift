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
    var body: some View {
        VStack{
            GeometryReader { proxy in
                VStack(alignment:.center) {
                    Text("BILLBOARDOO CHART")
                    Text("HOT 100")
                }.position(x: proxy.size.width/2, y:0)
                    .padding(.vertical)
                    .coordinateSpace(name: "ChartTitle")
                
                
                
                CustomTopTabBar(tabIndex: $index, geometry:proxy)
                
                    .position(x: proxy.size.width/2, y: proxy.frame(in: .named("ChartTitle")).origin.y+30)
                    .coordinateSpace(name: "TopBar")
                
                
                
                ImageButton(text: "셔플 재생", imageSource: "jingboy")
                    .position(x: proxy.size.width/4, y: proxy.frame(in: .named("TopBar")).origin.y+100)
                
                ImageButton(text: "100곡 전체듣기", imageSource: "jingboy")
                    .position(x: proxy.size.width/1.35, y: proxy.frame(in: .named("TopBar")).origin.y+100) 
                
                ScrollView {
                    
                }
                .position(x: proxy.size.width/2, y: proxy.frame(in: .named("TopBar")).origin.y+400)
                
                
                
                
                
            }
        }
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




struct CustomTopTabBar: View {
    @Binding var tabIndex: Int
    var geometry:GeometryProxy
    var body: some View {
        HStack {
            TabBarButton(text: "누적", tabindex: $tabIndex,index: 0)
                .frame(width:geometry.size.width/6,alignment: .center)
                .onTapGesture { onButtonTapped(index: 0) }
            TabBarButton(text: "시간",  tabindex: $tabIndex,index: 1)
                .frame(width:geometry.size.width/6,alignment: .center)
                .onTapGesture { onButtonTapped(index: 1) }
            TabBarButton(text: "일간",  tabindex: $tabIndex,index: 2)
                .frame(width:geometry.size.width/6,alignment: .center)
                .onTapGesture { onButtonTapped(index: 2) }
            TabBarButton(text: "주간", tabindex: $tabIndex,index: 3)
                .frame(width:geometry.size.width/6,alignment: .center)
                .onTapGesture { onButtonTapped(index: 3) }
            TabBarButton(text: "월간", tabindex: $tabIndex,index: 4)
                .frame(width:geometry.size.width/6,alignment: .center)
                .onTapGesture { onButtonTapped(index: 4) }
            Spacer()
        }
        .padding(.horizontal)
        .border(width: 0.5, edges: [.bottom], color: .gray)
    }
    
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
        print(index)
    }
}


struct TabBarButton: View {
    let text: String
    @Binding var tabindex:Int
    var index:Int
    var body: some View {
        Text(text)
            .fontWeight( tabindex == index ? .heavy : .regular)
            .padding(.bottom,10)
            .foregroundColor(tabindex == index  ? Color("PrimaryColor") : Color("UnSelectedTextColor"))
            .border(width: tabindex == index ? 2.5 : 0.5, edges: [.bottom], color:  tabindex == index ? Color("PrimaryColor") : .gray)
    }
}

struct ImageButton: View {
    
    var text:String
    var imageSource:String
    var body: some View{
        
        
        ZStack(alignment:.center) {
            
            Text(text).font(.system(size: 20, weight: .black, design: .rounded)).foregroundColor(.white).zIndex(2.0)
            Image(imageSource)
                .resizable()
                .frame(width: 150, height: 45, alignment: .center)
                .aspectRatio(contentMode: .fit)
                .clipShape(Capsule())
                .padding()
            LinearGradient(colors: [.clear,.black.opacity(0.7)], startPoint: .leading, endPoint: .trailing).clipShape(Capsule())
                .frame(width: 150, height: 45)
            
            
        }.onTapGesture {
            print("100곡 전체 들어")
        }
        
    }
}

struct ChartItemView_Previews: PreviewProvider {
    static var previews: some View {
        ImageButton(text:"100곡 전체 듣기",imageSource: "jingboy")
    }
}

struct ChartMoreView_Previews: PreviewProvider {
    static var previews: some View {
        ChartMoreView(index: .constant(1))
    }
}

