
import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    
    let realm = try! Realm()
    
    var timeOfDay: String = ""
    var modifiedDateCount: Int = 0
    var sentence: String = ""
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var addMorningButton: UIButton!
    @IBOutlet var addNightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMorningButton.layer.cornerRadius = 30
        addNightButton.layer.cornerRadius = 30
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
    }
    
    @IBAction func addMorningDiary() {
        timeOfDay = "morning"
        sentence = getMorningDiaryDate()
        
        transition(timeOfDay: timeOfDay,sentence: sentence)
        
    }
    
    @IBAction func addNightDiary() {
        timeOfDay = "night"
        sentence = getNightDiaryDate()
        
        transition(timeOfDay: timeOfDay, sentence: sentence)
        
    }
    
    @IBAction func addDay() {
        modifiedDateCount += 1
        
        updateUI()
    }
    
    @IBAction func subtractDay() {
        modifiedDateCount -= 1
        
        updateUI()
    }
    
    func getCurrentDate() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let date = NSDate()
        let modifiedDate = calendar.date(byAdding: .day, value: modifiedDateCount, to: date as Date)!
        return  modifiedDate as Date
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
            return sentence
        }
        
        for i in 0...arrayCount - 1 {
            let dayData = stringConversion(date: morningDiary[i].day)
            
            if dayLabel.text == dayData {
                sentence = morningDiary[i].sentence
                addMorningButton.setTitle(sentence, for: .normal)
                return sentence
            } else {
                addMorningButton.setTitle("", for: .normal)
            }
            
        }
        return sentence
    }
    
    func getNightDiaryDate() -> String{
        let nightDiary = realm.objects(DiaryData.self).filter("timeOfDay == 'night'")
        let arrayCount = nightDiary.count
        
        if arrayCount == 0 {
            return sentence
        }
        
        for i in 0...arrayCount - 1 {
            let dayData = stringConversion(date: nightDiary[i].day)
            
            if dayLabel.text == dayData {
                sentence = nightDiary[i].sentence
                addNightButton.setTitle(sentence, for: .normal)
                return sentence
            } else {
                addNightButton.setTitle("", for: .normal)
            }
            
        }
        
        return sentence
    }
    
    func updateUI() {
        let date = getCurrentDate()
        dayLabel.text = stringConversion(date: date)
        
        getMorningDiaryDate()
        getNightDiaryDate()
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
