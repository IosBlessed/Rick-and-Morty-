//
//  UserAccountViewController.swift
//  RickAndMorty
//
//  Created by Никита Данилович on 15.12.2022.
//

import UIKit
import Foundation

class UserAccountViewController: MainViewController {

   
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var addHeroOutlet: RoundButton!
    var userAccount:String = ""
    var welcome:String = "Welcome back!"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundColor()
        welcomeTextStyle()
        checkIfAdmin()
    }
    func checkIfAdmin(){
        guard userAccount == "admin" else{
            addHeroOutlet.isHidden = true
            return
        }
        addHeroOutlet.isHidden = false
    }
    func welcomeTextStyle(){
        welcomeText.text = welcome
        welcomeText.textAlignment = .center
    }
  
    @IBAction func addHeroButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let ahvc = storyboard.instantiateViewController(withIdentifier: "addHeroVC") as? AddHeroViewController{
            show(ahvc,sender:nil)
        }
    }
    

    @IBAction func signOutButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "mainVC") as? ViewController{
            vc.navigationItem.hidesBackButton = true
            show(vc,sender:nil)
        }
    }
    
}
