//
//  HeroScreenViewController.swift
//  RickAndMorty
//
//  Created by Никита Данилович on 11.12.2022.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseCore
import SDWebImage

class HeroScreenViewController: MainViewController,UITableViewDataSource, UITableViewDelegate{
    
    var heroes:[HeroStruct] = []
    
    var currentHeroes:[HeroStruct] = []
    
    var currentHero:HeroStruct = HeroStruct(
        img:"gs://rickandmorty-c1a60.appspot.com/images/morty.jpeg",
        name: "Unknown",
        world:"Unknown",
        episode: "Unknown",
        firstSeen: "Unknown",
        lastLocation: "Unknown",
        status: "Unknown"
    )
    
    struct InfoText{
        let lastLocationText: String
        let firstSeenText: String
        let statusText: String
    }
    // Text Fields for type of information
    @IBOutlet weak var currentHeroImage: UIImageView!
    
    @IBOutlet weak var currentHeroName: UILabel!
    
    @IBOutlet weak var firstLineInfoText: UILabel!
    @IBOutlet weak var secondLineInfoText: UILabel!
    @IBOutlet weak var thirdLineInfoText: UILabel!
    
    // Text field for heroe's characteristics
    @IBOutlet weak var selectedHeroName: UILabel!
    
    @IBOutlet weak var firstLineHeroData: UILabel!
    @IBOutlet weak var secondLineHeroData: UILabel!
    @IBOutlet weak var thirdLineHeroData: UILabel!
    
    // Also From Sectionc (TableView + Prototype Cell)
    @IBOutlet weak var alsoFromText: UILabel!
    
    @IBOutlet weak var tableAlsoFrom: UITableView!
    
    let storageRef = Storage.storage()
    override func viewDidLoad(){
        super.viewDidLoad()
        self.setBackgroundColor()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        tableAlsoFrom.backgroundColor = UIColor.systemGray5
        currentHeroImage.layer.cornerRadius = 20
        
        self.addCurrentHeroes()// -> Append to array heroes without hero with information
        
        let info = InfoText(
            lastLocationText: "Last Known Location:",
            firstSeenText: "First Seen in:",
            statusText: "Status:"
        )
        // Initializing type of information
        firstLineInfoText.text = info.lastLocationText
        secondLineInfoText.text = info.firstSeenText
        thirdLineInfoText.text = info.statusText
        
        //HeroesData
        currentHeroName.text = currentHero.name
        let currentHeroImageRef = storageRef.reference(forURL: currentHero.img)
        currentHeroImage.sd_setImage(with:currentHeroImageRef)
        firstLineHeroData.text = currentHero.lastLocation
        secondLineHeroData.text = currentHero.firstSeen
        thirdLineHeroData.text = currentHero.status
        
        // Also From block + table
        alsoFromText.text = "Also From \"\(currentHero.world)\""
        tableAlsoFrom.delegate = self
        tableAlsoFrom.dataSource = self
    }
    func addCurrentHeroes(){
        for hero in heroes{
            if(hero.world == currentHero.world && hero.name != currentHero.name){
                currentHeroes.append(hero)
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentHeroes.count
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
        let hero = currentHeroes[indexPath.row]
        let cell = tableAlsoFrom.dequeueReusableCell(withIdentifier: "rickcell", for: indexPath) as! RAMTableViewCell
        let heroImageRef = storageRef.reference(forURL: hero.img)
        cell.heroImage.sd_setImage(with: heroImageRef)
        cell.heroName.text = hero.name
        cell.heroWorld.text = hero.world
        cell.heroEpisode.text = hero.episode
        return cell
   }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hero = currentHeroes[indexPath.row]
        let heroImageRef = storageRef.reference(forURL: hero.img)
        currentHeroImage.sd_setImage(with: heroImageRef)
        currentHeroName.text = hero.name
        firstLineHeroData.text = hero.lastLocation
        secondLineHeroData.text = hero.firstSeen
        thirdLineHeroData.text = hero.status
        let switchedHero = self.currentHero
        currentHero = currentHeroes[indexPath.row]
        currentHeroes[indexPath.row] = switchedHero
        self.tableAlsoFrom.reloadData()
        
    }
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 125
   }
 

}
