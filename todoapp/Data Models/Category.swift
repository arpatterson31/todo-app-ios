//
//  Category.swift
//  todoapp
//
//  Created by Audrey Patterson on 3/9/23.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    
    let items = List<Item>()
}
