
import Foundation
import Realm
import RealmSwift
class StudentModel : Object{
    
    @objc dynamic var uuid = UUID().uuidString
    @objc dynamic var order = 0
    @objc dynamic var school : String?   // combine school && name
    @objc dynamic var name = ""
    @objc dynamic var age = 0
    @objc dynamic var part = ""
    @objc dynamic var active : Bool = false
    convenience init(name : String? ,school : String = "soongsil",
                     order : Int = 21 ,age : Int?, part : String?,
                     active : Bool = false) {
        self.init()
        self.name = name!
        self.order = order
        self.school = school
        self.age = age!
        self.part = part!
        self.active = active
    }
    override static func primaryKey() -> String? {
        return "uuid"
    }
}
class newStudentModel : Object{
    
    @objc dynamic var position : String?
    @objc dynamic var name = ""
    @objc dynamic var age = 0
    @objc dynamic var part = ""
    @objc dynamic var active : Bool = false
    convenience init(name : String? , age : Int?, part : String?, active : Bool = false) {
        self.init()
        
        self.name = name!
        self.age = age!
        self.part = part!
        self.active = active
    }
}
class OrderModel : Object{
    
    private var students = List<StudentModel>()
    private var executives = List<StudentModel>()
    @objc dynamic var orderNumber : Int = 0

    convenience init(num : Int) {
        self.init()
        self.orderNumber = num
    }

    func addStudents(item: StudentModel) {
        let realm = try! Realm()
        
        try! realm.write {
            students.append(item)
          //  realm.
        }
        
    }
    func getStudentsList() -> List<StudentModel>{
        return students
    }
    func getExecutivesList() -> List<StudentModel>{
        return executives
    }
}
