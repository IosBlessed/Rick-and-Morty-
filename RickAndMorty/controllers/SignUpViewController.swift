//
//  SignUpViewController.swift
//  RickAndMorty
//
//  Created by Никита Данилович on 09.12.2022.
//

import UIKit

class SignUpViewController: MainViewController{

    
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet var requiredFields: [UILabel]!
    
    @IBOutlet weak var loginField: UITextField!
    
    @IBOutlet weak var mailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        self.setBackgroundColor()
        for requireField in requiredFields{
            requireField.isHidden = true
        }
    }
    
    func checkInputFields(textField:UITextField, index:Int){
        guard textField.text != "" else{
                                requiredFields[index].isHidden = false;
                                return;
        }
        requiredFields[index].isHidden = true
        
    }
    var countID:Int = 0
    func checkIfUserNotExists()->Bool{
        var userNotExists:Bool = true
        APIDatabase.shared.getAllUsers(collection: "userAccounts", completion: {
            Users in
            for user in Users!{
                guard user.login.lowercased() != self.loginField.text!.lowercased() else{
                    self.alertMessage(dialogMessageTitle: "Warning!", dialogMessageText: "This login already exists, please, try another one!", okButtonText: "OK", buttonHandler: {_ in })
                    userNotExists = false
                    return
                }
                self.countID = user.id
            }
        })
        return userNotExists
    }
    func accountCreation(){
        APIDatabase.shared.addNewUser(
            collection: "userAccounts",
            docName: "user\(countID+2)",
            login: loginField.text!,
            email:mailField.text!,
            password: passwordField.text!,
            id: countID+1
        )
        self.alertMessage(dialogMessageTitle: "Congratulations!", dialogMessageText: "Your account was created successfully!", okButtonText: "OK", buttonHandler: {
            _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let cvc = storyboard.instantiateViewController(withIdentifier: "ContentVC") as? ContentViewController{
                cvc.userAccount = self.loginField.text!
                self.show(cvc,sender:nil)
                return
            }
        })
    }
    @IBAction func createUser(_ sender: Any) {
        for index in 0..<textFields.count{
            checkInputFields(textField: textFields[index], index: index)
        }
        for data in requiredFields{
            guard data.isHidden == true else{return}
        }
        if(checkIfUserNotExists()){
           accountCreation()
        }
    }
    

}
