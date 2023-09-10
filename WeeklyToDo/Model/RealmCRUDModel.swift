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
    var readRealmArray:[Contents] = []

}
//Create
extension RealmCRUDModel {
    func createRealm(realmTitle: String, realmContent: String, realmDate: String, realmDateCreated: String) {
        let diaryModel = DiaryModel()
        diaryModel.title = realmTitle
        diaryModel.content = realmContent
        diaryModel.date = realmDate
        diaryModel.dateCreated = realmDateCreated
        
        try! realm.write {
            realm.add(diaryModel)
        }
    }
}

extension RealmCRUDModel {
    func filterReadRealm(calendarDay:String) {
        //2023/9/9
        var readRealmArray:[Contents] = []

        for filterReadResult in realm.objects(DiaryModel.self).filter(NSPredicate(format: "date == %@", calendarDay)){
            let contents = Contents(
                title: filterReadResult.title ,
                content: filterReadResult.content,
                date: filterReadResult.date)
            readRealmArray.append(contents)
        }
    }
}
struct Contents {
    let title: String
    let content:String
    let date: String
}
extension RealmCRUDModel {
    func deleteReadRealm(calendarDay:String) {
        let reault = realm.objects(DiaryModel.self).filter(NSPredicate(format: "date == %@", calendarDay))


       try! realm.write {
//🟥indexPath.rowここに持たせれない。
//           self.realm.delete(reault[indexPath.row])
            filterReadRealm(calendarDay:calendarDay)
        }
    }
}
extension RealmCRUDModel {
//    func getResult()-> [Conents]{
//        return [];
//    }

    func getCount() -> Int {
        return readRealmArray.count
    }
}

