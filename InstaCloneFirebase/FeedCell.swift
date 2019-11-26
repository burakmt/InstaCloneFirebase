//
//  FeedCell.swift
//  InstaCloneFirebase
//
//  Created by Bera on 25.11.2019.
//  Copyright © 2019 Bera. All rights reserved.
//

import UIKit
import Firebase
class FeedCell: UITableViewCell {

    @IBOutlet weak var userMail: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var commitLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var documentID : String?
    var likeCount : Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeClicked(_ sender: Any) {
        let firestoreDatabase = Firestore.firestore()
        let likePost = [
            "likes" : self.likeCount! + 1
        ] as [String : Any]
        //Firebase veri güncelleme için collection'dan çekilen tablonun hangi verisini document ile çekiyoruz ve setData fonksiyonunda yeni veri ile beraber merge parametresini true yaparsak sadece güncelleme işlemi yapıyor.
        firestoreDatabase.collection("Posts").document(documentID!).setData(likePost, merge: true)
    }
}
