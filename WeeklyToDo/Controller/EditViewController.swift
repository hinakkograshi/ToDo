//
//  EditViewController.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/09/07.
//

import UIKit
import RealmSwift

class EditViewController: UIViewController {

    @IBOutlet weak var titleText: UITextView!
    @IBOutlet weak var contentText: UITextView!

    @IBOutlet weak var dateLabel: UILabel!
    let realm = try! Realm()
    let diaryModel = DiaryModel()
    var day = ""
    var selectedDiaryTitle = ""
    var selectedDiaryContent = ""
    var selectedDateCreated = ""


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
        titleText.text = selectedDiaryTitle
        contentText.text = selectedDiaryContent
        print("\(selectedDateCreated)")
    }

    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func editButton(_ sender: Any) {
        try! realm.write {

            diaryModel.title = titleText.text  ?? ""
            diaryModel.content = contentText.text ?? ""
            diaryModel.dateCreated = selectedDateCreated
            diaryModel.date = day

            realm.add(diaryModel, update: .modified)
        }
        self.dismiss(animated: true,completion: nil)
    }
    

}
