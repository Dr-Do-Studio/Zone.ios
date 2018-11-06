import UIKit
import Firebase
import FirebaseAuth

class PersonalProfileViewController: UIViewController{
    var screen_width:CGFloat = 0
    var screen_height:CGFloat = 0
    
    let ref = Database.database().reference()
    let temp_but = UIButton()
    override func viewDidLoad() {
        screen_width = view.frame.width
        screen_height = view.frame.height
        
        super.viewDidLoad()
        temp_but.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        temp_but.backgroundColor = .black
        temp_but.addTarget(self, action: #selector(addData), for: .touchUpInside)
        self.view.addSubview(temp_but)
    }
    
    @objc func addData(){
        print("user "+(Auth.auth().currentUser?.email)!+" is the currenly logging in user")
        ref.updateChildValues(["SomeValue":123123])
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
