import UIKit
import Firebase
import FirebaseAuth

class MediaViewController: UIViewController,UITextViewDelegate{
    var profileMode = DEFAULT_PROFILE_MODE //0 as personal profile, 1 as friends profile
    var friendUser = User()

    var media_type: String = ""
    var screen_width:CGFloat = 0
    var screen_height:CGFloat = 0
    
    var id_text_box = UITextField()
    
    @IBOutlet var save_button: UIButton!
    @IBOutlet var back_button: UIButton!
    @IBOutlet var edit_username: UIButton!
    @IBOutlet var id_label: UILabel!
    
    let ref = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    let storage_ref = Storage.storage().reference()
    
    let wrong_password_color_ani = CABasicAnimation(keyPath: "borderColor")
    
    override func viewDidLoad() {
        screen_width = view.frame.width
        screen_height = view.frame.height
        id_label.frame = CGRect(x: screen_width/10, y: screen_height/2, width: screen_width*0.8, height: 30)
        id_label.textAlignment = .center
        
        id_text_box.layer.borderColor = UIColor.black.cgColor
        id_text_box.layer.borderWidth = 1
        
        back_button.frame = CGRect(x: screen_width/10, y: screen_height/10, width: screen_width*0.2, height: 30)
        edit_username.addTarget(self, action: #selector(edit_username_action), for: .touchUpInside)
        save_button.addTarget(self, action: #selector(save_account_info), for: .touchUpInside)
        back_button.addTarget(self, action: #selector(go_back), for: .touchUpInside)
        
        if profileMode == FRIEND_PROFILE_MODE {
            print("now in friend's profile")
            save_button.removeFromSuperview()
            edit_username.removeFromSuperview()
            if media_type == "facebook"{
                id_label.text = self.friendUser.fb_account
            }
        } else if profileMode == DEFAULT_PROFILE_MODE{
            print("now in my own profile")
            if media_type == "facebook"{
                id_label.text = global_fb_account
            }
            
        }
        
        wrong_password_color_ani.fromValue = UIColor.black.cgColor
        wrong_password_color_ani.toValue = UIColor.red.cgColor
        wrong_password_color_ani.duration = 0.5
        wrong_password_color_ani.repeatCount = 1
        wrong_password_color_ani.autoreverses = true
    }
    
    @objc func edit_username_action(){
        id_label.removeFromSuperview()
        id_text_box.frame = id_label.frame
        id_text_box.text = id_label.text
        self.view.addSubview(id_text_box)
        id_text_box.returnKeyType = UIReturnKeyType.done
    }
    
    @objc func save_account_info(){
        if id_text_box.text != ""{
            self.ref.child("users").child(self.uid!).child("fb_account").setValue(id_text_box.text)
            global_fb_account = id_text_box.text!
            id_label.text = id_text_box.text
            id_text_box.removeFromSuperview()
            self.view.addSubview(id_label)
        } else {
            self.id_text_box.text = nil
            self.id_text_box.layer.add(self.wrong_password_color_ani, forKey: "password color ani")
        }
    }
    
    @objc func go_back(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PersonalProfileViewController") as!PersonalProfileViewController
        nextViewController.friendUser = self.friendUser
        nextViewController.profileMode = self.profileMode
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


