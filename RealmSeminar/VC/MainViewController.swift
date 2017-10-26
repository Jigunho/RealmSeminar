import Realm
import UIKit
import RealmSwift
class MainViewController : UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var executiveCheck: UISwitch!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var orderTextField: UITextField!
    @IBOutlet weak var partTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var contentsScrollView: UIScrollView!
    
    
    var slides : [ContentView] = []
    var allStudents : Results<StudentModel>!
    var students : [StudentModel] = []

    var orderTxt : Int = 0{
        didSet{
            orderLabel.text = "\(orderTxt+19)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        contentsScrollView.delegate = self

        slides = createSlides()
        settingScrollView(slides: slides)
        
        pageControll.numberOfPages = slides.count
        pageControll.currentPage = 0

        orderTxt = 0

        allStudents = RealmManager.getAllStudentList()
    
        tableSetting(num: orderTxt)

        
        print("\(RLMRealmConfiguration.default().fileURL)")
    }
  
    @IBAction func deleteRealmDB(_ sender: Any) {
        try? FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
    }
    @IBAction func deleteAll(_ sender : UIButton!){
       
        RealmManager.deleteAll()
        students.removeAll()
        slides[orderTxt].reloadData()
  
    }
    
    @IBAction func addStudent(_ sender: Any) {
        
        var check = true
        if(!executiveCheck.isOn){ check = false }
        let model = StudentModel(name: nameTextField.text, order: orderTxt, age: 20, part: partTextField.text, active: check)
        RealmManager.addStudentIntoGroup(data: model, order: orderTxt)
        
    }
    
    func tableSetting(num : Int){
        
//        students = allStudents.filter("order==\(num)").toArray(ofType: StudentModel.self)
//        students = allStudents.filter("order=\(num)").toArray(ofType: StudentModel.self)
//        students = allStudents.filter("order=%@",num).toArray(ofType: StudentModel.self)
//        students = allStudents.filter("order==%@",num).toArray(ofType: StudentModel.self)

//        students = allStudents.filter("order=%@",num).sorted(byKeyPath: "name").toArray(ofType: StudentModel.self)


        /*
        
             query
        
        */
        slides[num].reloadData()
        
    }
    
    func createSlides() -> [ContentView]{
        print("create")
        let content1 : ContentView = Bundle.main.loadNibNamed("ContentView", owner: self, options: nil)?.first as! ContentView
        let content2 : ContentView = Bundle.main.loadNibNamed("ContentView", owner: self, options: nil)?.first as! ContentView
        let content3 : ContentView = Bundle.main.loadNibNamed("ContentView", owner: self, options: nil)?.first as! ContentView

        
        return [content1, content2, content3]
    }
    func settingScrollView(slides : [ContentView]){

        contentsScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        contentsScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height-120)
        
        contentsScrollView.isPagingEnabled = true
       
        for i in 0 ..< slides.count{
           // print("delegate")
            slides[i].delegate = self
            slides[i].dataSource = self
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height-120)
            contentsScrollView.addSubview(slides[i])
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageIndex = round(contentsScrollView.contentOffset.x/view.frame.width)
        pageControll.currentPage = Int(pageIndex)
        
        orderTxt = Int(pageIndex)
        tableSetting(num: orderTxt)

    }
}
extension MainViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let student = students[indexPath.row]
        
        let content : ContentView = Bundle.main.loadNibNamed("ContentView", owner: self, options: nil)?.first as! ContentView
        
        content.register(UINib(nibName:"ContentTableCell", bundle:nil), forCellReuseIdentifier: "ContentTableCell")

        let cell = (content.dequeueReusableCell(withIdentifier: "ContentTableCell") as? ContentTableCell)!
  
        cell.name.text = student.name
        cell.part.text = student.part
        if(student.active){
            cell.executives.image = UIImage(named : "star1")
        }else{
            cell.executives.image = UIImage(named : "star2")
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
}
