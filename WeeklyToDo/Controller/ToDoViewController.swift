//
//  ViewController.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/08/19.
//

import UIKit
import RealmSwift
import XLPagerTabStrip

class ToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //ここがボタンのタイトルに利用されます
    var itemInfo: IndicatorInfo = "やること"

    @IBOutlet weak var tableView: UITableView!

    var toDoItems: Results<Item>?
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60.0
        tableView.register(UINib(nibName: "ToDoListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ToDoListTableViewCell
        cell.checkImageView.image = UIImage(systemName: "square")
       
        cell.toDoLabel.text = "ToDoを記入してください"
        return cell
    }
}

extension ToDoViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

