//
//  HelpListViewController.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/09/16.
//

import UIKit

class HelpListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    let supportContents = ["操作説明", "開発者を応援する📣"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "HelpTableViewCell", bundle: nil), forCellReuseIdentifier: "HelpListCell")
        tableView.rowHeight = 60

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpListCell", for: indexPath) as! HelpTableViewCell
        cell.supportLabel.text = self.supportContents[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: guard let url = URL(string: "https://hiyokkograshi.com/%e6%93%8d%e4%bd%9c%e8%aa%ac%e6%98%8e/#toc2") else { return }
            UIApplication.shared.open(url)
        case 1: guard let url = URL(string: "https://itunes.apple.com/app/id6464771684?action=write-review") else { return }
            UIApplication.shared.open(url)
        default:
            print("error")
        }
//        選択されてグレーになり、すぐに白に戻す
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
