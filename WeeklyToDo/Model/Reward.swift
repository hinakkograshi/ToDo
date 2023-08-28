//
//  Reward.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/08/28.
//

import Foundation
import RealmSwift

class Reward: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
}
