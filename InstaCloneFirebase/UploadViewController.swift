//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by Bera on 22.11.2019.
//  Copyright © 2019 Bera. All rights reserved.
//

import UIKit
import Firebase
class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commitText: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        let gestureHandler = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureHandler)
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(getPicker))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    @objc func getPicker(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    @IBAction func saveClicked(_ sender: Any) {
        //Firebase'e dosya aktarımı için bir Storage instance'ı alıyoruz.
        let storage = Storage.storage()
        //Aldığımız instance'dan da bir reference oluşturuyoruz.
        let storageRef = storage.reference()
        //Dosyayı yükleyeceğimiz klasör'ü belirtiyoruz. Klasör yoksa otomatik oluşuturuyor
        let mediaFolder = storageRef.child("media")
        //Yüklemek istediğimiz resmin jpegData'sını alıyoruz.
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            //Dosyaya bir ad tanımlıyoruz.
            let imageReference = mediaFolder.child("\(uuid).jpg")
            //Dosyayı storage'imize göndermek için putData fonksiyonunu çağırıyoruz.
            imageReference.putData(data, metadata: nil) { (metaData, err) in
                if err != nil{
                    self.makeAlert(titleInput: "Error", messageInput: err?.localizedDescription ?? "Error")
                }
                else{
                    //Yükleme işlemi gerçekleştiği takdirde istersek yüklemiş olduğumuz resmin URL uzantısını alabiliyoruz.
                    imageReference.downloadURL { (url, err) in
                        if err == nil{
                            //Resmin, Dosyanın URL uzantısını string tipine çeviriyoruz.
                            let imageUrl = url?.absoluteString
                            
                            //FireStore instance'ımızı alıyoruz.
                            let firestoreDatabase = Firestore.firestore()
                            //DocumentReference'ımızı alıyoruz.
                            var firestoreReference : DocumentReference?
                            
                            //Key-Value mantığında kayıt yapıldığından dolayı bir String-Any dizisi oluşturuyoruz.
                            let firestorePost = [
                                "imageUrl" : imageUrl!,
                                "postedBy" : Auth.auth().currentUser!.email!,
                                "postComment" : self.commitText.text!,
                                "date" : FieldValue.serverTimestamp(),
                                "likes" : 0
                                ] as [String : Any]
                            
                            // 1) collection : Tablo adı
                            // 2) addDocument : ekleme fonksiyonu
                            // 3) data : eklenecek veri
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil{
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                }
                                else{
                                    self.imageView.image = UIImage(named: "SelectImage")
                                    self.commitText.text = ""
                                    self.saveButton.isEnabled = false
                                    self.makeAlert(titleInput: "Successfully", messageInput: "Upload Successfully!")
                                    //TabBarController ile sayfalar arası geçişte sayfaların index'lerine göre geçiş sağlıyoruz.
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                            
                            
                        }
                    }
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        saveButton.isEnabled = true
        
        self.dismiss(animated: true, completion: nil)
    }
}
