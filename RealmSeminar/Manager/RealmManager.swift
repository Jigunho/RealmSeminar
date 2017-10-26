import Realm
import Foundation
import RealmSwift
class RealmManager{

    static func addData(data : Object){
      
        let realm = try! Realm()

        try! realm.write {
            realm.add(data)
        }

    }
    static func getAllStudentList() -> Results<StudentModel>{
        
        let realm = try! Realm()

        let students = realm.objects(StudentModel.self)
        return students
        
    }
    static func deleteAll(){
        let realm = try! Realm()

        try! realm.write {
            realm.deleteAll()
        }
        
    }
    static func getStudentList(order : Int) -> List<StudentModel>{
        let realm = try! Realm()

        let group = try! realm.objects(OrderModel.self).filter("orderNumber==\(order)")
        
        for g in group{
            return g.getStudentsList()
        }
        
        return List<StudentModel>()
        
    }
    static func addStudentIntoGroup(data : StudentModel , order : Int){
        let realm = try! Realm()

      //  let groups = realm.objects(OrderModel.self).filter("orderNumber == %@",order)
          let groups = realm.objects(OrderModel.self).filter("orderNumber == \(order)")

        if(groups.count == 0){
            let newGroup = OrderModel(num: order)
            newGroup.addStudents(item: data)
            try! realm.write {
                realm.add(newGroup)
            }

        }else{
            for group in groups{
                group.addStudents(item: data)
            }
        }
        
    }
  
   
    
    static func getStudentArray(key : String) -> [StudentModel]{
        let results = try! Realm().objects(StudentModel.self).sorted(byKeyPath: key)
        
        return results.toArray(ofType: StudentModel.self)
    }
   
    
     func migration(){
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                
                if(oldSchemaVersion < 1) {
                    migration.enumerateObjects(ofType: StudentModel.className(), { oldObject, newObject in
                        
                        let name =  oldObject!["name"] as! String
                        let school = oldObject!["school"] as! String
                        newObject!["name"] = "\(school) \(name)"
                        
                    })
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
    }
    
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        
        return array
    }
}
