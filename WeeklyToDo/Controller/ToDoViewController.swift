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

class ToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //ここがボタンのタイトルに利用されます
    var itemInfo: IndicatorInfo = "やること"

    @IBOutlet weak var tableView: UITableView!

    let realm = try! Realm()

    var toDoItems: Results<Item>?



    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60.0
        tableView.register(UINib(nibName: "ToDoListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        //🟥忘れるな
        loadItems()

        //   newCategoryをRealmコンテナにカテゴリ保存。func save
        //        save(category: newCategory)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }

//🟥customCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ToDoListTableViewCell
        //🟥 SwipeCellKit
        cell.delegate = self
        //           cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added yet."

        cell.checkImageView.image = UIImage(systemName: "square")
        if let item = toDoItems?[indexPath.row] {
            cell.toDoLabel?.text = item.title
            //三項演算子
            //カスタム・アクセサリー・ビューがaccessoryViewプロパティで設定されている場合、このプロパティの値は無視される。
            //accessoryTypeが設定されている場合は、.checkmark
            cell.checkImageView.image = item.done ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
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


    //データ操作
    //MARK: - Data Manipulation Methods
    func save(items: Item) {
        do {
            //保存
            try realm.write {
                realm.add(items)
            }
        } catch {
            print("Errorsaving category \(error)")
        }
        tableView.reloadData()
    }
    //データの取得.Reed
    func loadItems() {
        //realm内のカテゴリオブジェクトをすべて取得。
        // 🟩コンテナ型であるresults
        //それらの変数を自動更新して監視するだけ
        toDoItems = realm.objects(Item.self)
        tableView.reloadData()
    }

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
            //realmは自動更新型だから必要ない
            //                self.categories.append(newCategory)
            //                newCategoryをRealmコンテナにカテゴリ保存。func save
            self.save(items: newItem)

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
extension ToDoViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if let itemForDeletion = self.toDoItems?[indexPath.row] {
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
        // customize the action appearance
        deleteAction.image = UIImage(named: "deleteIcon")

        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}
func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
    var options = SwipeOptions()
    options.expansionStyle = .destructive
    return options
}



//extension ToDoViewController: SwipeTableViewCellDelegate {
//
//}

extension ToDoViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
