//
//  RankView.swift
//  WaktaverseMusic
//
//  Created by YoungK on 2022/10/02.
//

import Foundation
import SwiftUI

struct RankView: View {
    var now_rank: Int
    var color: Color = .accentColor
    var change_rank: String = " "

    init(now: Int, last: Int) {
        self.now_rank = now
        if(now_rank > last) // 랭크가 낮아지면
        {
            color = Color("RankDownColor")
            change_rank = "▼ \(self.now_rank - last)"
        } else if now_rank == last {
            color = Color("RankNotChangeColor")
            change_rank = "-"
        } else {
            color = Color("RankUpColor")
            change_rank = "▲ \(last - self.now_rank)"
        }
    }

    var body: some View {

        VStack(alignment: .center) {

            Text("\(now_rank)").font(.system(size: 13, weight: .bold))

            Text(change_rank).font(.system(size: 10, weight: .bold)).foregroundColor(color)
        }.frame(width: 35)
    }
}
