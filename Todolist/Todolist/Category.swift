//
//  Category.swift
//  Todolist
//
//  Created by Vamsi Krishna on 22/03/21.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
}
