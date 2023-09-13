//
//  RealmCRUDModel.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/09/10.
//

import Foundation
import RealmSwift

class RealmCRUDModel {
    let realm = try! Realm()
    let diaryModel = DiaryModel()
    var readRealmArray:[Contents] = []
    var diaryModels: Results<DiaryModel>!
}
//Create
extension RealmCRUDModel {
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
//Update
extension RealmCRUDModel {
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

//Read

extension RealmCRUDModel {
    func calendarDayRead(calendarDay:String) -> Results<DiaryModel> {
        let result = realm.objects(DiaryModel.self).filter(NSPredicate(format: "date == %@", calendarDay))
        return result
    }
}
extension RealmCRUDModel {
    func eventRead(calendarEvent:String) -> Results<DiaryModel> {
        let event = realm.objects(DiaryModel.self).where({$0.date == calendarEvent})
        return event
    }
}
extension RealmCRUDModel {
    func sortedRead() -> Results<DiaryModel> {
        let sort = realm.objects(DiaryModel.self).sorted(byKeyPath: "dateCreated")
        return sort
    }
}

extension RealmCRUDModel {
    func filterReadRealm(calendarDay:String) {
        //2023/9/9
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

extension RealmCRUDModel {
    func deleteRealm(calendarDay:String, index: Int) {
        let reault = calendarDayRead(calendarDay: calendarDay)

            //セルを削除してRealmデータベースに存在しないようにする
            try! self.realm.write {
                self.realm.delete(reault[index])
                filterReadRealm(calendarDay:calendarDay)
            }
        }
    }

extension RealmCRUDModel {
    func getResult()-> [Contents] {
       return  []

    }

    func getCount() -> Int {
        return readRealmArray.count
    }
}

struct Contents {
    let title: String
    let content:String
    let date: String
    let dateCreated: String
}

