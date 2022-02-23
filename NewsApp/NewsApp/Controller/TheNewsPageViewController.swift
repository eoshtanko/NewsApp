//
//  NewsPageViewController.swift
//  NewsApp
//
//  Created by Екатерина on 05.02.2022.
//

import UIKit

// Отвечает за страницу конкретной новости
class TheNewsPageViewController: UIViewController {
    
    var article: Article?
    
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var newsLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsText: UITextView!
    
    override func viewDidLoad() {
        setCompany()
        setAuthor()
        setHeading()
        newsText.text = article?.descriptionText
        setImage()
    }
    
    private func setCompany() {
        if let company = article?.source.name, !company.isEmpty {
            companyLabel.text = company
        } else {
            companyLabel.text = "no company"
        }
    }
    
    private func setAuthor() {
        if let author = article?.author, !author.isEmpty {
            authorLabel.text = author
        } else {
            authorLabel.text = "no author"
        }
    }
    
    private func setHeading() {
        if let heading = article?.title, !heading.isEmpty {
            let filteredHeading = heading.components(separatedBy: " - ")[0]
            newsLabel.text = filteredHeading
        } else {
            newsLabel.text = "no heading"
        }
    }
    
    private func setImage() {
        if let urlStr = article?.urlToImage, let url = URL(string: urlStr) {
            PhotoManager.downloadImage(from: url, image: newsImage)
        }
    }
    
    @IBAction func goWebPressed(_ sender: Any) {
        let web = TheNewsWebPageViewController()
        web.url = article!.url
        self.navigationController?.pushViewController(web, animated: true)
    }
}
