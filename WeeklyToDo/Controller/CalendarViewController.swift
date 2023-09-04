//
//  CalendarViewController.swift
//  WeeklyToDo
//
//  Created by Hina on 2023/08/19.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import RealmSwift

class CalendarViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var calendar: FSCalendar!

    @IBOutlet weak var dateLabel: UILabel!
    var calendarDay : String = ""

    let realm = try! Realm()

    var diaryModels: Results<DiaryModel>!
    var readRealmArray:[[String:String]] = []


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
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("モーダルから戻ったよ")
        tableView.reloadData()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readRealmArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DiaryTableViewCell
        cell.titleText.text = readRealmArray[indexPath.row]["RealmTitle"]
        cell.contentText.text = readRealmArray[indexPath.row]["RealmContent"]
        print("\(cell.titleText.text)")
        print("\(cell.contentText.text)")
        return cell
    }

    //🟥削除
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let reault = realm.objects(DiaryModel.self).filter(NSPredicate(format: "date == %@", calendarDay))
//                if let itemForDeletion = self.toDoItems?[indexPath.row] {
                    do {
                        //セルを削除してRealmデータベースに存在しないようにする
                        try self.realm.write {
                            self.realm.delete(reault[indexPath.row])
                            filterReadRealm(calendarDay:calendarDay)
                        }
                    } catch {
                        print("Error deleting category,\(error)")
                    }
                tableView.deleteRows(at: [indexPath], with: .automatic)
//            }
            }
        }
    
    
    @IBAction func addButonPressed(_ sender: UIButton) {

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
        dateLabel.text = "\(year)年\(month)月\(day)日"
        calendarDay = dateLabel.text ?? ""
        print("\(calendarDay)")
        self.filterReadRealm(calendarDay:calendarDay)

        self.tableView.reloadData()
    }

    func filterReadRealm(calendarDay:String) {
        do{
            self.readRealmArray = []

            for filterReadResult in realm.objects(DiaryModel.self).filter(NSPredicate(format: "date == %@", calendarDay)){

                self.readRealmArray.append(["RealmTitle":filterReadResult.title,"RealmContent":filterReadResult.content])
            }
        }catch{

            print(error.localizedDescription)

        }
    }

}
//カレンダーで、日にちをタップしたら、TableViewにその日のイベントを表示するようにしていきます。
//    //まず、保存されたデータの取得関数は下記
//    func getModel() {
//        let results = realm.objects(DiaryModel.self)
//        var diaryModels: [[String:String]] = []
//        for result in results {
//            diaryModels.append(["title": result.title,
//                                "content": result.content,
//                                "date": result.date])
//        }
//    }

    //        //スケジュール取得
    //                let realm = try! Realm()
    //                var result = realm.objects(DiaryModel.self)
    ////        "\(year)/\(month)/\(day)"
    //                result = result.filter("date = '\(calendarDay)'")
    //                print(result)
    //                for ev in result {
    //                    if diaryModel.date {
    //                        titleText.text = ev.title
    //                        labelDate.textColor = .black
    //                        view.addSubview(labelDate)
    //                    }
    //                }

    //    func getModel() {
    //        let results = diaryModels?.filter("date == %@", calendarDay)
    ////        realm.objects(Person.self).filter("age >= 20")
    //        for result in results {
    //            eventModels.append(["title": result.title,
    //                                "memo": result.memo,
    //                                "date": result.date,
    //                                "start_time": result.start_time,
    //                                "end_time": result.end_time])
    //        }
    //    }


//        let calendarDate = Calendar(identifier: .gregorian)
//        let year = calendarDate.component(.year, from: date)
//        let month = calendarDate.component(.month, from: date)
//        let day = calendarDate.component(.day, from: date)
//
//        if UserDefaults.standard.object(forKey: "addORLook") as! String == "追加" {
//
//        createTextFieldAlert(calendarDay: "\(year)年\(month)月\(day)日")
//
//        }else{
//
//            self.realmCRUDModel.filterReadRealm(calendarDay: "\(year)年\(month)月\(day)日")
//            self.tableView.reloadData()
//
//        }



    //選択された日のイベントのみを取り出す
//    func filterModel() {
//        var filterdEvents: [[String:String]] = []
//        for diaryModel in diaryModels {
//            if diaryModel["date"] == stringFromDate(date: selectedDate as Date, format: "yyyy.MM.dd") {
//                filterdEvents.append(diaryModel)
//            }
//        }
//        filterdModels = filterdEvents
//    }
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
////        filterModel()
//        tableView.reloadData()
//    }


