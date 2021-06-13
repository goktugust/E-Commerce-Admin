//
//  FirstScreenVC.swift
//  E-Commerce-Admin
//
//  Created by Göktuğ Üstüner on 9.06.2021.
//

import UIKit
import Firebase

class FirstScreenVC: UIViewController {
    
    @IBOutlet weak var kaydolBtn: UIButton!
    @IBOutlet weak var girisBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(false)
        if Auth.auth().currentUser?.email != nil{
            
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: "alreadySignedIn", sender: self)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func girisPressed(_ sender: UIButton) {
    }
    @IBAction func kaydolPressed(_ sender: UIButton) {
    }
}
