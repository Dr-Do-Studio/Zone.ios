import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI


class PersonalProfileViewController: UIViewController,UIScrollViewDelegate{
    var screen_width:CGFloat = 0
    var screen_height:CGFloat = 0
    let ref = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    
    var portrait_button = UIImageView()
    var portrait_size:CGFloat = 0
    
    var back_to_menu_button = UIButton()
    var settings_button = UIButton()
    var edit_button = UIButton()
    var name_tag = UILabel()
    

    @IBOutlet var scroll: UIScrollView!
    
    let storage_ref = Storage.storage().reference()
    
    let temp_but = UIButton()
    override func viewDidLoad() {
        screen_width = view.frame.width
        screen_height = view.frame.height
        let user = ref.child("users").child(uid!)
        super.viewDidLoad()
        
        scroll.frame = CGRect(x: 0, y: 0, width: screen_width, height: screen_height)
        scroll.delegate = self
        self.scroll.contentSize = CGSize(width: self.scroll.frame.size.width, height: self.scroll.frame.size.height*2)
        
        portrait_size = 0.4 * screen_width
        portrait_button.frame = CGRect(x: screen_width/2-portrait_size/2, y: screen_height/5-portrait_size/2, width: portrait_size, height: portrait_size)
        
        portrait_button.layer.cornerRadius = 0.5 * portrait_button.bounds.size.width
        portrait_button.clipsToBounds = true
        portrait_button.contentMode = .scaleToFill
        
        
        let imageURL = storage_ref.child(uid!).child("ProfileImage.png")
        print(imageURL)
        imageURL.downloadURL(completion: { (url, error) in
            
            if error != nil {
                print("haha")
                print(error?.localizedDescription)
                self.portrait_button.image = #imageLiteral(resourceName: "default_portrait.jpg")
                return
            }
            
            //Now you can start downloading the image or any file from the storage using URLSession.
            else{
                
                let placeholderImage = UIImage(named: "placeholder.jpg")
                
                self.portrait_button.sd_setImage(with: imageURL, placeholderImage: placeholderImage)
                
                
                
            }
            
        })
        
        self.scroll.addSubview(portrait_button)
        
        
        back_to_menu_button.frame = CGRect(x: screen_width/10, y: screen_width/10, width: screen_width/10, height: screen_width/10)
        back_to_menu_button.backgroundColor = .black
        self.scroll.addSubview(back_to_menu_button)
        back_to_menu_button.addTarget(self, action: #selector(returnToMain), for: .touchUpInside)
        
        settings_button.frame = CGRect(x: screen_width*8/10, y: screen_width/10, width: screen_width/10, height: screen_width/10)
        settings_button.backgroundColor = .black
        self.scroll.addSubview(settings_button)
        settings_button.addTarget(self, action: #selector(setting), for: .touchUpInside)
        
        edit_button.frame = CGRect(x: screen_width*8/10, y: screen_width/2, width: screen_width/10, height: screen_width/10)
        edit_button.backgroundColor = .black
        self.scroll.addSubview(edit_button)
        
        name_tag.text = global_user_name
        
        name_tag.frame = CGRect(x: screen_width/2-portrait_size/2, y: portrait_button.frame.origin.y + portrait_button.frame.size.height + 30, width: portrait_size, height: 20)
        name_tag.textAlignment = .center
        self.scroll.addSubview(name_tag)
        
        
    }
    
   
    
    
    @objc func returnToMain(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainPageViewController") as! MainPageViewController
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    @objc func setting(){
        print(global_user_name)
    }
    
    func scrollViewDidScroll(_ scroll: UIScrollView) {
        if(scroll.contentOffset.y > screen_width/20){
            back_to_menu_button.frame = CGRect(x: screen_width/10, y: screen_width/20 + scroll.contentOffset.y, width: screen_width/10, height: screen_width/10)
            settings_button.frame = CGRect(x: screen_width*8/10, y: screen_width/20 + scroll.contentOffset.y, width: screen_width/10, height: screen_width/10)
            
        }
        if(scroll.contentOffset.y > screen_width/10){
            portrait_button.frame = CGRect(x: screen_width/2-portrait_size/2, y: screen_height/5-portrait_size/2-screen_width/10 + scroll.contentOffset.y, width: portrait_size, height: portrait_size)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
