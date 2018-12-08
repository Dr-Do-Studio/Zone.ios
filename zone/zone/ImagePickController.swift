
import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI

extension PersonalProfileViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @objc func handleSelectProfileImageView(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker,animated: true,completion:nil)
        
    }
                      
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImage:UIImage?
        print("picker")
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImage = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = originalImage
        }
        self.portrait_button.image = selectedImage
        if let uploadImage = UIImagePNGRepresentation(selectedImage!){
            storage_ref.child(global_uid+"/ProfileImage.png").putData(uploadImage, metadata: nil, completion: {
                (metadata, error) in
                if (error != nil){
                    print(error)
                    return
                }
                print("show me metadata")
                
                print(metadata)
            })
        }
        
        //let user = ref.child("users").child(uid!).setValue(["profileImageUrl":metadata.downloadUrl])
        
        
        
        
        
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("picker cancelled")
        dismiss(animated: true, completion: nil)
    }
}
