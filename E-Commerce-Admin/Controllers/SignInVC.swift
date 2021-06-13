//
//  SignInVVC.swift
//  E-Commerce-Admin
//
//  Created by Göktuğ Üstüner on 9.06.2021.
//

import UIKit
import Firebase
class SignInVC: UIViewController {

    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func btnPressed(_ sender: UIButton) {
        
        if let email = emailText.text, let password = passwordText.text {
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let e = error {
                    let alert = UIAlertController(title: "Error", message: "\(e.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    print(e.localizedDescription)
                }else {
                    self.performSegue(withIdentifier: "signedIn", sender: self)
                    print("Signed in")
                }
            }
        }
        
        
        
    }
    
}
