//
//  Reward.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/08/28.
//

import Foundation
import RealmSwift

class Reward: Object {
    @Persisted var title: String = ""
    @Persisted var done: Bool = false
}
