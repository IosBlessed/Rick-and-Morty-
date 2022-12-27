//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Никита Данилович on 08.12.2022.
//
import Foundation
import UIKit
import Firebase

class ViewController: MainViewController{
    
    @IBOutlet weak var loginField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet var requiredFields: [UILabel]!

    var slideFromAnotherScreen:Bool = false
    override func viewDidLoad() {
        self.setBackgroundColor()
        mainScreenView()
        if(slideFromAnotherScreen == true){
            self.navigationItem.hidesBackButton = true
        }
        for requirments in requiredFields{
            requirments.isHidden = true
        }
    }
    func checkInputFields(textField:UITextField, index:Int){
        guard textField.text != "" else{
                                requiredFields[index].isHidden = false;
                                return
        }
        requiredFields[index].isHidden = true
    }
    func mainScreenView(){
       // mainScreen.layer.backgroundColor = UIColor.systemGray5.cgColor
    }
    func loginIntoAccount(){
        APIDatabase.shared.getAllUsers(collection: "userAccounts", completion: {
            users in
            for user in users!{
                if(user.login == self.loginField.text){
                    if(user.password == self.passwordField.text){
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let cvc = storyboard.instantiateViewController(withIdentifier: "ContentVC") as? ContentViewController{
                            cvc.userAccount = self.loginField.text!
                            self.show(cvc,sender:nil)
                            return
                        }
                    }else{
                        self.alertMessage(dialogMessageTitle: "Wrong Password", dialogMessageText: "Please, try to sign in once again", okButtonText: "OK", buttonHandler:{ _ in
                            self.loginField.text = ""
                            self.passwordField.text = ""
                        })
                        print("Incorrect password")
                        return
                    }
                }
            }
            self.loginField.text = ""
            self.passwordField.text = ""
            self.alertMessage(dialogMessageTitle: "Wrong login", dialogMessageText: "Account you tried to enter doesn't exist!", okButtonText: "OK", buttonHandler: {_ in })
        })
    }
    @IBAction func loginButton(_ sender: Any) {
        for index in 0..<textFields.count{
            checkInputFields(textField:textFields[index],index:index)
        }
        for requiredField in requiredFields{
            guard requiredField.isHidden == true else{return}
        }
        loginIntoAccount()
    }
  
  
}

