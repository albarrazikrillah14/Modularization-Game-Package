//
//  File.swift
//
//
//  Created by BEI-Zikri on 20/03/24.
//

import Foundation

public struct GameDomainDetailModel: Equatable, Identifiable {
    public let id: Int
    public let name: String
    public let description: String
    public let backgroundImage: String
    public let rating: Double
    public let released: String
    public var isFavorite: Bool
    
    public init(id: Int, name: String, description: String, backgroundImage: String, rating: Double, released: String, isFavorite: Bool) {
        self.id = id
        self.name = name
        self.description = description
        self.backgroundImage = backgroundImage
        self.rating = rating
        self.released = released
        self.isFavorite = isFavorite
    }
}
