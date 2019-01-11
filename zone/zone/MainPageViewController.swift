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
    
    //let bgScrollView = UIScrollView()
    let mainScrollView = UIScrollView()
    let usersTable = UITableView()
    let friendsTable = UITableView()
    let usersSearch = UISearchController(searchResultsController: nil)
    var pageControl : UIPageControl = UIPageControl(frame:CGRect(x: 50, y: 300, width: 200, height: 50))
    
    let ref = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    let storage_ref = Storage.storage().reference()
    
    var userList = [User]()
    var filteredUserList = [User]()
    var friendsIDList = [String]()
    var friendsList = [User]()
    
    var friend_icon = UIImageView()
    var search_icon = UIImageView()
    var scroll_bg = UIImageView()
    
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
        
        scroll_bg.image = #imageLiteral(resourceName: "main_bg.jpeg")
        scroll_bg.frame = CGRect(x: screen_width-(screen_height-screen_width)/2, y: 0, width: screen_height, height: screen_height)
        mainScrollView.addSubview(scroll_bg)
        
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
        
//        search_friends_label.text = "friends searching"
//        search_friends_label.frame = CGRect(x: screen_width/2-50, y: screen_height/2, width: 100, height: 20)
//        my_friends_label.text = "my friends"
//        my_friends_label.frame = CGRect(x: screen_width*5/2-50, y: screen_height/2, width: 100, height: 20)
        
        
        mainScrollView.frame = CGRect(x: 0, y: 0, width: screen_width, height: screen_height)
        //bgScrollView.frame = CGRect(x: 0, y: 0, width: screen_width, height: screen_height)
        mainScrollView.delegate = self
        //bgScrollView.delegate = self
        //usersSearch.delegate = self
        usersTable.delegate = self
        friendsTable.delegate = self
        self.mainScrollView.isPagingEnabled = true
        self.mainScrollView.contentSize = CGSize(width: self.mainScrollView.frame.size.width * 3, height: self.mainScrollView.frame.size.height)
        //self.bgScrollView.contentSize = CGSize(width: self.bgScrollView.frame.size.height, height: self.mainScrollView.frame.size.height)
        configurePageControl()
        pageControl.isHidden = true
        print(portrait_button.frame)
        
        self.view.addSubview(mainScrollView)
        //self.view.addSubview(bgScrollView)
        self.mainScrollView.addSubview(portrait_button)
        //self.mainScrollView.addSubview(search_friends_label)
        //self.mainScrollView.addSubview(my_friends_label)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)
        mainScrollView.contentOffset.x = screen_width
        
        grab_info_from_db()
        
        usersTable.frame = CGRect(x: 0, y: 0, width: screen_width, height: screen_height)
        self.mainScrollView.addSubview(usersTable)
        
        usersTable.dataSource = self
        usersTable.backgroundColor = .clear
        
        friendsTable.frame = CGRect(x: 2*screen_width, y: 0, width: screen_width, height: screen_height)
        self.mainScrollView.addSubview(friendsTable)
        friendsTable.dataSource = self
        friendsTable.backgroundColor = .clear
        
        
        usersSearch.searchResultsUpdater = self
        usersTable.tableHeaderView = usersSearch.searchBar
        usersSearch.hidesNavigationBarDuringPresentation = false
        usersSearch.dimsBackgroundDuringPresentation = false
        
        friend_icon.image = #imageLiteral(resourceName: "search_icon.png")
        friend_icon.frame = CGRect(x: 1.8*screen_width, y: 0.2*screen_width, width: 0.1*screen_width, height: 0.1*screen_width)
        mainScrollView.addSubview(friend_icon)
        
        search_icon.image = #imageLiteral(resourceName: "search_icon.png")
        search_icon.frame = CGRect(x: 1.1*screen_width, y: screen_height-0.3*screen_width, width: 0.1*screen_width, height: 0.1*screen_width)
        mainScrollView.addSubview(search_icon)
        
        
        self.mainScrollView.addSubview(friendsTable)
        
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
            //print(dictionary)
            
            temp_user.fb_account = dictionary["fb_account"] as! String
            temp_user.username = dictionary["username"] as! String
            temp_user.email = dictionary["email"] as! String
            temp_user.uid = dictionary["uid"] as! String
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
        
        ref.child("users").child(uid!).child("friendlist").observe(.childAdded, with: {
            (snapshot) in
            print("fetch friends id")
            let single_friend_id = snapshot.key
            print(single_friend_id)
            self.friendsIDList.append(single_friend_id)
            DispatchQueue.main.async {
                print("friends start reloading")
                self.friendsTable.reloadData()
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
        let x = CGFloat(pageControl.currentPage) * mainScrollView.frame.size.width
        mainScrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let percentageScroll = mainScrollView.contentOffset.x/(2*screen_width)
        scroll_bg.frame.origin.x = percentageScroll*(3*screen_width-screen_height)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == usersTable{
            return filteredUserList.count
        }
        else if tableView == friendsTable{
            return friendsIDList.count
        }
        return Int()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == usersTable{
            
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "usercellId")
            let temp_user = filteredUserList[indexPath.row]
            cell.textLabel?.text = temp_user.username
            return cell
        }
        else if tableView == friendsTable{
            //friendsList.removeAll()
//            for _ in friendsIDList{
//                friendsList.append(User())
//                print(friendsList.count)
//            }
            print("finding friends according to friends id")
            print("we have " + String(friendsIDList.count) + " friends id in list")
            for temp_friends_ID in friendsIDList{
                self.friendsList.append(self.userList.filter{
                    ($0.uid?.contains(temp_friends_ID))!
                }[0])
            }
            print("now we have " + String(friendsList.count) + " friends in friends list")
            print("now refreshing row " + String(indexPath.row))
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "friendcellId")
            let temp_friend_added = friendsList[indexPath.row]
            cell.textLabel?.text = temp_friend_added.username
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
            nextViewController.profileMode = FRIEND_PROFILE_MODE
            self.present(nextViewController, animated: true, completion: nil)
        }
        /**/
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
