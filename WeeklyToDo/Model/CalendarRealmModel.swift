//
//  RealmCRUDModel.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/09/10.
//

import Foundation
import RealmSwift

class CalendarRealmModel {
    private let realm = try! Realm()
    let diaryModel = DiaryModel()
    var readRealmArray:[Contents] = []
}
//Create
extension CalendarRealmModel {
    func createRealm(realmTitle: String, realmContent: String, realmDate: String, realmDateCreated: String) {
        
        diaryModel.title = realmTitle
        diaryModel.content = realmContent
        diaryModel.date = realmDate
        diaryModel.dateCreated = realmDateCreated
        try! realm.write {
            realm.add(diaryModel)
        }
    }
}

//Read
extension CalendarRealmModel {
    func calendarDayRead(calendarDay:String) -> Results<DiaryModel> {
        let result = realm.objects(DiaryModel.self).filter(NSPredicate(format: "date == %@", calendarDay))
        return result
    }
}
extension CalendarRealmModel {
    func eventRead(calendarEvent:String) -> Results<DiaryModel> {
        let event = realm.objects(DiaryModel.self).where{$0.date == calendarEvent}
        return event
    }
}

extension CalendarRealmModel {
    func filterReadRealm(calendarDay:String) {
        readRealmArray = []
        for filterReadResult in realm.objects(DiaryModel.self).filter(NSPredicate(format: "date == %@", calendarDay)){
            let contents = Contents(
                title: filterReadResult.title,
                content: filterReadResult.content,
                date: filterReadResult.date,
                dateCreated: filterReadResult.dateCreated
            )
            readRealmArray.append(contents)
        }
    }
}

//Update
extension CalendarRealmModel {
    func updateRealm(updateTitle: String, updateContent: String, updateDate: String, updateDateCreated: String) {
        try! realm.write {
            diaryModel.title = updateTitle
            diaryModel.content = updateContent
            diaryModel.date = updateDate
            diaryModel.dateCreated = updateDateCreated
            realm.add(diaryModel, update: .modified)
        }
    }
}

//Delete
extension CalendarRealmModel {
    func deleteRealm(calendarDay:String, index: Int) {
        let reault = calendarDayRead(calendarDay: calendarDay)
        //セルを削除してRealmデータベースに存在しないようにする
        try! self.realm.write {
            self.realm.delete(reault[index])
            filterReadRealm(calendarDay:calendarDay)
        }
    }
}

struct Contents {
    let title: String
    let content:String
    let date: String
    let dateCreated: String
}
