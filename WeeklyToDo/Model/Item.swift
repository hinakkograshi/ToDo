//
//  Item.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/08/27.
//

import Foundation
import RealmSwift

class Item: Object {
    @Persisted var title: String = ""
    @Persisted var done: Bool = false
}
