//
//  DiaryTableViewCell.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/09/03.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {


    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var contentText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
