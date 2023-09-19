////
////  WebVC.swift
////  NewsApp
////
////  Created by Khumbongmayum Tonny on 07/09/23.
////
//
//import WebKit
//import UIKit
//
//class WebVC: UIViewController, WKNavigationDelegate {
//    
//    var webView: WKWebView!
//    
//    var selectedArticleUrl: String?
//    
//    override func loadView() {
//        webView = WKWebView()
//        webView.navigationDelegate = self
//        view = webView
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let url = URL(string: selectedArticleUrl ?? "https://developer.apple.com/")!
//        webView.load(URLRequest(url: url))
//        webView.allowsBackForwardNavigationGestures = true
//    }
//}
