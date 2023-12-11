
import UIKit
import RealmSwift
import FSCalendar
import CalculateCalendarLogic

class ViewDiaryViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    let realm = try! Realm()
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    
    var timeOfDay: String = ""    
    var morningSentence: String = ""
    var nightSentence: String = ""
    var existenceDiaryDateArray: [String] = []
    var saveData: UserDefaults = UserDefaults.standard
    
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var morningButton: UIButton!
    @IBOutlet var nightButton: UIButton!
    @IBOutlet var dayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var currentDate = getCurrentDate()
        var strCurrentDate = stringConversion(date: currentDate)
        saveData.set(strCurrentDate, forKey: "date")
        
        self.calendar.dataSource = self
        self.calendar.delegate = self
        
        calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
        calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
        calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
        calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
        calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
        calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
        calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
        
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = .systemRed
        calendar.calendarWeekdayView.weekdayLabels[6].textColor = .systemBlue
        
        morningButton.layer.cornerRadius = 20
        nightButton.layer.cornerRadius = 20
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var date = saveData.string(forKey: "date")
        
        dayLabel.text = date
        
        getMorningDiaryDate()
        getNightDiaryDate()
        
    }
    
    @IBAction func editMorningDiary() {
        timeOfDay = "morning"
        morningSentence = getMorningDiaryDate()
        
        transition(timeOfDay: timeOfDay,sentence: morningSentence)
        
    }
    
    @IBAction func editNightDiary() {
        timeOfDay = "night"
        nightSentence = getNightDiaryDate()
        
        transition(timeOfDay: timeOfDay, sentence: nightSentence)
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dayLabel.text = stringConversion(date: date)
        
        saveData.set(stringConversion(date: date), forKey: "date")
        
        getMorningDiaryDate()
        getNightDiaryDate()
        
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let diary = realm.objects(DiaryData.self)
        let arrayCount = diary.count
        
        if arrayCount == 0 {
            return 0
        }
        
        for i in 0...arrayCount - 1 {
            var strDate = stringConversion(date: diary[i].day)
            existenceDiaryDateArray.append(strDate)
        }
        
        if existenceDiaryDateArray.first(where: { $0 == stringConversion(date: date) }) != nil {
            return 1
        }
        return 0
        
    }
    
    func judgeHoliday(_ date : Date) -> Bool {
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }
    
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if self.judgeHoliday(date){
            return UIColor.red
        }
        
        let weekday = self.getWeekIdx(date)
        
        if weekday == 1 {
            return UIColor.red
        } else if weekday == 7 {
            return UIColor.blue
        }
        
        return nil
    }
    
    func getCurrentDate() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let date = NSDate()
        return  date as Date
    }
    
    func stringConversion(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let dateStr = formatter.string(from: date as Date)
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale?
        return  dateStr
        
    }
    
    func getMorningDiaryDate() -> String{
        let morningDiary = realm.objects(DiaryData.self).filter("timeOfDay == 'morning'")
        let arrayCount = morningDiary.count
        
        if arrayCount == 0 {
            return morningSentence
        }
        
        for i in 0...arrayCount - 1 {
            let dayData = stringConversion(date: morningDiary[i].day)
            
            if dayLabel.text == dayData {
                morningSentence = morningDiary[i].sentence
                morningButton.setTitle(morningSentence, for: .normal)
                return morningSentence
            } else {
                morningButton.setTitle("", for: .normal)
            }
            
        }
        
        morningSentence = ""
        return morningSentence
    }
    
    func getNightDiaryDate() -> String{
        let nightDiary = realm.objects(DiaryData.self).filter("timeOfDay == 'night'")
        let arrayCount = nightDiary.count
        
        if arrayCount == 0 {
            return nightSentence
        }
        
        for i in 0...arrayCount - 1 {
            let dayData = stringConversion(date: nightDiary[i].day)
            
            if dayLabel.text == dayData {
                nightSentence = nightDiary[i].sentence
                nightButton.setTitle(nightSentence, for: .normal)
                return nightSentence
            } else {
                nightButton.setTitle("", for: .normal)
            }
            
        }
        
        nightSentence = ""
        return nightSentence
    }
    
    func transition(timeOfDay: String, sentence: String) {
        let storyboard: UIStoryboard = self.storyboard!
        let addDiaryVC = storyboard.instantiateViewController(withIdentifier: "AddDiary") as! UINavigationController
        addDiaryVC.modalPresentationStyle = .fullScreen
        let getAddDiaryVC = addDiaryVC.viewControllers[0] as! AddDiaryViewController
        getAddDiaryVC.dayData = dayLabel.text!
        getAddDiaryVC.timeOfDay = timeOfDay
        getAddDiaryVC.sentence = sentence
        self.present(addDiaryVC, animated: true, completion: nil)
    }
    
}
