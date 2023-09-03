//
//  RealmCRUDModel.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/09/03.
//
//
//import Foundation
//import RealmSwift
//
//class RealmCRUDModel{
//
//    var readRealmArray:[[String:String]] = []
//
//}
//
//extension RealmCRUDModel{
//
//    func createRealm(createTitle:String,createContent:String,createDate:String){
//
//        do{
//            let realm = try Realm()
//            let diaryModel = DiaryModel()
//
//            diaryModel.title = createTitle
//            diaryModel.content = createContent
//            diaryModel.date = createDate
//
//            try realm.write({
//
//                realm.add(diaryModel)
//
//            })
//        }catch{
//
//            print(error.localizedDescription)
//
//        }
//    }
//}
//
//extension RealmCRUDModel{
//
//    func readRealm(){
//
//        do{
//            let realm = try Realm()
//            self.readRealmArray = []
//
//            for readResult in realm.objects(DiaryModel.self){
//
//                self.readRealmArray.append(["RealmTitle":readResult.title,"RealmContent":readResult.content])
//
//            }
//
//        }catch{
//
//            print(error.localizedDescription)
//
//        }
//    }
//}
//
//extension RealmCRUDModel{
//
//    func filterReadRealm(calendarDay:String){
//
//        do{
//            let realm = try Realm()
//            self.readRealmArray = []
//
//            for filterReadResult in realm.objects(DiaryModel.self).filter(NSPredicate(format: "day == %@", calendarDay)){
//
//                self.readRealmArray.append(["RealmTitle":filterReadResult.title,"RealmContent":filterReadResult.content])
//            }
//        }catch{
//
//            print(error.localizedDescription)
//
//        }
//    }
//}
