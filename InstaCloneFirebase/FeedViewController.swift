//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by Bera on 22.11.2019.
//  Copyright © 2019 Bera. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userEmail = [String]()
    var userCommit = [String]()
    var likeArray = [Int]()
    var userImage = [String]()
    var documentIDArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
    }
    
    func getDataFromFirestore(){
        //Verilerimizi çekmek için bir firestore instance'ı alıyoruz.
        let firestoreDatabase = Firestore.firestore()
        // collection hangi tablodan veri çekeceğimizi
        // order verileri çekerken herhangi bir sıralama yapıyorsak kullanılıyor.
        // addSnapshotListener ise anlık olarak herhangi bir veritabanı güncellenmesi, eklenmesi olduğunda otomatik yenileme sağlıyor.
        firestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snap, err) in
            if err != nil{
                self.makeAlert(titleInput: "Error", messageInput: err?.localizedDescription ?? "Error")
            }
            else{
                //Veritabanında ki kayıtlarda herhangi bir güncelleme veya eklenme yapıldı mı diye sorguluyoruz.
                if snap?.isEmpty != true {
                    self.userImage.removeAll(keepingCapacity: false)
                    self.userCommit.removeAll(keepingCapacity: false)
                    self.userEmail.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIDArray.removeAll(keepingCapacity: false)
                    
                    //Verilerimizi çekiyoruz.
                    for document in snap!.documents {
                        let documentID = document.documentID
                        self.documentIDArray.append(documentID)
                        if let postedByData = document.get("postedBy") as? String{
                            self.userEmail.append(postedByData)
                            if let postedComment = document.get("postComment") as? String{
                                self.userCommit.append(postedComment)
                                if let postedLike = document.get("likes") as? Int{
                                    self.likeArray.append(postedLike)
                                    if let postedImage = document.get("imageUrl") as? String{
                                        self.userImage.append(postedImage)
                                        
                                    }
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    func makeAlert(titleInput: String, messageInput : String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Main.storyboard'da elle oluşturduğumuz bir cell template'ine ulaşmak ve ona bağlı olan touchClass'ı çekmek için dequeue fonksiyonunu kullanıyoruz.
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! FeedCell
        //Veri tabanından çektiğimiz resimleri daha rahat göstermek için (URL çektiğimizden dolayı) SDWebImage adlı kütüphaneyi kullanıyoruz.
        cell.userImageView.sd_setImage(with: URL(string: self.userImage[indexPath.row]))
        cell.userMail.text = userEmail[indexPath.row]
        cell.dateLabel.text = "25-11-2019"
        cell.commitLabel.text = userCommit[indexPath.row]
        cell.likeButton.setTitle("Like : \(likeArray[indexPath.row])", for: .normal)
        cell.likeCount = likeArray[indexPath.row]
        cell.documentID = documentIDArray[indexPath.row]
        return cell
    }
    
}
