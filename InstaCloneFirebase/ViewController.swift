//
//  ViewController.swift
//  InstaCloneFirebase
//
//  Created by Bera on 22.11.2019.
//  Copyright © 2019 Bera. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func signInClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != ""{
            //Firebase üzerinden kullanıcı kontrol işlemlerini 'Auth' sınıfından yapıyoruz.
            //Giriş sorgusunu signIn fonksiyonu ile yapıyoruz.
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (result, err) in
                if err != nil{
                    self.makeAlert(titleInput: "Error", messageInput: err?.localizedDescription ?? "Error")
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
        else{
            makeAlert(titleInput: "Error", messageInput: "Username/Password?")
        }
       
    }
    @IBAction func signUpClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != ""{
            //Kullanıcı oluşturmak için createUser fonksiyonunu kullanıyoruz.
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (result, err) in
                if err != nil{
                    self.makeAlert(titleInput: "Error", messageInput: err?.localizedDescription ?? "Error")
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
        else{
            makeAlert(titleInput: "Error", messageInput: "Username/Password?")
        }
    }
    
    func makeAlert(titleInput: String, messageInput : String){

        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

