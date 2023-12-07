
import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    
    let realm = try! Realm()
    
    var timeOfDay: String = ""
    
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
        
        let date = getCurrentDate()
        dayLabel.text = stringConversion(date: date)
        
        getMorningDiaryDate()
        getNightDiaryDate()
    }
    
    @IBAction func addMorningDiary() {
        timeOfDay = "morning"
        transition(timeOfDay: timeOfDay)
        
    }
    
    @IBAction func addNightDiary() {
        timeOfDay = "night"
        transition(timeOfDay: timeOfDay)
        
    }
    
    func getCurrentDate() -> Date {
        let date = NSDate()
        return  date as Date
    }
    
    func stringConversion(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dateStr = formatter.string(from: date as Date)
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale?
        return  dateStr
        
    }
    
    func getMorningDiaryDate() {
        let morningDiary = realm.objects(DiaryData.self).filter("timeOfDay == 'morning'")
        var arrayCount = morningDiary.count
        
        if arrayCount == 0 {
            return
        }
        
        for i in 0...arrayCount - 1 {
            let dayData = stringConversion(date: morningDiary[i].day)
            
            if dayLabel.text == dayData {
                addMorningButton.setTitle(morningDiary[i].sentence, for: .normal)
            }
            
        }
    }
    
    func getNightDiaryDate() {
        let nightDiary = realm.objects(DiaryData.self).filter("timeOfDay == 'night'")
        var arrayCount = nightDiary.count
        
        if arrayCount == 0 {
            return
        }
        
        for i in 0...arrayCount - 1 {
            let dayData = stringConversion(date: nightDiary[i].day)
            
            if dayLabel.text == dayData {
                addNightButton.setTitle(nightDiary[i].sentence, for: .normal)
            }
            
        }
    }
    
    func transition(timeOfDay: String) {
        let storyboard: UIStoryboard = self.storyboard!
        let addDiaryVC = storyboard.instantiateViewController(withIdentifier: "AddDiary") as! UINavigationController
        addDiaryVC.modalPresentationStyle = .fullScreen
        let getAddDiaryVC = addDiaryVC.viewControllers[0] as! AddDiaryViewController
        getAddDiaryVC.dayData = dayLabel.text!
        getAddDiaryVC.timeOfDay = timeOfDay
        self.present(addDiaryVC, animated: true, completion: nil)
    }
    
}
