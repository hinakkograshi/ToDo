//
//  ToDoListViewController.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/08/27.
//

import UIKit
import XLPagerTabStrip

class ToDoListViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        // 画面UIについての処理
        setupUI()
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 強制的に再選択し、changeCurrentIndexProgressiveを動作させる（ 0番目 → 1番目 → 0番目 ）
        moveToViewController(at: 1, animated: false)
        moveToViewController(at: 0, animated: false)
    }

    func setupUI() {
        // ButtonBar全体の背景色
        settings.style.buttonBarBackgroundColor = UIColor.white
        // ButtonBarItemの背景色
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        // ButtonBarItemの文字色
        settings.style.buttonBarItemTitleColor = UIColor.lightGray
        // ButtonBarItemのフォントサイズ
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        // 選択中のButtonBarインジケーターの色
        settings.style.selectedBarBackgroundColor = UIColor.orange
        // 選択中のButtonBarインジケーターの太さ
        settings.style.selectedBarHeight = 2.0
        // ButtonBarの左端の余白
        settings.style.buttonBarLeftContentInset = 8
        // ButtonBarの右端の余白
        settings.style.buttonBarRightContentInset = 8
        // Button内の余白
        settings.style.buttonBarItemLeftRightMargin = 32
        // スワイプやButtonBarItemタップ等でページを切り替えた時の動作
        changeCurrentIndexProgressive = { oldCell, newCell, progressPercentage, changeCurrentIndex, animated in
            // 変更されたか、選択前後のCellをアンラップ
            guard changeCurrentIndex, let oldCell = oldCell, let newCell = newCell else { return }
            // 選択前のセルの状態を指定
            oldCell.label.textColor = UIColor.lightGray
            // 選択後のセルの状態を指定する
            newCell.label.textColor = UIColor.black
        }
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        //管理されるViewControllerを返す処理
        let firstVC = UIStoryboard(name: "ToDo", bundle: nil).instantiateViewController(withIdentifier: "ToDo")
        let secondVC = UIStoryboard(name: "Reward", bundle: nil).instantiateViewController(withIdentifier: "Reward")
        let childViewControllers:[UIViewController] = [firstVC, secondVC]
        return childViewControllers
    }
}
