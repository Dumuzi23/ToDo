//
//  Item.swift
//  toDo
//
//  Created by Tatsuya Amida on 2020/08/04.
//  Copyright © 2020 T.A. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
