import UIKit
import Firebase
import FirebaseAuth

class MainPageViewController: UIViewController,UIScrollViewDelegate {
    var screen_width:CGFloat = 0
    var screen_height:CGFloat = 0
    var portrait_button = UIButton()
    var portrait_size:CGFloat = 0
    
    var search_friends_label = UILabel()
    var my_friends_label = UILabel()
    
    let scrollView = UIScrollView()
    var pageControl : UIPageControl = UIPageControl(frame:CGRect(x: 50, y: 300, width: 200, height: 50))
    
    
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
        portrait_button.setImage(#imageLiteral(resourceName: "default_portrait.jpg"), for: .normal)
        
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
        
        portrait_button.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)
        
    }
    
    @objc func didButtonClick(_ sender: UIButton) {
        if sender === portrait_button {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PersonalProfileViewController") as! PersonalProfileViewController
            self.present(nextViewController, animated: true, completion: nil)
        }
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
