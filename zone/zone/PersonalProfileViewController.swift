
import UIKit
import Firebase
import FirebaseAuth

class PersonalProfileViewController: UIViewController{
    var screen_width:CGFloat = 0
    var screen_height:CGFloat = 0
    
    override func viewDidLoad() {
        screen_width = view.frame.width
        screen_height = view.frame.height
        
        super.viewDidLoad()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
