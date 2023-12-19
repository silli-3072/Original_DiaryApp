
import UIKit
import RealmSwift

class AddDiaryViewController: UIViewController {
    
    let realm = try! Realm()
    
    var dayData: String = ""
    var timeOfDay: String = ""
    var sentence: String = ""
    
    @IBOutlet var sentenceTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sentenceTextView.translatesAutoresizingMaskIntoConstraints = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = dayData
        sentenceTextView.text = sentence
        
    }
    
    //TODO: textviewが大きくて、画面を触った判定がされずらい
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.sentenceTextView.isFirstResponder {
            self.sentenceTextView.resignFirstResponder()
        }
    }
    
    @IBAction func save() {
        displaySaveAlert()
        
    }
    
    @IBAction func back() {
        let alert = UIAlertController(title: "日記が保存されていません", message: "", preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(
                title: "戻る",
                style: .default,
                handler: { action in
                    self.dismiss(animated: true, completion: nil)
                }
            )
        )
        
        alert.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: .cancel,
                handler: nil
            )
        )
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func diarySave() {
        let diaryData = DiaryData()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        let convertDate = dateFormatter.date(from: dayData)
        
        diaryData.day = convertDate!
        diaryData.sentence = sentenceTextView.text ?? ""
        diaryData.timeOfDay = timeOfDay
        
        try! realm.write {
            realm.add(diaryData)
        }
    }
    
    func displaySaveAlert() {
        let alert = UIAlertController(title: "日記を保存しますか？", message: "", preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(
                title: "保存",
                style: .default,
                handler: { action in
                    self.erasePastDiary()
                    self.diarySave()
                    self.dismiss(animated: true)
                }
            )
        )
        
        alert.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: .cancel,
                handler: nil
            )
        )
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func erasePastDiary() {
        let diary = realm.objects(DiaryData.self).filter("timeOfDay == %@", timeOfDay)
        let arrayCount = diary.count
        
        if arrayCount == 0 {
            return
        }
        
        for i in 0...arrayCount - 1 {
            let diaryDayData = stringConversion(date: diary[i].day)
            
            if dayData == diaryDayData {
                try! realm.write {
                    let eraseData = diary[i]
                    realm.delete(eraseData)
                }
            }
            
        }
        
    }
    
    func stringConversion(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let dateStr = formatter.string(from: date as Date)
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale?
        return  dateStr
        
    }
    
}
