//
//  ToDoListTableViewCell.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/08/26.
//

import UIKit
import SwipeCellKit

class ToDoListTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var checkImageView: UIImageView!
    
    @IBOutlet weak var toDoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
