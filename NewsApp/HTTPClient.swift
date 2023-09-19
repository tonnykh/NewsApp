//
//  HTTPClient.swift
//  NewsApp
//
//  Created by Khumbongmayum Tonny on 07/09/23.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case serverError(String)
    case decodingError
    case invalidResponse
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
            
        case .badRequest:
            return "It is a bad request"
            
        case .serverError(let message):
            return message
            
        case .decodingError:
            return "Unable to decode"
            
        case .invalidResponse:
            return "Invalid Response from server"
        }
    }
}

enum HttpMethod {
    case get([URLQueryItem])
    case post(Data?)
    
    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}

struct Resource<T: Codable> {
    let url: URL
    var method: HttpMethod = .get([])
    let modelType: T.Type
}

// MARK: - HTTPClient
class HTTPClient {
    static let shared = HTTPClient()
    
    func load<T: Codable>(_ resource: Resource<T>) async throws -> T {
        
        var request = URLRequest(url: resource.url)
        
        switch resource.method {
            
        case .get(let queryItems):
            
            if !queryItems.isEmpty {
                var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)
                
                components?.queryItems = queryItems
                
                guard let url = components?.url else {
                    throw NetworkError.badRequest
                }
                request = URLRequest(url: url)
            }
            
        case .post(let data):
            request.httpMethod = resource.method.name
            request.httpBody = data
        }
        
        // create the URLSession configuration
        let configuration = URLSessionConfiguration.default
        // add default headers
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        let session = URLSession(configuration: configuration)
        
        let (data, _) = try await session.data(for: request)
        print(data)
        guard let result = try? JSONDecoder().decode(resource.modelType, from: data) else {
            print("decode error")
            
            throw NetworkError.decodingError
        }
        
        return result
    }
    
}


// MARK: - Extension
extension Articles {
    static func resourceForAllArticles(apiKey: String, source: String) -> Resource<Articles> {
        let queryItems = [
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "sources", value: source)
        ]
        
        return Resource(url: URL.forAllArticles, method: .get(queryItems), modelType: Articles.self)
    }
}

extension URL {
    static var forAllArticles: URL {
        URL(string: "https://newsapi.org/v2/top-headlines")!
    }
}
