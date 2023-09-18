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
//        if let explanation = supportContents[0] {
//
//        } else if item = supportContents[1] {
//
//        }
        //選択されてグレーになり、すぐに白に戻す
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
