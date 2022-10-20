//
//  SwiftUIView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/11.
//

import SwiftUI
import Foundation
import Combine
import Kingfisher

struct NewsMoreView: View {

    @EnvironmentObject var playState: PlayState
    @StateObject var viewModel = NewsMoreViewModel()
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: Int(UIScreen.main.bounds.width)/180)
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> // 스와이프하여 뒤로가기를 위해

    // GridItem 크기 130을 기기의 가로크기로 나눈 몫 개수로 다이나믹하게 보여줌

    // private var columns:[GridItem] = [GridItem]()

    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {

                VStack(alignment: .center) {

                    LazyVGrid(columns: columns) {
                        ThreeColumnsGrid
                    }
                }

            }
        }

        .navigationTitle("NEWS")
        .navigationBarTitleDisplayMode(.large)
        .background()
        .highPriorityGesture(DragGesture().onEnded({ value in
            if value.translation.width > 100 { // 왼 오 드래그가 만족할 때
                clearCache()
                self.presentationMode.wrappedValue.dismiss() // 뒤로가기
            }
        })) // 부모 제스쳐가 먼져 ( swipe 하여 나가는게 NavigationLink의 클릭 이벤트 보다 우선)

    }
}

extension NewsMoreView {
    var ThreeColumnsGrid: some View {

        ForEach(viewModel.news.indices, id: \.self) { index in
            let item = viewModel.news[index]

            NavigationLink {
                CafeWebView(urlToLoad: "\(Const.URL.cafe)\(item.newsId)")
            } label: {
                VStack(alignment: .leading, spacing: 5) {
                    KFImage(URL(string: "\(Const.URL.base)\(Const.URL.static)\(Const.URL.news)/\(item.time).png")!)
                        .downsampling(size: CGSize(width: 400, height: 200)) // 약 절반 사이즈
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(width: 180, height: 120, alignment: .center)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.8), radius: 10, x: 0, y: 0)
                        .onAppear {
                            // 마지막 뉴스가 보여질 때 다음 30개를 불러옴
                            print(index, viewModel.news.count)
                            if index == viewModel.news.count - 1 {
                                viewModel.fetchNews()
                            }
                        }
                    Text(item.title.replacingOccurrences(of: "이세돌포커스 -", with: "")).font(.system(size: 15, weight: .semibold, design: .default)).lineLimit(1)

                }
            }.frame(width: 180)

        }

    }
}
