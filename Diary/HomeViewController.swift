
import UIKit

class HomeViewController: UIViewController {
    
    var timeOfDay: String = ""
    
    @IBOutlet var dayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dayLabel.text = getCurrentDate()
    }
    
    @IBAction func addMorningDiary() {
        timeOfDay = "morning"
        transition(timeOfDay: timeOfDay)
        
    }
    
    @IBAction func addNightDiary() {
        timeOfDay = "night"
        transition(timeOfDay: timeOfDay)
        
    }
    
    func getCurrentDate() -> String {
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dateStr = formatter.string(from: date as Date)
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale?
        return  dateStr
    }
    
    func transition(timeOfDay: String) {
        let storyboard: UIStoryboard = self.storyboard!
        let addDiaryVC = storyboard.instantiateViewController(withIdentifier: "AddDiary") as! UINavigationController
        addDiaryVC.modalPresentationStyle = .fullScreen
        let getAddDiaryVC = addDiaryVC.viewControllers[0] as! AddDiaryViewController
        getAddDiaryVC.dayData = getCurrentDate()
        getAddDiaryVC.timeOfDay = timeOfDay
        self.present(addDiaryVC, animated: true, completion: nil)
    }
    
}
