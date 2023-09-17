//
//  HelpListViewController.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/09/16.
//

import UIKit

class HelpListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "HelpTableViewCell", bundle: nil), forCellReuseIdentifier: "HelpListCell")

        //TabBar
//        hidesBottomBarWhenPushed = true

        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpListCell", for: indexPath) as! HelpTableViewCell
        return cell
    }


}
