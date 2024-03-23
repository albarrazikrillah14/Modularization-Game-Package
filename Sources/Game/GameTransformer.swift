//
//  File.swift
//
//
//  Created by BEI-Zikri on 20/03/24.
//

import Core

public struct GameTransformer: Mapper {

    public typealias Response = [GameModule]
    public typealias Entity = [GameModuleEntity]
    public typealias Domain = [GameDomainModel]
    public typealias ResponseDetail = GameModuleDetailResponse
    public typealias DetailDomain = GameDomainDetailModel
    
    
    public init() {}
    
    public func transformResponseToEntity(response: [GameModule]) -> [GameModuleEntity] {
        return response.map { result in
            let newCategory = GameModuleEntity()
            newCategory.id = result.id
            newCategory.name = result.name
            newCategory.image = result.gameImage ?? "Unknow"
            newCategory.isFavorite = false
            newCategory.rating = result.rating ?? 0.0
            newCategory.releaseDate = result.releaseDate ?? ""
            return newCategory
        }
    }
    
    public func transformEntityToDomain(entity: [GameModuleEntity]) -> [GameDomainModel] {
        return entity.map { result in
            return GameDomainModel(
                id: result.id,
                name: result.name,
                releaseDate: result.releaseDate,
                rating: result.rating,
                gameImage: result.image
            )
            
        }
    }
    
    
    public func transformDetailResponseToDomain(response: GameModuleDetailResponse) -> GameDomainDetailModel {
        return GameDomainDetailModel(
            id: response.id,
            name: response.name,
            description: response.description,
            backgroundImage: response.backgroundImage,
            rating: response.rating,
            released: response.released,
            isFavorite: false
        )
    }
}
