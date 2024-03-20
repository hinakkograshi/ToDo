//
//  RewardViewController.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/08/27.
//

import UIKit
import XLPagerTabStrip

class RewardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate, ChangeDelegate {
    var itemInfo: IndicatorInfo = "ごほうび"

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emptyView: UIView!
    let rewardRealmModel = RewardRealmModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.rowHeight = 60.0
        rewardRealmModel.sortRead()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ToDoListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        setDismissKeyboard()
        tableView.reloadData()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if rewardRealmModel.rewardList.count == 0 {
            emptyView.isHidden = false
        }
        else {
            emptyView.isHidden = true
        }
        return rewardRealmModel.rewardList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ToDoListTableViewCell
        cell.delegate = self
        if let Reward = rewardRealmModel.rewardList?[indexPath.row] {
            cell.toDoTextField?.text = Reward.title
            cell.checkImageView.image = Reward.done ? UIImage(named: "present") : UIImage(named: "rewardBox")
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }

    func textFieldDidEndEditing(cell: ToDoListTableViewCell, value: String) {
        let index = tableView.indexPathForRow(at: cell.convert(cell.bounds.origin, to:tableView))
        rewardRealmModel.updateRealm(index: index!.row, value: value)
        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rewardRealmModel.checkUpdateRealm(index: indexPath.row)
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        rewardRealmModel.sortCellUpdate(sourceIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return []
    }
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            rewardRealmModel.deleteRealm(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    @IBAction func addButonPressed(_ sender: UIButton) {
        var textField = UITextField()
        let alert = UIAlertController(title: "ごほうびの追加", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "追加", style: .default) { action in
            if textField.text == "" {
                let nothingAlert = AlertMaker().noStringAlert(title: "追加できませんでした。", message: "中身のないごほうびは追加できません。")
                self.present(nothingAlert, animated: true, completion: nil)
                return
            }
            self.rewardRealmModel.createRealm(rewardText: textField.text!)
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { field in
            textField = field
            textField.placeholder = "新しくごほうびを追加"
        }
        let cancelButton = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
    }

    func tapDeleteButton() {
        let alert = UIAlertController(title: "削除", message: "達成したごほうびを削除しますか？", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "削除", style: .default) {(action) in
            self.rewardRealmModel.checkboxDelete()
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension RewardViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
