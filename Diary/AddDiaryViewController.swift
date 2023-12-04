
import UIKit

class AddDiaryViewController: UIViewController {
    
    var dayData: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = dayData
    }

}
