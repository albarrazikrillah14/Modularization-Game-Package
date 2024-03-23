//
//  File.swift
//
//
//  Created by BEI-Zikri on 20/03/24.
//

import Core
import Combine

public struct GetGamesRepository <
    GameLocaleDataSource: LocaleDataSource,
    RemoteDataSource: DataSource,
    Transformer: Mapper
>: Repository where
GameLocaleDataSource.Response == GameModuleEntity,
RemoteDataSource.Response == GameModule,
RemoteDataSource.ResponseDetail == GameModuleDetailResponse,
Transformer.Entity == [GameModuleEntity],
Transformer.Domain == [GameDomainModel],
Transformer.Response == [GameModule],
Transformer.ResponseDetail == GameModuleDetailResponse,
Transformer.DetailDomain == GameDomainDetailModel {
    
    public typealias Request = Any
    public typealias Response = [GameDomainModel]
    public typealias ResponseDetail = GameDomainDetailModel
    
    private let _localeDataSource: GameLocaleDataSource
    private let _remoteDataSource: RemoteDataSource
    private let _mapper: Transformer
    
    public init(
        localeDataSource: GameLocaleDataSource,
        remoteDataSource: RemoteDataSource,
        mapper: Transformer) {
            _localeDataSource = localeDataSource
            _remoteDataSource = remoteDataSource
            _mapper = mapper
        }
    
    public func execute(request: Request?) -> AnyPublisher<[GameDomainModel], Error> {
        return _localeDataSource.getGames()
            .flatMap { result -> AnyPublisher<[GameDomainModel], Error> in
                if result.isEmpty {
                    return _remoteDataSource.getGames()
                        .map { _mapper.transformResponseToEntity(response: $0 ) }
                        .catch { _ in _localeDataSource.getGames() }
                        .flatMap { _localeDataSource.saveGames(from: $0) }
                        .filter { $0 }
                        .flatMap { _ in _localeDataSource.getGames()
                                .map { _mapper.transformEntityToDomain(entity: $0) }
                        }
                        .eraseToAnyPublisher()
                } else {
                    return _localeDataSource.getGames()
                        .map { _mapper.transformEntityToDomain(entity: $0) }
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    
    public func getGameDetail(id: String) -> AnyPublisher<GameDomainDetailModel, Error> {
        return _remoteDataSource.getGameDetail(id: id)
            .map { _mapper.transformDetailResponseToDomain(response: $0) }
            .eraseToAnyPublisher()
    }
    
    public func searchGames(query: String) -> AnyPublisher<[GameDomainModel], Error> {
        return _remoteDataSource.getGameSearch(query: query)
            .flatMap { games -> AnyPublisher<[GameDomainModel], Error> in
                if games.isEmpty {
                    return Empty<[GameDomainModel], Error>().eraseToAnyPublisher()
                } else {
                    return self.saveGames(games: _mapper.transformResponseToEntity(response: games))
                        .map { _ in
                            _mapper.transformEntityToDomain(entity: _mapper.transformResponseToEntity(response: games))
                        }
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    public func addToFavorite(from id: Int) -> AnyPublisher<Bool, Error> {
        return _localeDataSource.addToFavorite(from: id)
            .eraseToAnyPublisher()
    }
    
    public func deleteFromFavorite(from id: Int) -> AnyPublisher<Bool, Error> {
        return _localeDataSource.deleteFromFavorite(from: id)
            .eraseToAnyPublisher()
    }
    
    public func getAllFavorite() -> AnyPublisher<[GameDomainModel], Error> {
        return _localeDataSource.getAllFavorites()
            .map { _mapper.transformEntityToDomain(entity: $0) }
            .eraseToAnyPublisher()
    }
    
    public func isFavorite(from id: Int) -> AnyPublisher<Bool, Error> {
        return _localeDataSource.isFavorite(id: id)
            .eraseToAnyPublisher()
    }
    
    public func saveGames(games: [GameModuleEntity]) -> AnyPublisher<Bool, Error> {
        return _localeDataSource.saveGames(from: games)
            .eraseToAnyPublisher()
    }
}

