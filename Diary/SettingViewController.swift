
import UIKit

class SettingViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var notificationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationTableView.register(UINib(nibName: "PermissionTableViewCell", bundle: nil), forCellReuseIdentifier:  "PermissionCell")
        notificationTableView.register(UINib(nibName: "TimeScheduleTableViewCell", bundle: nil), forCellReuseIdentifier:  "TimeScheduleCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let permissionCell = notificationTableView.dequeueReusableCell(withIdentifier: "PermissionCell") as! PermissionTableViewCell
        let timeScheduleCell = notificationTableView.dequeueReusableCell(withIdentifier: "TimeScheduleCell") as! TimeScheduleTableViewCell
        
        switch indexPath.row {
        case 0: return permissionCell
        case 1: return timeScheduleCell
        default: return timeScheduleCell
        }
        
    }
    
}
