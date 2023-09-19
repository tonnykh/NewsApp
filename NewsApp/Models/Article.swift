//
//  Article.swift
//  NewsApp
//
//  Created by Khumbongmayum Tonny on 07/09/23.
//

import Foundation

struct Article: Codable {
    let title: String?
    let url: String?
    let urlToImage: String?
    let articleDescription: String?
    let publishedAt: String?
    let name: String?
    var toShow: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case url
        case urlToImage
        case source
        case articleDescription = "description"
        case publishedAt
        case name
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(url, forKey: .url)
        try container.encode(urlToImage, forKey: .urlToImage)
        try container.encode(articleDescription, forKey: .articleDescription)
        try container.encode(publishedAt, forKey: .publishedAt)
        
        var sourceContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .source)
        try sourceContainer.encode(name, forKey: .name)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String?.self, forKey: .title)
        self.url = try container.decode(String?.self, forKey: .url)
        self.urlToImage = try container.decode(String?.self, forKey: .urlToImage)
        self.articleDescription = try container.decode(String?.self, forKey: .articleDescription)
        self.publishedAt = try container.decode(String?.self, forKey: .publishedAt)

        let sourceContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .source)
        self.name = try sourceContainer.decode(String?.self, forKey: .name)
        self.toShow = true
    }
    
    func convertTimeStampToDate(date: String? = nil)-> String {
        return self.publishedAt?.toDate()?.timeAgoSinceDate() ?? ""
    }

}


extension Article {
    var titleDisplay: String {
        guard let title = title else { return "" }

        let components = title.components(separatedBy: "|")
        guard let first = components.first else { return title }

        return first
    }
}
