//
//  TheNewsPageViewController.swift
//  NewsApp
//
//  Created by Екатерина on 05.02.2022.
//

import UIKit
import WebKit

// Отвечает за web страницу новости
class TheNewsWebPageViewController: UIViewController {
    
    var url: String? = nil
    private var pageWeb: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageWeb = WKWebView()
        setUp()
        getWebPage(from: url!)
        view.backgroundColor = .black
    }
    
    private func setUp(){
        self.view.addSubview(pageWeb!)
        pageWeb!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageWeb!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageWeb!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageWeb!.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            pageWeb!.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    private func getWebPage(from url: String) {
        var UrlComponents = URLComponents(string: url)!
        UrlComponents.scheme = "https"
        let toURL = URL(string: UrlComponents.string!)
        let request = URLRequest(url: toURL!)
        pageWeb!.load(request)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            pageWeb!.stopLoading()
            pageWeb = nil
        }
    }
}
