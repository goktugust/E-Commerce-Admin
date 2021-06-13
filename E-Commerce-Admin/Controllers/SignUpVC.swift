//
//  AdminAuthVC.swift
//  E-Commerce-Admin
//
//  Created by Göktuğ Üstüner on 9.06.2021.
//

import UIKit
import Firebase


class SignUpVC: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func btnPressed(_ sender: UIButton) {
        signUp()
    }
    
    
    
    
    
    
    
    
    
    func signUp(){
        if let email = emailText.text, let password = passwordText.text, let name = nameText.text{
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let e = error {
                    let alert = UIAlertController(title: "Error!", message: "\(e.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    print(e.localizedDescription)
                }else {
                    if let user = Auth.auth().currentUser?.email{
                        self.db.collection("Adminler").document("Kişiler").collection(user).addDocument(data: [
                            
                            "mail": email,
                            "name": name,
                            "TeslimEdilenSipariş": 0
                        ]){(error) in
                            if let e = error {
                                print(e.localizedDescription)
                            }else {
                                print("Admin kayıt edildi")
                                self.performSegue(withIdentifier: "btnSegue", sender: self)
                                print("succesfuly signed")
                            }
                        }
                        
                    }
                    
                }
            }
        }
        
    }
    
}
