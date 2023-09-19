//
//  Articles.swift
//  NewsApp
//
//  Created by Khumbongmayum Tonny on 07/09/23.
//

import Foundation

struct Articles: Codable {
    let articles: [Article]
    
    init(from decoder: Decoder) throws {
        let RootContainerKeys = try decoder.container(keyedBy: RootContainerKeys.self)
        self.articles = try RootContainerKeys.decode([Article].self, forKey: .articles)
    }
    
    private enum RootContainerKeys: CodingKey {
        case articles
    }
    
}
