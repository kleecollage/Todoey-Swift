//
//  Item.swift
//  Todoey
//
//  Created by Antonio Hernández Santander on 15/01/26.
//  Copyright © 2026 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory: LinkingObjects<Category> {
        LinkingObjects(fromType: Category.self, property: "items")
    }
}
