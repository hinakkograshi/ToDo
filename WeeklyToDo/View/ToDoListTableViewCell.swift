//
//  ToDoListTableViewCell.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/08/26.
//

import UIKit
//import SwipeCellKit

protocol ChangeDelegate {
    func textFieldDidEndEditing(cell:ToDoListTableViewCell, value:String)
}

class ToDoListTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var checkImageView: UIImageView!

    @IBOutlet weak var toDoTextField: UITextField!
    var delegate: ChangeDelegate! = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        toDoTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    //デリゲートメソッド
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //キーボードを閉じる。
        textField.resignFirstResponder()
        return true
    }
    //デリゲートメソッド
    func textFieldDidEndEditing(_ textField: UITextField) {
        //テキストフィールドから受けた通知をデリゲート先に流す。
        self.delegate.textFieldDidEndEditing(cell: self, value: textField.text!)
    }

    
}
