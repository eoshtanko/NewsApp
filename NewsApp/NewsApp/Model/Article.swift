//
//  Article.swift
//  NewsApp
//
//  Created by Екатерина on 05.02.2022.
//

import Foundation

public class Article: NSObject, Decodable, NSCoding {
    
    let source: Source
    let author: String?
    let title: String?
    let descriptionText: String?
    let url: String?
    let urlToImage: String?
    let content: String?
    var views = 0
    
    public func encode(with coder: NSCoder) {
        coder.encode(source, forKey:"source")
        coder.encode(author, forKey: "author")
        coder.encode(title, forKey:"title")
        coder.encode(descriptionText, forKey: "description")
        coder.encode(url, forKey:"url")
        coder.encode(urlToImage, forKey: "urlToImage")
        coder.encode(content, forKey:"content")
        coder.encode(views, forKey:"views")
    }
    
    public required init?(coder: NSCoder) {
        source = coder.decodeObject(forKey: "source") as! Source
        author = coder.decodeObject(forKey: "author") as? String
        title = coder.decodeObject(forKey: "title") as? String
        descriptionText = coder.decodeObject(forKey: "description") as? String
        url = coder.decodeObject(forKey: "url") as? String
        urlToImage = coder.decodeObject(forKey: "urlToImage") as? String
        content = coder.decodeObject(forKey: "content") as? String
        views = coder.decodeInteger(forKey: "views")
    }
    
    enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case descriptionText = "description"
        case url
        case urlToImage
        case content
    }
}
