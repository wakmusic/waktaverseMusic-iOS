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
            
            //배경색
                .background(self.selectedId != self.id ? Color("UnSelectedRbtnColor")  : Color("PrimaryColor"))
                .cornerRadius(10)
            //테두리 설정
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("PrimaryColor"),lineWidth: 1))
        }.frame(width: window.width*0.15, height: window.height*0.02, alignment: .center)
            //최종 크기
        
        
        
    }
}


//- MARK: Group
struct RadioButtonGroup: View {
    let window = UIScreen.main.bounds.size
    let items :[String] = ["누적","최신","일간","주간","월간"]
    
    @State var selectedId:Int = 0
    
    let callback: ((Int,Int)) -> ()
    
    func radioGroupCallback(id: Int) {
        callback((selectedId,id)) //콜백 (이전 선택,현재 선택) 을 튜블 형태로 
        selectedId = id //선택된 아이디 변경
        
    }
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack(spacing: 1) { //버튼간 간격
                
                ForEach(Array(items.enumerated()), id: \.offset) { idx, item in
                    RadioBttuon(title: item, id:idx, callback: self.radioGroupCallback, selectedID: self.selectedId) //버튼 설정
                }
            }.frame(width: window.width, height: 30, alignment: .center)
        }
        
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
