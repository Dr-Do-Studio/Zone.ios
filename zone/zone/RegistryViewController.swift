//
//  LoginViewController.swift
//  zone
//
//  Created by mac on 2018-10-15.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class RegistryViewController: UIViewController{
    var left_eye_white = UIImageView()
    var left_eye_heart = UIImageView()
    var right_eye_white = UIImageView()
    var right_eye_heart = UIImageView()
    var screen_width:CGFloat = 0
    var screen_height:CGFloat = 0
    var eye_size:CGFloat = 0
    var distance_between_eyes:CGFloat = 0
    var pupil_size:CGFloat = 0
    var eye_vertical_pos:CGFloat = 0
    
    let temp_dot = UIImageView(image: #imageLiteral(resourceName: "black_dot"))
    var cursor_location = CGPoint()
    
    @IBOutlet var email_field: UITextField!
    @IBOutlet var username_field: UITextField!
    @IBOutlet var password_field: UITextField!
    @IBOutlet var create_account_button: UIButton!
    @IBOutlet var zone_icon: UIImageView!
    
    @IBOutlet var have_account_label: UILabel!
    @IBOutlet var have_account_button: UIButton!
    
    func init_based_on_settings() -> Void{
        left_eye_white.image = #imageLiteral(resourceName: "white_circle")
        right_eye_white.image = #imageLiteral(resourceName: "white_circle")
        left_eye_heart.image = #imageLiteral(resourceName: "heart_icon")
        right_eye_heart.image = #imageLiteral(resourceName: "heart_icon")
        eye_size = screen_width*0.1
        distance_between_eyes = screen_width*0.1
        pupil_size = screen_width*0.07
        eye_vertical_pos = screen_height*0.15
        left_eye_heart.frame = CGRect(x: screen_width/2-distance_between_eyes/2-eye_size/2-pupil_size/2, y: eye_vertical_pos+eye_size-pupil_size, width: pupil_size, height: pupil_size)
        left_eye_white.frame = CGRect(x: screen_width/2-distance_between_eyes/2-eye_size, y: eye_vertical_pos, width: eye_size, height: eye_size)
        right_eye_heart.frame = CGRect(x: screen_width/2+distance_between_eyes/2+eye_size/2-pupil_size/2, y: eye_vertical_pos+eye_size-pupil_size, width: pupil_size, height: pupil_size)
        right_eye_white.frame = CGRect(x: screen_width/2+distance_between_eyes/2, y: eye_vertical_pos, width: eye_size, height: eye_size)
        self.view.addSubview(left_eye_white)
        self.view.addSubview(right_eye_white)
        self.view.addSubview(left_eye_heart)
        self.view.addSubview(right_eye_heart)
        username_field.leftViewMode = UITextFieldViewMode.always
        let user_icon = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        user_icon.image = #imageLiteral(resourceName: "user_icon")
        username_field.leftView = user_icon
        
        password_field.leftViewMode = UITextFieldViewMode.always
        let lock_icon = UIImageView(frame: CGRect(x: 20, y: 0, width: 20, height: 20))
        lock_icon.image = #imageLiteral(resourceName: "lock_icon")
        
        password_field.leftView = lock_icon
        password_field.isSecureTextEntry = true
        frame_loca_without_keyboard()
    }
    
    func frame_loca_without_keyboard() {
        email_field.frame = CGRect(x:screen_width*0.1,y:screen_height*0.3,width:screen_width*0.8,height:40)
        username_field.frame = CGRect(x:screen_width*0.1,y:screen_height*0.4,width:screen_width*0.8,height:40)
        password_field.frame = CGRect(x:screen_width*0.1,y:screen_height*0.5,width:screen_width*0.8,height:40)
        create_account_button.frame = CGRect(x:screen_width*0.1,y:screen_height*0.7,width:screen_width*0.8,height:40)
        have_account_label.frame.origin = CGPoint(x:create_account_button.frame.origin.x+30,y:create_account_button.frame.origin.y + create_account_button.frame.size.height)
        have_account_button.frame.origin = CGPoint(x:have_account_label.frame.origin.x + 160,y:have_account_label.frame.origin.y)
        have_account_button.frame.size.height = have_account_label.frame.size.height
        //forgot_password_button.frame = CGRect(x:screen_width*0.1,y:screen_height*0.74+30,width:screen_width*0.8,height:20)
        zone_icon.frame = CGRect(x:screen_width*0.4,y:screen_height*0.88,width:screen_width*0.2,height:screen_width*0.2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screen_width = view.frame.width
        screen_height = view.frame.height
        print("screen width is \(screen_width)")
        print("screen height is \(screen_height)")
        init_based_on_settings()
        
        email_field.layer.cornerRadius = 20
        email_field.layer.borderWidth = 2
        password_field.layer.cornerRadius = 20
        password_field.layer.borderWidth = 2
        username_field.layer.cornerRadius = 20
        username_field.layer.borderWidth = 2
        create_account_button.layer.cornerRadius = 20
        create_account_button.layer.borderWidth = 2
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


