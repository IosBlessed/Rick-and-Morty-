//
//  AdminViewController.swift
//  RickAndMorty
//
//  Created by Никита Данилович on 14.12.2022.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseStorageUI
import FirebaseDatabase

class AddHeroViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet var heroInformation: [UITextField]!
    
    @IBOutlet var requiredHeroInfo: [UILabel]!
    
    @IBOutlet weak var uploadImage: RoundButton!
    
    @IBOutlet weak var heroName: UITextField!
    
    let storageRef = Storage.storage().reference()
    var heroCanBeAdded:Bool = false
    var heroesArray:[HeroStruct] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        APIDatabase.shared.getAllHeroes(collection: "heroesData", completion: {
            heroes in
            self.heroesArray = heroes!
        })
        for requiredField in requiredHeroInfo{
            requiredField.isHidden = true
        }
    }
    func showRequiredFields(textField:UITextField, index:Int){
        guard textField.text != "" else{
            requiredHeroInfo[index].isHidden = false
            heroCanBeAdded = false
            return
        }
        requiredHeroInfo[index].isHidden = true
    }
   
  
    @IBAction func uploadImageButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    var userImage:UIImage!
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        self.userImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        uploadImage.setBackgroundImage(self.userImage!, for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    @IBAction func addHeroButton(_ sender: Any) {
        heroCanBeAdded = true
        for index in 0..<heroInformation.count{
            showRequiredFields(textField: heroInformation[index], index: index)
        }
        guard heroCanBeAdded else{
            print("Please, fill in required fields!");
            return
        }
        let heroImgPath = "images/\(heroName.text!.lowercased().replacingOccurrences(of: " ", with: "")).png"
            guard let imagePng = self.userImage?.pngData() else{
                print("No such PNG data");
                return}
        storageRef.child(heroImgPath).putData(imagePng, completion: {
                _,error in
                guard error == nil else{
                    print("Failed to upload");
                    return
                }
                self.storageRef.child(heroImgPath).downloadURL(completion: {
                    URL, error in
                    guard error == nil else{
                        print("Unable to reach URL parameters!");
                        return
                    }
                    
                     APIDatabase.shared.addNewHero(
                        collection: "heroesData",
                        docName: "hero\(self.heroesArray.count+1)",
                        img: URL!.absoluteString,
                        name: self.heroInformation[0].text!,
                        world: self.heroInformation[1].text!,
                        episode: self.heroInformation[2].text!,
                        lastLocation: self.heroInformation[3].text!,
                        firstSeen: self.heroInformation[4].text!,
                        status: self.heroInformation[5].text!)
                })
            self.alertMessage(dialogMessageTitle: "Congratulations!", dialogMessageText: "Hero was added successfully.", okButtonText: "OK", buttonHandler: {
                _ in 
            })
            })
        
        
    }

    
}
