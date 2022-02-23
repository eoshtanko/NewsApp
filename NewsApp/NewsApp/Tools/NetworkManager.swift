//
//  NetworkingManager.swift
//  NewsApp
//
//  Created by Екатерина on 05.02.2022.
//

import Foundation

class NetworkManager {
    
    static let instance = NetworkManager()
    
    private let baseURL = "https://newsapi.org/v2/"
    private let urlSession = URLSession.shared
    
    enum Result<T> {
        case success(T?)
        case failure(Error)
    }
    
    enum EndPointError: Error {
        case couldNotParse
        case noData
    }
    
    func getArticles(passedInPageNumber: String="1", _ completion: @escaping (Result<[Article]>) -> Void)  {
        let articleRequest = makeRequest(passedInPageNumber)
        let task = urlSession.dataTask(with: articleRequest) {(data, response, error) in
            if let error = error {
                return completion(Result.failure(error))
            }
            do {
                _ = try JSONSerialization.jsonObject(with: data!, options: [])
            } catch {
                print(error.localizedDescription)
            }
            guard let safeData = data else {
                return completion(Result.failure(EndPointError.noData))
            }
            guard let result = try? JSONDecoder().decode(ArticlesList.self, from: safeData) else {
                return completion(Result.failure(EndPointError.couldNotParse))
            }
            let articles = result.articles
            DispatchQueue.main.async {
                completion(Result.success(articles))
            }
        }
        task.resume()
    }
    
    private func makeRequest(_ pageNum: String) -> URLRequest {
        let endPoint = EndPoint()
        let path = endPoint.path
        let stringParams = endPoint.paramsToString(pageNum)
        let fullURL = URL(string: baseURL.appending("\(path)?\(stringParams)"))
        var request = URLRequest(url: fullURL!)
        request.httpMethod = endPoint.HTTPRequestMethod
        request.allHTTPHeaderFields = endPoint.getHeaders(secretKey: Secret.apiKey.rawValue)
        return request
    }
    
    private struct EndPoint {
        
        let path = "top-headlines"
        let HTTPRequestMethod = "GET"
        
        func getHeaders(secretKey: String) -> [String: String] {
            return ["Accept": "application/json",
                    "Content-Type": "application/json",
                    "Authorization": "X-Api-Key \(secretKey)",
                    "Host": "newsapi.org"
            ]
        }
        
        // pageSize указала для наглядности.
        // Можно было этого не делать, тк pageSize == 20 - default
        // Подумала, что technology - хорошая category для вступительного в ФИНТЕХ :D
        private func getParams(_ pageNum: String) -> [String: String] {
            return ["country": "ru",
                    "page": pageNum,
                    "category":"technology",
                    "pageSize": "20"]
        }
        
        func paramsToString(_ pageNum: String) -> String {
            let parameterArray = getParams(pageNum).map{ key, value in
                return "\(key)=\(value)"
            }
            return parameterArray.joined(separator: "&")
        }
    }
    
    private enum Secret: String {
        case apiKey = "5cfce8b4643d454094b4dadeed4a8008"
    }
}
