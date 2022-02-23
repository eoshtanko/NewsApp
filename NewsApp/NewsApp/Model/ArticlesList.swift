//
//  ListOfArticles.swift
//  NewsApp
//
//  Created by Екатерина on 05.02.2022.
//

import Foundation

public class ArticlesList: NSObject, Decodable, NSCoding{
    
    var articles: [Article] = []
    
    public func encode(with coder: NSCoder) {
        coder.encode(articles, forKey:"articles")
    }
    
    public required init?(coder: NSCoder) {
        articles = coder.decodeObject(forKey: "articles") as! [Article]
    }
}
