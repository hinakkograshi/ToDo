//
//  CalendarViewController.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/08/19.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic

class CalendarViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var calendar: FSCalendar!

    @IBOutlet weak var dateLabel: UILabel!
    var calendarDay : String = ""
    let realmCRUDModel = RealmCRUDModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 150.0
        // デリゲートの設定
        self.calendar.dataSource = self
        self.calendar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DiaryTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // MARK: id をキーとしてソートする
//        realmCRUDModel.sortedRead()
        //        diaryModels = realm.objects(DiaryModel.self).sorted(byKeyPath: "dateCreated")
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("モーダルから戻ったよ")
        realmCRUDModel.filterReadRealm(calendarDay:calendarDay)
        tableView.reloadData()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return realmCRUDModel.readRealmArray.count
//        realmCRUDModel.filterReadRealm(calendarDay:calendarDay)
//        return realmCRUDModel.getCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DiaryTableViewCell
//        realmCRUDModel.calendarDayRead(calendarDay: calendarDay)
        cell.titleText.text = realmCRUDModel.readRealmArray[indexPath.row].title
        cell.contentText.text = realmCRUDModel.readRealmArray[indexPath.row].content

        return cell
    }
    //🍊
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editVC = UIStoryboard(name: "Edit", bundle: nil).instantiateViewController(withIdentifier: "Edit") as! EditViewController
        editVC.day = calendarDay
        editVC.selectedDiaryTitle = realmCRUDModel.readRealmArray[indexPath.row].title
        editVC.selectedDiaryContent = realmCRUDModel.readRealmArray[indexPath.row].content
        editVC.selectedDateCreated = realmCRUDModel.readRealmArray[indexPath.row].dateCreated

        let navigationController = UINavigationController(rootViewController: editVC)
        //🟥フルスクリーンにしないと閉じたことを認識されない
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
        //選択されてグレーになり、すぐに白に戻す
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // テーブルビューの編集を許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    //🟥削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            realmCRUDModel.deleteRealm(calendarDay: calendarDay, index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }


    @IBAction func addButonPressed(_ sender: UIButton) {
        if calendarDay == "" {
            let alert = UIAlertController(title: "日付が選択されてません", message: "カレンダーから日付を選択してください。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }

        let diaryVC = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "Diary") as! DiaryViewController
        diaryVC.day = calendarDay
        let navigationController = UINavigationController(rootViewController: diaryVC)
        //🟥フルスクリーンにしないと閉じたことを認識されない
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    // 祝日判定を行い結果を返すメソッド(True:祝日)
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)

        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)

        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }

    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }

    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return UIColor.red
        }

        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return UIColor.red
        }
        else if weekday == 7 {  //土曜日
            return UIColor.blue
        }
        return nil
    }

    //FSCalendarで日付がタップされた時の処理は以下の関数を使用
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let day = tmpDate.component(.day, from: date)
        let m = String(format: "%02d", month)
        let d = String(format: "%02d", day)
        dateLabel.text = "\(year)/\(m)/\(d)"
        calendarDay = dateLabel.text ?? ""
        print("\(calendarDay)")
        realmCRUDModel.filterReadRealm(calendarDay:calendarDay)
        tableView.reloadData()
    }

    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"

        let calendarEvent = formatter.string(from: date)
        //🟥Modelにどう持たせるか？
        let hasEvent = !realmCRUDModel.eventRead(calendarEvent: calendarEvent).isEmpty
        if hasEvent == true {
            return UIImage(named: "calendar")
        } else {
            return nil
        }
    }
}
