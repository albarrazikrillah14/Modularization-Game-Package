//
//  File.swift
//
//
//  Created by BEI-Zikri on 20/03/24.
//

import Foundation

public struct GameDomainModel: Equatable, Identifiable {
    
    public let id: Int
    public let name: String
    public let releaseDate: String?
    public let rating: Double?
    public let gameImage: String?
    
    public init(id: Int, name: String, releaseDate: String?, rating: Double?, gameImage: String?) {
        self.id = id
        self.name = name
        self.releaseDate = releaseDate
        self.rating = rating
        self.gameImage = gameImage
    }
}
