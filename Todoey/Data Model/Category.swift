//
//  Category.swift
//  Todoey
//
//  Created by Antonio Hernández Santander on 15/01/26.
//  Copyright © 2026 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class Category: Object {
    @objc dynamic var colorHex: String = UIColor.randomFlat().hexValue()
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
