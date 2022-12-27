//
//  APIDatabase.swift
//  RickAndMorty
//
//  Created by Никита Данилович on 08.12.2022.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore
import FirebaseCoreInternal


class APIDatabase{
    static let shared = APIDatabase()
    
    private func configureFB()->Firestore{
        var db:Firestore!
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
        
    }
    func getAllUsers(collection:String,completion: @escaping ([UsersModel]?)->Void){
        let db = configureFB()
        var users:[UsersModel] = []
        db.collection(collection).getDocuments(){
            (QuerySnapshot, error) in
            guard error == nil else{
                                print(error!);
                                completion([]);
                                return
            }
                for document in QuerySnapshot!.documents{
                    users.append(UsersModel(
                        id: document.data()["ID"] as! Int,
                        login: document.data()["login"] as! String,
                        password: document.data()["password"] as! String,
                        email: document.data()["email"] as! String
                        
                    ))
                }
                completion(users)
            }
        }
    func addNewUser(collection:String, docName:String,login:String, email:String, password:String, id:Int){
        let db = configureFB()
        db.collection(collection).document(docName).setData([
            "ID":id,
            "login":login,
            "password":password,
            "email":email
        ]){
            error in
            guard error == nil else{
                                print("Database Error => \(error!)");
                                return
            }
            print("User created Successfully!")
        }
    }
    func addNewHero(collection:String, docName:String,img:String?,name:String?,world:String?,episode:String?,lastLocation:String?,firstSeen:String?,status:String?){
        let db = configureFB()
        db.collection(collection).document(docName).setData([
            "img":img ?? "gs://rickandmorty-c1a60.appspot.com/images/artricia.jpg",
            "name":name ?? "Unknown",
            "world":world ?? "Unknown",
            "episode":episode ?? "Unknown",
            "lastLocation":lastLocation ?? "Unknown",
            "firstSeen":firstSeen ?? "Unknown",
            "status":status ?? "Unknown"
        ]){
            error in
            guard error == nil else{
                                print("Database Error => \(error!)");
                                return
            }
            print("Hero added Successfully!")
        }
    }
    func getAllHeroes(collection:String, completion:@escaping([HeroStruct]?)->Void){
        let db = configureFB()
        var heroes:[HeroStruct] = []
        db.collection(collection).getDocuments(){
            (QuerySnapshot, error) in
            guard error == nil else{
                            print("Data extraction error -> \(error!)")
                            completion([])
                            return
            }
            for hero in QuerySnapshot!.documents{
                heroes.append(
                HeroStruct(
                    img: hero.data()["img"] as! String,
                    name: hero.data()["name"] as! String,
                    world: hero.data()["world"] as! String,
                    episode: hero.data()["episode"] as! String,
                    firstSeen: hero.data()["firstSeen"] as! String,
                    lastLocation: hero.data()["lastLocation"] as! String,
                    status: hero.data()["status"] as! String)
                )
            }
            print("Heroes were extracted correct!")
            completion(heroes)
        }
        
    }
    func getSpecificDocument(collection:String, docName:String, completion:@escaping(DocumentSnapshot?)->Void){
        let db = configureFB()
        db.collection(collection).document(docName).getDocument(){
            (DocumentSnapshot, error) in
            guard error == nil else{
                                print(error!);
                                completion(nil);
                                return
            }
            completion(DocumentSnapshot!)
        }
    }
}
