
import UIKit
import RealmSwift

class AddDiaryViewController: UIViewController {
    
    let realm = try! Realm()
    
    var dayData: String = ""
    var timeOfDay: String = ""
    
    @IBOutlet var sentenceTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sentenceTextView.translatesAutoresizingMaskIntoConstraints = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = dayData
        
    }
    
    //TODO: textviewが大きくて、画面を触った判定がされずらい
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.sentenceTextView.isFirstResponder {
            self.sentenceTextView.resignFirstResponder()
        }
    }
    
    @IBAction func save() {
        let diaryData = DiaryData()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let convertDate = dateFormatter.date(from: dayData)
        
        diaryData.day = convertDate!
        diaryData.sentence = sentenceTextView.text ?? ""
        diaryData.timeOfDay = timeOfDay
        
        try! realm.write {
            realm.add(diaryData)
        }
        
        self.dismiss(animated: true)
    }
    
}
