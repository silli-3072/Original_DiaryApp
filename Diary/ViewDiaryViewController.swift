
import UIKit

class ViewDiaryViewController: UIViewController {
    
    @IBOutlet var morningButton: UIButton!
    @IBOutlet var nightButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        morningButton.layer.cornerRadius = 20
        nightButton.layer.cornerRadius = 20
        
    }

}
