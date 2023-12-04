
import UIKit
import RealmSwift

class AddDiaryViewController: UIViewController {
    
    let realm = try! Realm()
    
    var dayData: String = ""
    
    @IBOutlet var sentenceTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = dayData
        
    }
    
    @IBAction func save() {
        let diaryData = DiaryData()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let convertDate = dateFormatter.date(from: dayData)
        
        diaryData.day = convertDate!
        diaryData.sentence = sentenceTextView.text ?? ""
        
        try! realm.write {
            realm.add(diaryData)
        }
        
        self.dismiss(animated: true)
    }
    
}
