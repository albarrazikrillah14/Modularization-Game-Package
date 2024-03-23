//
//  File.swift
//
//
//  Created by BEI-Zikri on 20/03/24.
//

import Core
import Combine
import Alamofire
import Foundation

public struct GetGamesRemoteDataSouce: DataSource {
    
    public typealias Request = Any
    public typealias Response = GameModule
    public typealias ResponseDetail = GameModuleDetailResponse

    public init() {}
    
    public func getGames() -> AnyPublisher<[GameModule], Error> {
        return Future<[GameModule], Error> { completion in
            if let url = URL(string: Endpoints.Gets.games.url) {
                let parameters: Parameters = ["key": API.apiKeys]
                AF.request(url, parameters: parameters)
                    .validate()
                    .responseDecodable(of: GameModuleResponse.self) { response in
                        switch response.result {
                        case .success(let value):
                            completion(.success(value.results ?? []))
                        case .failure:
                            completion(.failure(URLError.invalidResponse))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    public func getGameDetail(id: String) -> AnyPublisher<GameModuleDetailResponse, Error> {
        return Future<GameModuleDetailResponse, Error> { completion in
            
            if let url = URL(string: Endpoints.Gets.detail(id).url) {
                let parameters: Parameters = ["key": API.apiKeys]
                
                AF.request(url, parameters: parameters)
                    .validate()
                    .responseDecodable(of: GameModuleDetailResponse.self) { response in
                        switch response.result {
                        case .success(let value):
                            completion(.success(value))
                        case .failure:
                            completion(.failure(URLError.invalidResponse))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    public func getGameSearch(query: String) -> AnyPublisher<[GameModule], Error> {
        return Future<[GameModule], Error> { completion in
            if let url = URL(string: Endpoints.Gets.search.url) {
                let parameters: Parameters = [
                    "key": API.apiKeys,
                    "search": query
                ]
                
                AF.request(url, parameters: parameters)
                    .validate()
                    .responseDecodable(of: GameModuleResponse.self) { response in
                        switch response.result {
                        case .success(let value):
                            completion(.success(value.results ?? []))
                        case .failure:
                            completion(.failure(URLError.invalidResponse))
                            
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
}


struct API {
    static let baseUrl = "https://api.rawg.io/api/"
    static let apiKeys = "d9d10c519d0e41cd95fecac72a3b9574"
}

protocol Endpoint {
    var url: String { get }
}

enum Endpoints {
    
    enum Gets: Endpoint {
        case games
        case search
        case detail(String)
        
        public var url: String {
            switch self {
            case .games: return "\(API.baseUrl)games"
            case .search: return "\(API.baseUrl)games"
            case .detail(let id): return "\(API.baseUrl)games/\(id)"
            }
        }
    }
}

