import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI



class MainPageViewController: UIViewController,UIScrollViewDelegate, UITableViewDelegate,UITableViewDataSource, UISearchResultsUpdating{
    
    
    
    var screen_width:CGFloat = 0
    var screen_height:CGFloat = 0
    var portrait_button = UIImageView()
    var portrait_size:CGFloat = 0
    
    var search_friends_label = UILabel()
    var my_friends_label = UILabel()
    
    let scrollView = UIScrollView()
    let usersTable = UITableView()
    let usersSearch = UISearchController(searchResultsController: nil)
    var pageControl : UIPageControl = UIPageControl(frame:CGRect(x: 50, y: 300, width: 200, height: 50))
    
    let ref = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    let storage_ref = Storage.storage().reference()
    
    var userList = [User]()
    var filteredUserList = [User]()
    
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
                print("set image to default portrait")
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
        //usersSearch.delegate = self
        usersTable.delegate = self
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
        
        usersTable.frame = CGRect(x: 0, y: 0, width: screen_width, height: screen_height)
        self.scrollView.addSubview(usersTable)
        
        usersTable.dataSource = self
        
        
        
        usersSearch.searchResultsUpdater = self
        usersTable.tableHeaderView = usersSearch.searchBar
        usersSearch.hidesNavigationBarDuringPresentation = false
        usersSearch.dimsBackgroundDuringPresentation = false
        
        
    }
    
    func grab_info_from_db(){
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            let cur_user = snapshot.value as! [String:AnyObject]
            //print(user["username"] as! String)
            global_user_name = cur_user["username"] as! String
            global_uid = self.uid!
            global_fb_account = cur_user["fb_account"] as! String
            print("in func")
            print(global_user_name)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        ref.child("users").observe(.childAdded, with: {
            (snapshot) in
            let temp_user = User()
            let dictionary = snapshot.value as! [String:AnyObject]
            print(dictionary)
            
            temp_user.fb_account = dictionary["fb_account"] as! String
            temp_user.username = dictionary["username"] as! String
            temp_user.email = dictionary["email"] as! String
            print("detected")
            self.userList.append(temp_user)
            self.filteredUserList.append(temp_user)
            print(temp_user)
            
            /*self.usersTable.beginUpdates()
            self.usersTable.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            self.usersTable.endUpdates()*/
            DispatchQueue.main.async {
                self.usersTable.reloadData()
            }
        }, withCancel: nil)
        
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == usersTable{
            
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
            let temp_user = filteredUserList[indexPath.row]
            cell.textLabel?.text = temp_user.username
            return cell
        }
        return UITableViewCell()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = usersSearch.searchBar.text, !searchText.isEmpty {
            filteredUserList = userList.filter{
                ($0.username?.lowercased().contains(searchText.lowercased()))!
                
            }
            
            /*filteredNFLTeams = unfilteredNFLTeams.filter { team in
                return team.lowercased().contains(searchText.lowercased())
            }*/
            
        } else {
            filteredUserList = userList
        }
        self.usersTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == usersTable{
            let temp_user = filteredUserList[indexPath.row]
            print(temp_user.username)
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PersonalProfileViewController") as!PersonalProfileViewController
            nextViewController.friendUser = self.filteredUserList[indexPath.row]
            nextViewController.profileMode = 1
            self.present(nextViewController, animated: true, completion: nil)
        }
        /**/
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
