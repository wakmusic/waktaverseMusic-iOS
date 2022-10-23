//
//  NewsView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/12.
//

import SwiftUI
import Foundation
import Combine
import Kingfisher

struct NewsView: View {

    private let rows = [GridItem(.fixed(220))] // row 높이
    @EnvironmentObject var playState: PlayState
    @ObservedObject var viewModel: HomeViewModel
     //https://billboardoo.com/news/thumbnail/2022022.png

    var body: some View {
        VStack(spacing: 3) {
            NewsHeader(news: $viewModel.news).environmentObject(playState)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows, spacing: 30) { // 뉴스간 거리
                   OneGridRow
                }.padding(.horizontal)
            }
        }

    }
}

extension NewsView {

    var OneGridRow: some View {

        ForEach(viewModel.news.prefix(3), id: \.self.id) { news in

            NavigationLink {
                WebView(urlToLoad: "\(Const.URL.cafe)\(news.newsId)")
            } label: {
                VStack(alignment: .leading, spacing: 20) {
                    KFImage(URL(string: "\(Const.URL.base)\(Const.URL.static)\(Const.URL.news)/\(news.time).png")!)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(width: 280, height: 180, alignment: .center)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.8), radius: 10, x: 0, y: 0)
                    Text(news.title.replacingOccurrences(of: "이세돌포커스 -", with: "")).font(.system(size: 15, weight: .semibold, design: .default)).lineLimit(1)
                }.frame(width: 280)

            }

        }

    }
}
