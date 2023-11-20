//
//  WebView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/19.
//

import SwiftUI
import WebKit

struct WebView : UIViewRepresentable {
  var url : String
  
  func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
    let view = WKWebView()
    view.load(URLRequest(url: URL(string: url)!))
    return view
  }
  
  func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
  }
}
