//
//  SavedNews.swift
//  NewsApp
//
//  Created by Екатерина on 05.02.2022.
//

import Foundation

class MemoryManager {
    
    static let instance = MemoryManager()

    private let defaults = UserDefaults.standard
    private let newsKey = "newsList"
    
    // Более новый способ:
    //        guard let decodedNews = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ArticlesList.self,         from: news!) else {
    //            return nil
    //        }
    // Но менее удобный для задуманой мною архитектуры. Надеюсь, это не критично
    // Нет проблем в том, чтобы переделать под новую версию, но код получится менее складным
    func getNewsList()->[Article]? {
        let news = defaults.data(forKey: newsKey)
        guard news != nil else { return nil }
        let decodedNews = NSKeyedUnarchiver.unarchiveObject(with: news!) as! [Article]
        return decodedNews
    }
    
    // Более новый способ:
    //        guard let encodedNews = try? NSKeyedArchiver.archivedData(withRootObject: news,           requiringSecureCoding: false) else {
    //            return
    //        }
    // Но менее удобный для задуманой мною архитектуры. Надеюсь, это не критично
    // Нет проблем в том, чтобы переделать под новую версию, но код получится менее складным
    func saveNewsList(news: [Article]){
        defaults.removeObject(forKey: newsKey)
        let encodedNews: Data = NSKeyedArchiver.archivedData(withRootObject: news)
        defaults.set(encodedNews, forKey: newsKey)
        defaults.synchronize()
    }
}
