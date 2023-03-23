//
//  NetworkManager.swift
//  URLSessionAndCombine
//
//  Created by july on 2023/3/23.
//

import Foundation
import Combine



enum PunkAPI {
    static let pageSize = 25 //每页多少条
    
    static func searchBeers(page: Int) -> AnyPublisher<[Beer], Error> {
        let url = URL(string:"https://api.punkapi.com/v2/beers?page=\(page)&per_page=\(Self.pageSize)")!
        return URLSession.shared
            .dataTaskPublisher(for: url) // 1. Create a publisher that wraps a URL session data task
            .tryMap { try JSONDecoder().decode(BeerSearchResult<Beer>.self, from: $0.data).items }// 2.Decode the response as BeerSearchResult. This is an intermediate type created for the purpose of parsing JSON.
            .receive(on: DispatchQueue.main) // 3.Receive response on the main thread.
            .eraseToAnyPublisher()
    }
}

struct BeerSearchResult<T: Codable>: Codable {
    let items: [T]
}

struct Beer: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let description: String
    let firstBrewed: String
    let imageURL: String
    let tagline: String
    
    enum CodingKeys: String,CodingKey {
        case id
        case name
        case description
        case firstBrewed = "first_brewed"
        case imageURL = "image_url"
        case tagline
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.firstBrewed = try container.decode(String.self, forKey: .firstBrewed)
        self.imageURL = try container.decode(String.self, forKey: .imageURL)
        self.tagline = try container.decode(String.self, forKey: .tagline)
    }
}
