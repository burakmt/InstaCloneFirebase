//
//  SettingsViewController.swift
//  InstaCloneFirebase
//
//  Created by Bera on 22.11.2019.
//  Copyright © 2019 Bera. All rights reserved.
//

import UIKit
import Firebase
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func logoutClicked(_ sender: Any) {
        do{
            //Firebase auth çıkışı yapmak için signOut fonksiyonunu kullanıyoruz. Hata fırlatabileceğinden dolayı try-catch içine alıyoruz.
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
        }
        catch{
            print("Error")
        }
    }
}
