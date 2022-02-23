//
//  ArticleCell.swift
//  NewsApp
//
//  Created by Екатерина on 05.02.2022.
//

import UIKit

class ArticleCell: UITableViewCell {
    
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var headlineImage: UIImageView!
    @IBOutlet weak var newsСontent: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    func setInfo(for article: Article) {
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        headlineImage.translatesAutoresizingMaskIntoConstraints = false
        newsСontent.translatesAutoresizingMaskIntoConstraints = false
        sourceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if let urlStr = article.urlToImage, let url = URL(string: urlStr) {
            PhotoManager.downloadImage(from: url, image: headlineImage)
        }
        
        if let safeTitle = article.title {
            let str = safeTitle.components(separatedBy: " - ")[0]
            headlineLabel.text = str
        }
        
        if let safeSource = article.source.name {
            sourceLabel.text = safeSource
        }
        
        newsСontent.text = String(article.views)
    }
}
