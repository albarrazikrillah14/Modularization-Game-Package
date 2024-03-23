//
//  File.swift
//
//
//  Created by BEI-Zikri on 20/03/24.
//

import Foundation
import RealmSwift

public class GameModuleEntity: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var releaseDate: String = ""
    @objc dynamic var rating: Double = 0.0
    @objc dynamic var image: String = ""
    @objc dynamic var isFavorite: Bool = false
    
    public override static func primaryKey() -> String? {
        return "id"
    }
}

