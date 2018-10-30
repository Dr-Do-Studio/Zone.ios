//
//  LoginViewController.swift
//  zone
//
//  Created by mac on 2018-10-15.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

public extension UIView {
    func fadeIn(withDuration duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeInWithDisplacement(withDuration duration: TimeInterval = 0.5){
        self.frame.origin.y += 40
        UIView.animate(withDuration: duration, animations: {
            self.frame.origin.y -= 40
            self.alpha = 1.0
        })
    }
    
    func fadeOut(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
}

class PersonalPageViewController: UIViewController{
    
    var portrait_image = UIImage()
    var portrait_size:CGFloat = 0
    var screen_width:CGFloat = 0
    var screen_height:CGFloat = 0
    
    @IBOutlet var portrait_button: UIButton!
    
    
    @IBAction func swipe_left_to_friends_list(_ sender: Any) {
        print("swipe left")
    }
    
    @IBAction func swipe_right_to_search_list(_ sender: Any) {
        print("swipe right")
    }
    
    override func viewDidLoad() {
        screen_width = view.frame.width
        screen_height = view.frame.height
        
        portrait_image = #imageLiteral(resourceName: "default_portrait.jpg")
        portrait_size = 0.4 * screen_width
        
        portrait_button.frame = CGRect(x: screen_width/2-portrait_size/2, y: screen_height/2-portrait_size/2, width: portrait_size, height: portrait_size)
        portrait_button.layer.cornerRadius = 0.5 * portrait_button.bounds.size.width
        portrait_button.clipsToBounds = true
        portrait_button.contentMode = .scaleToFill
        
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        print(user?.email)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


