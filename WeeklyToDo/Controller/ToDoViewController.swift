//
//  ViewController.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/08/19.
//

import UIKit
import RealmSwift
import XLPagerTabStrip
import SwipeCellKit

class ToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate, ChangeDelegate {


    //ここがボタンのタイトルに利用されます
    var itemInfo: IndicatorInfo = "やること"

    @IBOutlet weak var tableView: UITableView!

    let realm = try! Realm()

    var toDoItems: Results<Item>!



    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        //並べ替えデータ取得
        toDoItems = realm.objects(Item.self).sorted(byKeyPath: "order")
        //        tableView.allowsSelectionDuringEditing = true
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60.0
        tableView.register(UINib(nibName: "ToDoListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        //常時編集状態にする(isEditing,allowsSelectionDuringEditing)
        //        //編集モードおん
        //               tableView.isEditing = true
        //               tableView.allowsSelectionDuringEditing = true
        //
        //               // trueで複数選択、falseで単一選択
        //               tableView.allowsMultipleSelection = true
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tapGR.cancelsTouchesInView = false
                self.view.addGestureRecognizer(tapGR)
        //🟥忘れるな
        tableView.reloadData()
    }
    @objc func dismissKeyboard() {
            self.view.endEditing(true)
        }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }

    //🟥customCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ToDoListTableViewCell
        //自作のセルのデリゲート先に自分を設定する
        cell.delegate = self

        //🟥 SwipeCellKit
        //        cell.delegate = self
        //           cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added yet."

        cell.checkImageView.image = UIImage(systemName: "square")
        if let item = toDoItems?[indexPath.row] {
            cell.toDoTextField?.text = item.title
            //三項演算子
            //カスタム・アクセサリー・ビューがaccessoryViewプロパティで設定されている場合、このプロパティの値は無視される。
            //accessoryTypeが設定されている場合は、.checkmark
            cell.checkImageView.image = item.done ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
//🟩
    //value: textField.text!
    func textFieldDidEndEditing(cell: ToDoListTableViewCell, value: String) {
        //変更されたセルのインデックスを取得する。
        let index = tableView.indexPathForRow(at: cell.convert(cell.bounds.origin, to:tableView))
        print(index!)


        try! realm.write {
            //データを変更する。
            toDoItems[index!.row].title = value
        }

        self.tableView.reloadData()
    }
    @objc func hideKeybord() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
            self.view.transform = .identity
        })
    }
    //他のところ触ったらキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


    //MARK - TableView Delegate Methods
    //cellがクリックで選択された

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        Updateする場所はdidSelectRowAt.Updateは新規作成と似てる
        if let item = toDoItems?[indexPath.row] {
            do {
                //Updateitemの更新されたプロパティを以前は何であったかを問わず、トグルして書き込む
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status.")
            }
        }
        tableView.reloadData()

        //選択されてグレーになり、すぐに白に戻す
        tableView.deselectRow(at: indexPath, animated: true)
    }


    //ユーザーが並び替えを行うと、UITableViewはUIを更新します
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("🟥")

        try! realm.write {
            print("🟦")
            let sourceObject = toDoItems[sourceIndexPath.row]
            print("最初の行",sourceObject.order)
            let destinationObject = toDoItems[destinationIndexPath.row]

            let destinationObjectOrder = destinationObject.order

            if sourceIndexPath.row < destinationIndexPath.row {
                print("🟨")

                for index in sourceIndexPath.row...destinationIndexPath.row {
                    let object = toDoItems[index]
                    object.order -= 1

                }
            } else {
                print("🟧")
                for index in (destinationIndexPath.row..<sourceIndexPath.row).reversed() {
                    let object = toDoItems[index]
                    object.order += 1
                }
            }
            sourceObject.order = destinationObjectOrder
            print("最後の行",sourceObject.order)
        }
        print("🟩")
    }


    //全てのセルを並び替えできるようにしたいので、常にtrue
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return []
    }
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {

    }

    ////    削除はできず並び替えだけしたい場合
    //    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    //            return .none
    //            }
    ////  左側に謎のスペース消す
    //    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
    //                return false
    //            }


    //MARK: - Delete Data From Swipe

    //    func updateModel(at indexPath: IndexPath) {
    //        if let itemForDeletion = self.toDoItems?[indexPath.row] {
    //            do {
    //                //セルを削除してRealmデータベースに存在しないようにする
    //                try self.realm.write {
    //                    self.realm.delete(itemForDeletion)
    //                }
    //            } catch {
    //                print("Error deleting category,\(error)")
    //            }
    //        }
    //    }

    @IBAction func addButonPressed(_ sender: UIButton) {
        var textField = UITextField()
        let alert = UIAlertController(title: "新しいカテゴリーを追加", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "追加", style: .default) { action in
            //ユーザーが追加ボタンを押したら何が起こるか
            //クラスから新しいオブジェクトが作成され、
            let newItem = Item()
            newItem.title = textField.text!
            //🟥
            // MARK: order をインクリメントする
            if let lastItem = self.toDoItems.last {
                newItem.order = lastItem.order + 1
            }
            try! self.realm.write {
                self.realm.add(newItem)
            }

            self.tableView.reloadData()
        }

        alert.addAction(action)
        alert.addTextField { field in
            textField = field
            textField.placeholder = "新しいカテゴリーを追加"
        }
        let cancelButton = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
    }
}
////    //MARK: - Swipe Cell Delegate Methods
//extension ToDoViewController: SwipeTableViewCellDelegate {
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            // handle action by updating model with deletion
//            if let itemForDeletion = self.toDoItems?[indexPath.row] {
//                do {
//                    //セルを削除してRealmデータベースに存在しないようにする
//                    try self.realm.write {
//                        self.realm.delete(itemForDeletion)
//                    }
//                } catch {
//                    print("Error deleting category,\(error)")
//                }
//            }
//        }
//        // customize the action appearance
//        deleteAction.image = UIImage(named: "deleteIcon")
//
//        return [deleteAction]
//    }
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//        options.transitionStyle = .border
//        return options
//    }
//}

extension ToDoViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
