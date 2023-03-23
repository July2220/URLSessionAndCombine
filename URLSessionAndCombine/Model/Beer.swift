//
//  NetworkManager.swift
//  URLSessionAndCombine
//
//  Created by july on 2023/3/23.
//

import Foundation
import Combine

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
