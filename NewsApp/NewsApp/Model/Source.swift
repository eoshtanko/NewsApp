//
//  Source.swift
//  NewsApp
//
//  Created by Екатерина on 05.02.2022.
//

import Foundation

public class Source: NSObject, Decodable, NSCoding {
    
    let id: String?
    let name: String?
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey:"id")
        coder.encode(name, forKey: "name")
    }
    
    public required init?(coder: NSCoder) {
        id = coder.decodeObject(forKey: "id") as? String
        name = coder.decodeObject(forKey: "name") as? String
    }
}
