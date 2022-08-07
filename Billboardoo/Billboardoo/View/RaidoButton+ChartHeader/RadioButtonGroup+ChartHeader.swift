//
//  RadioButtonGroup.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/21.
//

import SwiftUI

//- MARK: RadioButton
struct RadioBttuon: View {
    let window = UIScreen.main.bounds.size
    let id:Int
    let title:String
    let callback: (Int)->()
    let selectedId:Int
    init(
        title:String,
        id: Int,
        callback: @escaping (Int)->(),
        selectedID: Int
    ) {
        self.title = title
        self.id = id
        self.selectedId = selectedID
        self.callback = callback
    }
    
    var body: some View {
        
        Button {
            
            self.callback(id)
            
            
        } label: {
            
            Text(title).fontWeight(.bold).tracking(4) //자간 간격 4 만큼
             
            
            //글자 색
                .foregroundColor(self.selectedId != self.id ? Color("UnSelectedTextColor"):.white)
               // .padding()
            //배경색
                .background(self.selectedId != self.id ? Color("UnSelectedRbtnColor")  : Color("PrimaryColor"))
                .cornerRadius(10)
            //테두리 설정
                .overlay(RoundedRectangle(cornerRadius: 13).stroke(Color("PrimaryColor"),lineWidth: 1))
        }
        //최종 크기
        
        
        
    }
}


//- MARK: Group
struct RadioButtonGroup: View {
    let window = UIScreen.main.bounds.size
    let items :[String] = ["누적","시간","일간","주간","월간"]
    
    @State var selectedId:Int = 0 //현재 선택된 상태를 저장할 변수
    
    let callback: ((Int,Int)) -> ()
    
    func radioGroupCallback(id: Int) {
        callback((selectedId,id)) //콜백 (이전 선택,현재 선택) 을 튜블 형태로
        selectedId = id //선택된 아이디 변경
    }
    
    
    var body: some View {
        ChartHeader(chartIndex: $selectedId)
        Spacer()
        VStack(alignment: .leading) {
            HStack(spacing: 10) { //버튼간 간격
                
                ForEach(Array(items.enumerated()), id: \.offset) { idx, item in
                    RadioBttuon(title: item, id:idx, callback: self.radioGroupCallback, selectedID: self.selectedId) //버튼 설정
                }
            }.frame(width: window.width, alignment: .center)
        }
        
    }
    
}


struct ChartHeader: View {
    
    @Binding var chartIndex:Int
    @EnvironmentObject var playState:PlayState
    
    
    var body: some View {
        
        
        VStack(alignment:.leading,spacing: 5){
            HStack {
                switch chartIndex{
                case 0:
                    Text("빌보두 누적 Top 100").bold().foregroundColor(Color("PrimaryColor"))
                case 1:
                    Text("빌보두 실시간 Top 100").bold().foregroundColor(Color("PrimaryColor"))
                case 2:
                    Text("빌보두 일간 Top 100").bold().foregroundColor(Color("PrimaryColor"))
                case 3:
                    Text("빌보두 주간 Top 100").bold().foregroundColor(Color("PrimaryColor"))
                case 4:
                    Text("빌보두 월간 Top 100").bold().foregroundColor(Color("PrimaryColor"))
                default:
                    Text("빌보두 누적 Top 100").bold().foregroundColor(Color("PrimaryColor"))
                }
                Spacer()
                
                NavigationLink {
                    ChartMoreView(index: $chartIndex).environmentObject(playState)
                } label: {
                    Text("더보기").foregroundColor(.gray)
                }

                
            }
        }.padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
    }
}




struct RadioButtonGroup_Previews: PreviewProvider {
    
    @ObservedObject var viewModel:HomeScreenView.HomeScreenViewModel
    static var previews: some View {
        RadioButtonGroup { (selected, now) in
            print("\(selected) \(now)")
        }
    }
}
