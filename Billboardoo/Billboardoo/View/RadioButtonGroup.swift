//
//  RadioButtonGroup.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/21.
//

import SwiftUI

struct RadioBttuon: View {
    
    let id:Int
    let title:String
    let callback: (Int)->()
    let selectedId:Int
    @State var textColor = Color("UnSelectedTextColor")
    init(
        title:String,
        _ id: Int,
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
            print(self.id)
        } label: {
            HStack{
                Text(title).tracking(4)
            }.foregroundColor(self.selectedId != self.id ? Color("UnSelectedTextColor"):.white)
            .background(self.selectedId != self.id ? Color("UnSelectedRbtnColor")  : Color("PrimaryColor"))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("PrimaryColor"),lineWidth: 2))
            
        }
        
        
    }
}



//

//
















struct RadioButtonGroup: View {
    
    let items :[String] = ["누적","최신","일간","주간","월간"]
    
    @State var selectedId:Int = 0
    
    let callback: (Int) -> ()
    
    func radioGroupCallback(id: Int) {
        selectedId = id
        callback(id)
    }
    
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            ForEach(Array(items.enumerated()), id: \.offset) { idx, item in
                RadioBttuon(title: item, idx, callback: { id in
                    print(id)
                }, selectedID: idx)
            }
        }
    }
}

struct RadioButtonGroup_Previews: PreviewProvider {
    static var previews: some View {
        RadioButtonGroup { Int in
            print("Hello")
        }
    }
}
