//
//  File.swift
//
//
//  Created by BEI-Zikri on 20/03/24.
//

import Foundation

public struct GameModuleResponse: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [GameModule]?
}

public struct GameModule: Codable {
    let id: Int
    let name: String
    let releaseDate: String?
    let rating: Double?
    let gameImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case releaseDate = "released"
        case rating
        case gameImage = "background_image"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let dateString = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        releaseDate = DateFormatterHelper().dateFormatter(date: dateString)
        rating = try container.decodeIfPresent(Double.self, forKey: .rating) ?? 0.0
        gameImage = try container.decodeIfPresent(String.self, forKey: .gameImage) ?? ""
    }
    
    public init(id: Int, name: String, releaseDate: String, rating: Double, gameImage: String, desc: String) {
        self.id = id
        self.name = name
        self.releaseDate = releaseDate
        self.rating = rating
        self.gameImage = gameImage
    }
}


class DateFormatterHelper {
    
    func dateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MMM, d YYYY"
        return dateFormatter1.string(from: date ?? Date())
    }
}
