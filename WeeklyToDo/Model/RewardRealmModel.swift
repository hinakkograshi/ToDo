//
//  RewardRealmModel.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/09/24.
//

import Foundation
import RealmSwift

class RewardRealmModel {
    let realm = try! Realm()
    var rewardList: Results<Reward>!
}
//Create
extension RewardRealmModel {
    func createRealm(rewardText: String) {
        let newItem = Reward()
        newItem.title = rewardText
        if let lastItem = self.rewardList?.last {
            newItem.order = lastItem.order + 1
        }
        try! self.realm.write {
            self.realm.add(newItem)
        }
    }
}

//Read
extension RewardRealmModel {

    func sortRead(){
        //並べ替えデータ取得
        rewardList = realm.objects(Reward.self).sorted(byKeyPath: "order")
    }
}

//Update
extension RewardRealmModel {
    func updateRealm(index: Int, value: String) {
        try! realm.write {
            //データを変更する。
            rewardList[index].title = value
        }
    }
}
extension RewardRealmModel {
    func checkUpdateRealm(index: Int) {
        if let Reward = rewardList?[index] {
            do {
                //Updateitemの更新されたプロパティを以前は何であったかを問わず、トグルして書き込む
                try realm.write {
                    Reward.done = !Reward.done
                }
            } catch {
                print("Error saving done status.")
            }
        }
    }
}

extension RewardRealmModel {
    func sortCellUpdate(sourceIndex: Int, destinationIndex: Int) {
        try! realm.write {
            let sourceObject = rewardList[sourceIndex]
            print("最初の行",sourceObject.order)
            let destinationObject = rewardList[destinationIndex]

            let destinationObjectOrder = destinationObject.order

            if sourceIndex < destinationIndex {

                for index in sourceIndex...destinationIndex {
                    let object = rewardList[index]
                    object.order -= 1

                }
            } else {
                for index in (destinationIndex..<sourceIndex).reversed() {
                    let object = rewardList[index]
                    object.order += 1
                }
            }
            sourceObject.order = destinationObjectOrder
            print("最後の行",sourceObject.order)
        }
    }

}

//🟥Delete
extension RewardRealmModel {
    func deleteRealm(index: Int) {

        if let itemForDeletion = self.rewardList?[index] {
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
//🟥checkDelete
extension RewardRealmModel {
    func checkboxDelete () {
        do {
            let check = realm.objects(Reward.self).where({$0.done == true})
            //セルを削除してRealmデータベースに存在しないようにする
            try self.realm.write {
            self.realm.delete(check)
            }
        } catch {
            print("Error deleting category,\(error)")
        }
    }
}
