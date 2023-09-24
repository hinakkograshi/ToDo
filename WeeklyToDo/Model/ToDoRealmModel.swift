//
//  ToDoRealmModel.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/09/23.
//

import Foundation
import RealmSwift

class ToDoRealmModel {
    let realm = try! Realm()
    var toDoItems: Results<Item>!
}
//Create
extension ToDoRealmModel {
    func createRealm(toDoText: String) {
        let newItem = Item()
        newItem.title = toDoText
        if let lastItem = self.toDoItems?.last {
            newItem.order = lastItem.order + 1
        }
        try! self.realm.write {
            self.realm.add(newItem)
        }
    }
}

//Read
extension ToDoRealmModel {

    func sortRead(){
        //並べ替えデータ取得
        toDoItems = realm.objects(Item.self).sorted(byKeyPath: "order")
    }
}

//Update
extension ToDoRealmModel {
    func updateRealm(index: Int, value: String) {
        try! realm.write {
            //データを変更する。
            toDoItems[index].title = value
        }
    }
}
extension ToDoRealmModel {
    func checkUpdateRealm(index: Int) {
        if let item = toDoItems?[index] {
            do {
                //Updateitemの更新されたプロパティを以前は何であったかを問わず、トグルして書き込む
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status.")
            }
        }
    }
}

extension ToDoRealmModel {
    func sortCellUpdate(sourceIndex: Int, destinationIndex: Int) {
        try! realm.write {
            let sourceObject = toDoItems[sourceIndex]
            print("最初の行",sourceObject.order)
            let destinationObject = toDoItems[destinationIndex]

            let destinationObjectOrder = destinationObject.order

            if sourceIndex < destinationIndex {

                for index in sourceIndex...destinationIndex {
                    let object = toDoItems[index]
                    object.order -= 1

                }
            } else {
                for index in (destinationIndex..<sourceIndex).reversed() {
                    let object = toDoItems[index]
                    object.order += 1
                }
            }
            sourceObject.order = destinationObjectOrder
            print("最後の行",sourceObject.order)
        }
    }
    
}


//🟥Delete
extension ToDoRealmModel {
    func deleteRealm(index: Int) {

        if let itemForDeletion = self.toDoItems?[index] {
            do {
                //セルを削除してRealmデータベースに存在しないようにする
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting category,\(error)")
            }
        }
    }
}
