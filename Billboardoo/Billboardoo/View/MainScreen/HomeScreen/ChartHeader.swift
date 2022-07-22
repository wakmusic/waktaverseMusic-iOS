//
//  ChartHeader.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/22.
//

import SwiftUI

struct ChartHeader: View {
    var title:String = "빌보두 차트 100"
    
    
    
    var body: some View {
        VStack(alignment:.leading,spacing: 5){
            HStack {
                Text(title).bold().foregroundColor(Color("PrimaryColor"))
                Spacer()
                Text("더보기").foregroundColor(.gray)
            }
        }.padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
    }
}

struct ChartHeader_Previews: PreviewProvider {
    static var previews: some View {
        ChartHeader()
    }
}
