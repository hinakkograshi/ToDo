//
//  RewardViewController.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/08/27.
//

import UIKit
import XLPagerTabStrip

class RewardViewController: UIViewController {

    //ここがボタンのタイトルに利用されます
    var itemInfo: IndicatorInfo = "ごほうび"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension RewardViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
