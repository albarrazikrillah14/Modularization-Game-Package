//
//  File.swift
//
//
//  Created by BEI-Zikri on 20/03/24.
//

import Combine
import Core
import RealmSwift

public struct GetGamesLocateDataSource: LocaleDataSource {
    public typealias Request = Any
    public typealias Response = GameModuleEntity
    
    private let _realm: Realm
    
    public init(_realm: Realm) {
        self._realm = _realm
    }
    
    public func getGames() -> AnyPublisher<[GameModuleEntity], Error> {
        return Future<[GameModuleEntity], Error> { completion in
            let games: Results<GameModuleEntity> = {
                self._realm.objects(GameModuleEntity.self)
                    .sorted(byKeyPath: "name", ascending: true)
            }()
            completion(.success(games.toArray(ofType: GameModuleEntity.self)))
        }.eraseToAnyPublisher()
    }
    
    public func saveGames(from games: [GameModuleEntity]) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            do {
                try self._realm.write {
                    for game in games {
                        self._realm.add(game, update: .all)
                    }
                    completion(.success(true))
                }
            } catch {
                completion(.failure(DatabaseError.requestFailed))
            }
        }.eraseToAnyPublisher()
    }
    
    public func addToFavorite(from id: Int) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let game = self._realm.object(ofType: GameModuleEntity.self, forPrimaryKey: id) {
                do {
                    try self._realm.write {
                        game.isFavorite = true
                        self._realm.add(game, update: .modified)
                        completion(.success(true))
                    }
                } catch {
                    completion(.failure(DatabaseError.requestFailed))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    
    public func deleteFromFavorite(from id: Int) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let game = self._realm.object(ofType: GameModuleEntity.self, forPrimaryKey: id) {
                do {
                    try self._realm.write {
                        game.isFavorite = false
                        self._realm.add(game, update: .modified)
                        completion(.success(true))
                    }
                } catch {
                    completion(.failure(DatabaseError.requestFailed))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    
    public func getAllFavorites() -> AnyPublisher<[GameModuleEntity], Error> {
        return Future<[GameModuleEntity], Error> { completion in
            let favorites = self._realm.objects(GameModuleEntity.self)
                .filter("isFavorite == true")
                .sorted(byKeyPath: "name", ascending: true)
            completion(.success(favorites.toArray(ofType: GameModuleEntity.self)))
        }.eraseToAnyPublisher()
    }
    
    public func isFavorite(id: Int) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let game = self._realm.object(ofType: GameModuleEntity.self, forPrimaryKey: id) {
                let isFavorite = game.isFavorite
                completion(.success(isFavorite))
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
}
