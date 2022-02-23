//
//  ArticlesViewController.swift
//  NewsApp
//
//  Created by Екатерина on 05.02.2022.
//

import UIKit

// Отвечает за список новостей
class ArticlesViewController: UIViewController {
    
    @IBOutlet weak var articleTableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private var alert = UIAlertController()
    
    private var currentAPICallPage = 1
    private var savedArticles: [Article]? = []
    
    private var articles : [Article] {
        get {
            return savedArticles!
        }
        set {
            MemoryManager.instance.saveNewsList(news: newValue)
            savedArticles = newValue
            articleTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let saved = MemoryManager.instance.getNewsList(), !saved.isEmpty {
            articles = saved
        } else {
            fetchArticles()
        }
        configureTableView()
        configureAlertWindow()
        configurePullToRefresh()
    }
    
    private func configureTableView() {
        view.addSubview(articleTableView)
        articleTableView.delegate = self
        articleTableView.dataSource = self
    }
    
    private func configureAlertWindow() {
        alert = UIAlertController(title: "Failed to load data", message: "Check your internet connection", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    }
    
    private func configurePullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Updating")
        refreshControl.addTarget(self, action: #selector(fetchArticles), for: .valueChanged)
        articleTableView.addSubview(refreshControl)
    }
    
    @objc private func fetchArticles() {
        NetworkManager.instance.getArticles { result in
            switch result {
            case let .success(returnedSources):
                // Восстанавливаю информацию о views
                self.restoreViews(newArticles: returnedSources, oldArticles: self.savedArticles)
                self.articles = returnedSources!
                self.currentAPICallPage = 1
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    // Вызываю alert и останавливаю pull-to-refresh
                    self.present(self.alert, animated: true, completion: {self.refreshControl.endRefreshing()})
                }
            }
        }
    }
    
    // После обновления информация о views теряется. Здесь я примитивным способом ее восстанавливаю.
    // Уверена! Это можно было сделать намного умнее.
    // Например, кажется, разумно было бы создать Dictionary
    // (и так же кэшировать его, используя UserDefaults)
    // Находить значение счетчика в нем по ключу.
    // 1. НАМНОГО быстрее
    // 2. Это бы решило проблему с тем, что данные счетчиков после обновления и пролистывания
    // вниз более чем на 20 страниц не сохраняются.
    // Но! Возникает проблема: когда и как очищать этот словарь?
    // Как в этом словаре понять, где новые данные, а где устаревшие?
    // Можно, конечно, ее решить, создав вспомогательную структуру данных.
    // (В ней можно, например, отслеживать время создания)
    // И, при достижении словарем определенного размера, пробегаться по нему,
    // очищая от более не нужной информации.
    // К сожалению, экзамен наложился на ФИНТЕХ испытания, и я совсем не спала сегодня.
    // Так что, вот вложенный цикл:(
    private func restoreViews(newArticles: [Article]?, oldArticles: [Article]?) {
        guard let countNewArticles = newArticles?.count,
              let countOldArticles = oldArticles?.count else {
            return
        }
        let maxIdxOldArticles = countOldArticles > Const.newsPerPage ? Const.newsPerPage : countOldArticles
        // Cравниваем первые 20 старых новостей с новыми новостями
        for idxOld in 0..<maxIdxOldArticles {
            for idxNew in 0..<countNewArticles {
                if oldArticles![idxOld].title == newArticles![idxNew].title {
                    newArticles![idxNew].views = oldArticles![idxOld].views
                }
            }
        }
    }
}

extension ArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    // Постраничная загрузка всех доступных новостей (по 20 новостей)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        let article = articles[indexPath.row]
        cell.setInfo(for: article)
        if indexPath.row == articles.count - 1 {
            currentAPICallPage += 1
            NetworkManager.instance.getArticles(passedInPageNumber: String(currentAPICallPage)) { result in
                switch result {
                case let .success(moreArticles):
                    self.articles.append(contentsOf: moreArticles!)
                    self.articleTableView.reloadData()
                case let .failure(gotError):
                    print(gotError)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Const.heightOfRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Работа с views.
        articles[indexPath.row].views += 1
        MemoryManager.instance.saveNewsList(news: self.articles)
        // Переход с передачей данных через segue
        performSegue(withIdentifier: "toThePage", sender: nil)
        
        articleTableView.reloadRows(at: [indexPath], with: .none)
        articleTableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Настройка передаваемых через Segue данных
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TheNewsPageViewController {
            let articleToPass = articles[articleTableView.indexPathForSelectedRow!.row]
            destination.article = articleToPass
        }
    }
    
    private enum Const {
        static let heightOfRow: CGFloat = 135
        static let newsPerPage = 20
    }
}

