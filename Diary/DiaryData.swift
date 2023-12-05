
import Foundation
import RealmSwift

class DiaryData: Object {
    @Persisted var day: Date
    @Persisted var timeOfDay: String
    @Persisted var sentence: String
    
}
