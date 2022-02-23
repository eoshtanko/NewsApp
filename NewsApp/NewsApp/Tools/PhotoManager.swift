//
//  photoManager.swift
//  NewsApp
//
//  Created by Екатерина on 06.02.2022.
//

import UIKit

class PhotoManager {
    
    // Метод для загрузки изображения
    static func downloadImage(from url: URL, image: UIImageView?) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                image?.image = UIImage(data: data)
            }
        }
    }
    
    private static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
