//
//  DiaryViewController.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/09/02.
//

import UIKit

class DiaryViewController: UIViewController {

    @IBOutlet weak var titleText: UITextView!
    @IBOutlet weak var contentText: UITextView!

    @IBOutlet weak var dateLabel: UILabel!

    let calendarRealmModel = CalendarRealmModel()
    var day = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        titleText.layer.borderColor = UIColor.lightGray.cgColor
        titleText.layer.borderWidth = 0.5
        titleText.layer.cornerRadius = 5
        titleText.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        //textViewに枠線つける
        contentText.layer.borderColor = UIColor.lightGray.cgColor
        contentText.layer.borderWidth = 0.5
        contentText.layer.cornerRadius = 5
        contentText.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        dateLabel.text = day
    }
    
    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    //保存ボタンを押した際に保存
    @IBAction func diarySave(_ sender: UIBarButtonItem) {
        calendarRealmModel.createRealm(realmTitle: titleText.text  ?? "", realmContent: contentText.text ?? "", realmDate: dateLabel.text ?? "", realmDateCreated: Date().description)
        self.dismiss(animated: true,completion: nil)
    }
}
