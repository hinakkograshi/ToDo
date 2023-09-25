//
//  HelpListViewController.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/09/16.
//

import UIKit

class HelpListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    private let supportContents = [
        HelpItem(
            label: "操作説明",
            url: URL(string: "https://hiyokkograshi.com/%e6%93%8d%e4%bd%9c%e8%aa%ac%e6%98%8e/#toc2")!),
        HelpItem(
            label: "開発者を応援する📣",
            url: URL(string: "https://itunes.apple.com/app/id6464771684?action=write-review")!),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "HelpTableViewCell", bundle: nil), forCellReuseIdentifier: "HelpListCell")
        tableView.rowHeight = 60

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supportContents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpListCell", for: indexPath) as! HelpTableViewCell
        cell.supportLabel.text = self.supportContents[indexPath.row].label
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = self.supportContents[indexPath.row].url
        UIApplication.shared.open(url)
//        選択されてグレーになり、すぐに白に戻す
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private struct HelpItem {
    let label: String
    let url: URL
}
