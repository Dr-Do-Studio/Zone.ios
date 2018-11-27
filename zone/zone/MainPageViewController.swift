import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI



class MainPageViewController: UIViewController,UIScrollViewDelegate {
    var screen_width:CGFloat = 0
    var screen_height:CGFloat = 0
    var portrait_button = UIImageView()
    var portrait_size:CGFloat = 0
    
    var search_friends_label = UILabel()
    var my_friends_label = UILabel()
    
    let scrollView = UIScrollView()
    var pageControl : UIPageControl = UIPageControl(frame:CGRect(x: 50, y: 300, width: 200, height: 50))
    
    let ref = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    let storage_ref = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("current user is " + (Auth.auth().currentUser?.email)!)
        screen_width = view.frame.width
        screen_height = view.frame.height
        print("screen width is \(screen_width)")
        print("screen height is \(screen_height)")
        
        portrait_size = 0.4 * screen_width
        portrait_button.frame = CGRect(x: screen_width*3/2-portrait_size/2, y: screen_height/2-portrait_size/2, width: portrait_size, height: portrait_size)
        
        portrait_button.layer.cornerRadius = 0.5 * portrait_button.bounds.size.width
        portrait_button.clipsToBounds = true
        portrait_button.contentMode = .scaleToFill
        portrait_button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToPersonalProfile)))
        portrait_button.isUserInteractionEnabled = true
        
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
                self.portrait_button.sd_setImage(with: imageURL, placeholderImage: global_portrait)
                global_portrait = self.portrait_button.image
                print(global_portrait)
            }
        })
        
        search_friends_label.text = "friends searching"
        search_friends_label.frame = CGRect(x: screen_width/2-50, y: screen_height/2, width: 100, height: 20)
        my_friends_label.text = "my friends"
        my_friends_label.frame = CGRect(x: screen_width*5/2-50, y: screen_height/2, width: 100, height: 20)
        
        
        scrollView.frame = CGRect(x: 0, y: 0, width: screen_width, height: screen_height)
        scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * 3, height: self.scrollView.frame.size.height)
        configurePageControl()
        pageControl.isHidden = true
        print(portrait_button.frame)
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(portrait_button)
        self.scrollView.addSubview(search_friends_label)
        self.scrollView.addSubview(my_friends_label)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)
        scrollView.contentOffset.x = screen_width
        
        grab_info_from_db()
        
    }
    
    func grab_info_from_db(){
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            let user = snapshot.value as! [String:AnyObject]
            //print(user["username"] as! String)
            global_user_name = user["username"] as! String
            global_uid = self.uid!
            print("in func")
            print(global_user_name)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @objc func goToPersonalProfile(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PersonalProfileViewController") as!PersonalProfileViewController
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    func configurePageControl() {
        self.pageControl.numberOfPages = 2
        self.pageControl.currentPage = 1
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
        self.view.addSubview(pageControl)
        
    }
    
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
