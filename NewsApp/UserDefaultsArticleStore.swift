//
//  UserDefaultsArticleStore.swift
//  NewsApp
//
//  Created by Khumbongmayum Tonny on 09/09/23.
//

import Foundation

class UserDefaultsArticleStore {
    
    static let shared = UserDefaultsArticleStore()
    private let userDefaults = UserDefaults.standard
    private let key = "ArrayKey"
    
    func saveArticles(_ articles: [Article]) {
        // Encoding and saving to UserDefaults
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let encodedData = try? encoder.encode(articles) {
            userDefaults.set(encodedData, forKey: key)
        }
        
    }
    
    func loadArticles() -> [Article]? {
        // Retrieving and decoding from UserDefaults
        if let savedData = userDefaults.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                let loadedArray = try decoder.decode([Article].self, from: savedData)
                print(" ")
                print("Decoded data:")
                print(" ")
                print(loadedArray)
                return loadedArray // Return the loaded data
            } catch {
                print("= =  = ")
                print(" ")
                print("Error decoding data: \(error)")
            }
        }
        
        return nil
    }
}
