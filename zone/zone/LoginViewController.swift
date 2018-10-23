//
//  LoginViewController.swift
//  zone
//
//  Created by mac on 2018-10-15.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

extension UIImage {
    func imageLeftPadding(left_pad:CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + left_pad,
                   height: self.size.height), false, self.scale)
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: left_pad, y: 0)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
}

class LoginViewController: UIViewController{
    var left_eye_white = UIImageView()
    var left_eye_black = UIImageView()
    var right_eye_white = UIImageView()
    var right_eye_black = UIImageView()
    var screen_width:CGFloat = 0
    var screen_height:CGFloat = 0
    var eye_size:CGFloat = 0
    var distance_between_eyes:CGFloat = 0
    var pupil_size:CGFloat = 0
    var eye_vertical_pos:CGFloat = 0
    var keyboard_height:CGFloat = 0
    
    let temp_dot = UIImageView(image: #imageLiteral(resourceName: "black_dot"))
    var cursor_location = CGPoint()
    
    @IBOutlet var email_field: UITextField!
    @IBOutlet var password_field: UITextField!
    @IBOutlet var registry_button: UIButton!
    @IBOutlet var login_button: UIButton!
    @IBOutlet var zone_icon: UIImageView!
    @IBOutlet var forgot_password_button: UIButton!
    func init_based_on_settings() -> Void{
        left_eye_white.image = #imageLiteral(resourceName: "white_circle")
        right_eye_white.image = #imageLiteral(resourceName: "white_circle")
        left_eye_black.image = #imageLiteral(resourceName: "black_dot")
        right_eye_black.image = #imageLiteral(resourceName: "black_dot")
        eye_size = screen_width*0.1
        distance_between_eyes = screen_width*0.1
        pupil_size = screen_width*0.03
        eye_vertical_pos = screen_height*0.15
        left_eye_black.frame = CGRect(x: screen_width/2-distance_between_eyes/2-eye_size/2-pupil_size/2, y: eye_vertical_pos+eye_size-pupil_size, width: pupil_size, height: pupil_size)
        left_eye_white.frame = CGRect(x: screen_width/2-distance_between_eyes/2-eye_size, y: eye_vertical_pos, width: eye_size, height: eye_size)
        right_eye_black.frame = CGRect(x: screen_width/2+distance_between_eyes/2+eye_size/2-pupil_size/2, y: eye_vertical_pos+eye_size-pupil_size, width: pupil_size, height: pupil_size)
        right_eye_white.frame = CGRect(x: screen_width/2+distance_between_eyes/2, y: eye_vertical_pos, width: eye_size, height: eye_size)
        self.view.addSubview(left_eye_white)
        self.view.addSubview(right_eye_white)
        self.view.addSubview(left_eye_black)
        self.view.addSubview(right_eye_black)
        
        email_field.leftViewMode = UITextFieldViewMode.always
        let user_icon = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        user_icon.image = #imageLiteral(resourceName: "user_icon")
        email_field.leftView = user_icon
        
        password_field.leftViewMode = UITextFieldViewMode.always
        let lock_icon = UIImageView(frame: CGRect(x: 20, y: 0, width: 20, height: 20))
        lock_icon.image = #imageLiteral(resourceName: "lock_icon")
        password_field.leftView = lock_icon
        password_field.isSecureTextEntry = true
        
        frame_loca_without_keyboard()
        
    }
    
    func frame_loca_without_keyboard() {
        //email_label.frame = CGRect(x:screen_width*0.1,y:screen_height*0.25,width:screen_width*0.8,height:40)
        email_field.frame = CGRect(x:screen_width*0.1,y:screen_height*0.32,width:screen_width*0.8,height:40)
        //password_label.frame = CGRect(x:screen_width*0.1,y:screen_height*0.35,width:screen_width*0.8,height:40)
        password_field.frame = CGRect(x:screen_width*0.1,y:screen_height*0.4,width:screen_width*0.8,height:40)
        registry_button.frame = CGRect(x:screen_width*0.1,y:screen_height*0.62,width:screen_width*0.8,height:40)
        login_button.frame = CGRect(x:screen_width*0.1,y:screen_height*0.7,width:screen_width*0.8,height:40)
        forgot_password_button.frame = CGRect(x:screen_width*0.1,y:screen_height*0.74+30,width:screen_width*0.8,height:20)
        zone_icon.frame = CGRect(x:screen_width*0.4,y:screen_height*0.88,width:screen_width*0.2,height:screen_width*0.2)
    }
    
    func frame_loca_with_keyboard() {
        eye_vertical_pos = screen_height*0.1
        left_eye_black.frame = CGRect(x: screen_width/2-distance_between_eyes/2-eye_size/2-pupil_size/2, y: eye_vertical_pos+eye_size-pupil_size, width: pupil_size, height: pupil_size)
        left_eye_white.frame = CGRect(x: screen_width/2-distance_between_eyes/2-eye_size, y: eye_vertical_pos, width: eye_size, height: eye_size)
        right_eye_black.frame = CGRect(x: screen_width/2+distance_between_eyes/2+eye_size/2-pupil_size/2, y: eye_vertical_pos+eye_size-pupil_size, width: pupil_size, height: pupil_size)
        right_eye_white.frame = CGRect(x: screen_width/2+distance_between_eyes/2, y: eye_vertical_pos, width: eye_size, height: eye_size)
        //email_label.frame = CGRect(x:screen_width*0.1,y:(screen_height-keyboard_height)*0.3,width:screen_width*0.8,height:40)
        email_field.frame = CGRect(x:screen_width*0.1,y:(screen_height-keyboard_height)*0.35,width:screen_width*0.8,height:40)
        //password_label.frame = CGRect(x:screen_width*0.1,y:(screen_height-keyboard_height)*0.5,width:screen_width*0.8,height:40)
        password_field.frame = CGRect(x:screen_width*0.1,y:(screen_height-keyboard_height)*0.5,width:screen_width*0.8,height:40)
        registry_button.frame = CGRect(x:screen_width*0.1,y:(screen_height-keyboard_height)*0.65,width:screen_width*0.8,height:40)
        login_button.frame = CGRect(x:screen_width*0.1,y:(screen_height-keyboard_height)*0.8,width:screen_width*0.8,height:40)
        forgot_password_button.frame = CGRect(x:screen_width*0.1,y:(screen_height-keyboard_height)*0.9,width:screen_width*0.8,height:20)
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
        registry_button.layer.cornerRadius = 20
        registry_button.layer.borderWidth = 2
        login_button.layer.cornerRadius = 20
        login_button.layer.borderWidth = 2
        
    }
    
    @IBAction func email_change(_ sender: Any, forEvent event: UIEvent) {
        getCursorLocation()
        change_pupil_location()
    }
    
    func getCursorLocation() -> Void{
        let selectedRange = email_field.selectedTextRange
        //let cursorPosition = email_field.offset(from: email_field.beginningOfDocument, to: (selectedRange?.start)!)
        //cursorPosition gives the word count of the viewbox
        let caretRect = email_field.caretRect(for: (selectedRange?.end)!)
        print("cursor pos in textbox is \(caretRect)")
        cursor_location = CGPoint(x: email_field.frame.origin.x+caretRect.origin.x+20, y: email_field.frame.origin.y+caretRect.origin.y)
    }
    
    func change_pupil_location() -> Void{
        let left_pupil_pos = calculate_pupil_pos(eye_mid:CGPoint(x:left_eye_white.frame.origin.x+eye_size/2,y:left_eye_white.frame.origin.y+eye_size/2),cursor_pos: cursor_location)
        let left_pupil_origin_pos = CGPoint(x: left_pupil_pos.x-pupil_size/2,y: left_pupil_pos.y-pupil_size/2)
        left_eye_black.frame.origin = left_pupil_origin_pos
        let right_pupil_pos = calculate_pupil_pos(eye_mid:CGPoint(x:right_eye_white.frame.origin.x+eye_size/2,y:right_eye_white.frame.origin.y+eye_size/2),cursor_pos: cursor_location)
        let right_pupil_origin_pos = CGPoint(x: right_pupil_pos.x-pupil_size/2,y: right_pupil_pos.y-pupil_size/2)
        right_eye_black.frame.origin = right_pupil_origin_pos
    }
    
    func calculate_pupil_pos(eye_mid:CGPoint,cursor_pos:CGPoint) -> CGPoint{
        let eye_mid_to_pupil_mid = (eye_size - pupil_size)/2
        let x_diff = cursor_pos.x - eye_mid.x
        let y_diff = cursor_pos.y - eye_mid.y
        let x_rad = eye_mid_to_pupil_mid*x_diff/(sqrt(pow(x_diff,2)+pow(y_diff,2)))
        let y_rad = x_rad*y_diff/x_diff
        let pupil_mid = CGPoint(x: eye_mid.x+x_rad, y: eye_mid.y+y_rad)
        return pupil_mid
    }
    
    @IBAction func email_typing_end(_ sender: Any, forEvent event: UIEvent) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: NSNotification.Name.UIKeyboardDidHide,
            object: nil)
    }
    
    @IBAction func email_typing_begin(_ sender: Any) {
        print("email typing begin")
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil)
    }
    
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboard_height = keyboardRectangle.height
            print (keyboard_height)
            print (screen_height - keyboard_height)
            UIView.animate(withDuration: 0.5, animations: {
                self.frame_loca_with_keyboard()
            })
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.5, animations: {
            self.frame_loca_without_keyboard()
            self.getCursorLocation()
            self.change_pupil_location()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

