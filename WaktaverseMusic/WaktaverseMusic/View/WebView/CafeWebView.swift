//
//  CafeWebView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/12.
//

import Foundation
import WebKit
import Combine
import SwiftUI

struct CafeWebView: UIViewRepresentable {

    var urlToLoad: String

    func makeUIView(context: Context) -> some UIView {
        // unwrapping
        guard let url = URL(string: self.urlToLoad) else {
            return WKWebView()
        }
        // 웹뷰 인스턴스 생성
        let webView = WKWebView()

        // 웹뷰를 로드한다
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }

}
