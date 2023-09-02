//
//  RewardViewController.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/08/27.
//

import UIKit
import RealmSwift
import XLPagerTabStrip

class RewardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate, ChangeDelegate {
    //ここがボタンのタイトルに利用されます
    var itemInfo: IndicatorInfo = "ごほうび"

    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    var RewardList: Results<Reward>!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        //並べ替えデータ取得
        RewardList = realm.objects(Reward.self).sorted(byKeyPath: "order")
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60.0
        tableView.register(UINib(nibName: "ToDoListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        setDismissKeyboard()
        //🟥忘れるな
        tableView.reloadData()
    }
    //デリゲートメソッド
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //キーボードを閉じる。
        textField.resignFirstResponder()
        return true
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RewardList.count
    }

    //🟨チェックボックスの色の変更
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ToDoListTableViewCell
        //自作のセルのデリゲート先に自分を設定する
        cell.delegate = self
        if let Reward = RewardList?[indexPath.row] {
            cell.toDoTextField?.text = Reward.title
            cell.checkImageView.image = Reward.done ? UIImage(systemName: "checkmark.square",withConfiguration: UIImage.SymbolConfiguration(hierarchicalColor: .systemRed)) : UIImage(systemName: "square",withConfiguration: UIImage.SymbolConfiguration(hierarchicalColor: .red))
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
            RewardList[index!.row].title = value
        }

        self.tableView.reloadData()
    }
    //MARK - TableView Delegate Methods
    //cellがクリックで選択された

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        Updateする場所はdidSelectRowAt.Updateは新規作成と似てる
        if let Reward = RewardList?[indexPath.row] {
            do {
                //Updateitemの更新されたプロパティを以前は何であったかを問わず、トグルして書き込む
                try realm.write {
                    Reward.done = !Reward.done
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

        try! realm.write {
            let sourceObject = RewardList[sourceIndexPath.row]
            print("最初の行",sourceObject.order)
            let destinationObject = RewardList[destinationIndexPath.row]

            let destinationObjectOrder = destinationObject.order

            if sourceIndexPath.row < destinationIndexPath.row {

                for index in sourceIndexPath.row...destinationIndexPath.row {
                    let object = RewardList[index]
                    object.order -= 1

                }
            } else {
                for index in (destinationIndexPath.row..<sourceIndexPath.row).reversed() {
                    let object = RewardList[index]
                    object.order += 1
                }
            }
            sourceObject.order = destinationObjectOrder
            print("最後の行",sourceObject.order)
        }
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

//🟥削除
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let itemForDeletion = self.RewardList?[indexPath.row] {
                do {
                    //セルを削除してRealmデータベースに存在しないようにする
                    try self.realm.write {
                        self.realm.delete(itemForDeletion)
                    }
                } catch {
                    print("Error deleting category,\(error)")
                }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        }
    }



    @IBAction func addButonPressed(_ sender: UIButton) {
        var textField = UITextField()
        let alert = UIAlertController(title: "新しいカテゴリーを追加", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "追加", style: .default) { action in

            let newItem = Reward()
            newItem.title = textField.text!
            if let lastItem = self.RewardList.last {
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

extension RewardViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
