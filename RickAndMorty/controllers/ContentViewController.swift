//
//  ContentViewController.swift
//  RickAndMorty
//
//  Created by Никита Данилович on 10.12.2022.
//
import Foundation
import UIKit
import FirebaseStorage
import Firebase
import SDWebImage
import FirebaseDatabase
import FirebaseStorageUI

class ContentViewController: MainViewController,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate{
    
    var userAccount:String = ""
    @IBOutlet weak var table: UITableView!
    var heroes:[HeroStruct] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidLoad() {
        APIDatabase.shared.getAllHeroes(collection: "heroesData", completion: {
            HeroDB in
            for hero in HeroDB!{
                self.heroes.append(hero)    
            }
            self.table.reloadData()
        })
        super.viewDidLoad()
        
        self.setBackgroundColor()
        
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = UIColor.systemGray5
        
    }
   
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return heroes.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: 10)
        
        cell.layer.mask = maskLayer
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell {
         let hero = heroes[indexPath.row]
         let cell = table.dequeueReusableCell(withIdentifier: "rickcell", for: indexPath) as! RAMTableViewCell
         let imgRef = Storage.storage().reference(forURL: hero.img)
         cell.heroImage.sd_setImage(with: imgRef)
            cell.heroName.text = hero.name
            cell.heroWorld.text = hero.world
            cell.heroEpisode.text = hero.episode
         return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let hsvc = storyboard.instantiateViewController(withIdentifier: "heroScreen") as? HeroScreenViewController{
            hsvc.currentHero = heroes[indexPath.row]
            
            hsvc.heroes = heroes
            self.show(hsvc,sender:nil)
        }
    }
   
    @IBAction func userAccount(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let uavc = storyboard.instantiateViewController(withIdentifier: "userAccount") as? UserAccountViewController{
            uavc.welcome = "Hi, dear \(userAccount)!"
            uavc.userAccount = userAccount
            self.show(uavc, sender: nil)
        }
    }
    
}
