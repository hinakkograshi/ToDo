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
    @Persisted var date = ""
}
