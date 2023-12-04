
import Foundation
import RealmSwift

class DiaryData: Object {
    @Persisted var day: Date
    @Persisted var sentence: String = ""
    
}
