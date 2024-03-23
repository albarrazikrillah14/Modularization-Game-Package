//
//  File.swift
//  
//
//  Created by BEI-Zikri on 20/03/24.
//

import Foundation

public struct GameModuleDetailResponse: Codable {
    let id: Int
    let name: String
    let description: String
    let backgroundImage: String
    let rating: Double
    let released: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description = "description_raw"
        case backgroundImage = "background_image"
        case rating
        case released
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.released = try container.decodeIfPresent(String.self, forKey: .released) ?? ""
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.backgroundImage = try container.decodeIfPresent(String.self, forKey: .backgroundImage) ?? ""
        self.rating = try container.decodeIfPresent(Double.self, forKey: .rating) ?? 0.0
    }
}
