//
//  DiaryModel.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/09/02.
//

import Foundation
import RealmSwift

class DiaryModel: Object {
    @Persisted var title: String = ""
    @Persisted var content: String = ""
    @Persisted var date: String = ""
    @Persisted var dateCreated = Date().description
    override static func primaryKey() -> String? {
            return "dateCreated"
        }
}
