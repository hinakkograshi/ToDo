//
//  Item.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/08/27.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
}
