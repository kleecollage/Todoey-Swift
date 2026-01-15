//
//  Data.swift
//  Todoey
//
//  Created by Antonio Hernández Santander on 14/01/26.
//  Copyright © 2026 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}

