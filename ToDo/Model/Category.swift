//
//  Category.swift
//  toDo
//
//  Created by Tatsuya Amida on 2020/08/04.
//  Copyright © 2020 T.A. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
