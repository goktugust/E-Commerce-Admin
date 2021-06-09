//
//  OrderDetailsVC.swift
//  E-Commerce-Admin
//
//  Created by Göktuğ Üstüner on 22.05.2021.
//

import UIKit
import Firebase
import SDWebImage
class OrderDetailsVC: UIViewController {

    let db = Firestore.firestore()
    var adres = ""
    var total = ""
    var user = ""
    var payment = ""
    var note = ""
    var siparisID = 0
    
    var fetchedOrdersDetailsData = [GivenOrderDetailsFromFirestore]()
    
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var isimLabel: UILabel!
    @IBOutlet weak var siparisIptalBtn: UIButton!
    @IBOutlet weak var siparisTeslimBtn: UIButton!
    @IBOutlet weak var siparisYoldaBtn: UIButton!
    @IBOutlet weak var siparisKabulBtn: UIButton!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var totalPara: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var adresLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        
        getName()
        orderDetails()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(UINib(nibName: "SepetUrunuCell", bundle: nil), forCellReuseIdentifier: "sepetCell")
        
        tableView.dataSource = self
        paymentMethodLabel.text = payment
        totalPara.text = total
        adresLabel.text = adres
        noteLabel.text = note
        
        navigationItem.setHidesBackButton(false, animated: false)
        siparisYoldaBtn.isEnabled = false
        siparisTeslimBtn.isEnabled = false
        siparisIptalBtn.isEnabled = false
        
    }
    //MARK: - Getting the name of the person who gived order from firestore.
    func getName(){
        db.collection("Kullanıcılar").document("Email").collection(user).getDocuments { (snapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            }else {
                guard let snap = snapshot else {return}
                for document in snap.documents{
                    let data = document.data()
                    let name = data["name"] as! String
                    self.isimLabel.text = name
                }
                
            }
        }
    }
    //MARK: - Getting given order product details with conditions.(siparisId,user)
    func loadDB(onCompletion: @escaping ([GivenOrderDetailsFromFirestore]) -> ()){
        db.collection("OnaylanmışSiparişler").whereField("siparisId", isEqualTo: siparisID).whereField("user", isEqualTo: user).getDocuments { (snapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            }else {
                guard let snap = snapshot else {return}
                
                for document in snap.documents{
                    let data = document.data()
                    let user = data["user"] as? String ?? ""
                    let id = data["id"] as? Int ?? 0
                    let title = data["title"] as? String ?? ""
                    let price = data["price"] as? Float ?? 0
                    let description = data["description"] as? String ?? ""
                    let image = data["image"] as? String ?? ""
                    let category = data["category"] as? String ?? ""
                    let adet = data["adet"] as? Int ?? 1
                    let totalPara = data["totalPara"] as? Float ?? 0
                    let product = GivenOrderDetailsFromFirestore(adet: adet, category: category, description: description, id: id, image: image, price: price, title: title, totalPara: totalPara, user: user)
                    self.fetchedOrdersDetailsData.append(product)
                }
                onCompletion(self.fetchedOrdersDetailsData)
            }
        }
    }
    func orderDetails(){
        let anonFunc = {(fetchedProducts: [GivenOrderDetailsFromFirestore]) in
            self.fetchedOrdersDetailsData = []
            self.fetchedOrdersDetailsData = fetchedProducts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        loadDB(onCompletion: anonFunc)
    }
  
    //MARK: - Buttons with actions for db manuplating.
    @IBAction func siparisKabulBtnPressed(_ sender: UIButton) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        siparisYoldaBtn.isEnabled = true
        
        db.collection("Siparisler").whereField("user", isEqualTo: user).whereField("siparisId", isEqualTo: siparisID).getDocuments { (snapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            }else {
                guard let snap = snapshot else {return}
                
                let document = snap.documents.first
                document?.reference.updateData([
                    "status": "Hazırlanıyor"
                ])
            }
        }
        siparisKabulBtn.isEnabled = false
        
    }
    @IBAction func siparisYoldaBtnPressed(_ sender: UIButton) {
        siparisTeslimBtn.isEnabled = true
        
        db.collection("Siparisler").whereField("user", isEqualTo: user).whereField("siparisId", isEqualTo: siparisID).getDocuments { (snapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            }else {
                guard let snap = snapshot else {return}
                
                let document = snap.documents.first
                document?.reference.updateData([
                    "status": "Sipariş Yolda"
                ])
            }
        }
        
        siparisYoldaBtn.isEnabled = false
        
    }
    @IBAction func siparisTeslimBtnPressed(_ sender: UIButton) {
        siparisIptalBtn.isEnabled = true
        db.collection("Siparisler").whereField("user", isEqualTo: user).whereField("siparisId", isEqualTo: siparisID).getDocuments { (snapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            }else {
                guard let snap = snapshot else {return}
                
                let document = snap.documents.first
                document?.reference.updateData([
                    "status": "Sipariş Teslim Edildi"
                ])
            }
        }
        siparisTeslimBtn.isEnabled = false
    }
    @IBAction func siparisIptalBtnPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
//        db.collection("Siparisler").whereField("user", isEqualTo: user).getDocuments { (snapshot, error) in
//            if let e = error {
//                print(e.localizedDescription)
//            }else {
//                guard let snap = snapshot else {return}
//
//                let document = snap.documents.first
//                document?.reference.updateData([
//                    "status": "Sipariş Teslim Edildi"
//                ])
//            }
//        }
//        db.collection("OnaylanmışSiparişler").whereField("user", isEqualTo: user).getDocuments { (snapshot, error) in
//            if let e = error {
//                print(e.localizedDescription)
//            }else{
//                guard let snap = snapshot else {return}
//
//                for document in snap.documents{
//                    let data = document.data()
//                    let currentUser = data["user"] as? String ?? ""
//                    let id = data["id"] as? Int ?? 0
//                    let title = data["title"] as? String ?? ""
//                    let price = data["price"] as? Float ?? 0
//                    let description = data["description"] as? String ?? ""
//                    let image = data["image"] as? String ?? ""
//                    let category = data["category"] as? String ?? ""
//                    let adet = data["adet"] as? Int ?? 1
//                    let totalPara = data["totalPara"] as? Float ?? 0
//
////                    self.db.collection("TeslimEdilmişSiparişler").document(self.user).collection("\(self.siparisId)").addDocument(data: [
////                        "user": currentUser,
////                        "id": id,
////                        "title": title,
////                        "price": price,
////                        "description": description,
////                        "image": image,
////                        "category": category,
////                        "adet": adet,
////                        "totalPara": totalPara,
////
////                    ]){(error) in
////                        if let e = error {
////                            print(e.localizedDescription)
////                        }else {
////                            print("Success save!")
////                        }
////                    }
////                    document.reference.delete()
////                    print("deleted")
//
//                }
//
//
//            }
//        }
//
        
    }
}

    //MARK: - Tableview handling with all fetched data for the given order.
extension OrderDetailsVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if fetchedOrdersDetailsData.count >= 0 {
//            return fetchedOrdersDetailsData.count
//        }else {
//            return 1
//        }
        return fetchedOrdersDetailsData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sepetCell", for: indexPath) as! SepetUrunuCell
        
        let product = fetchedOrdersDetailsData[indexPath.row]
        
        cell.adetLabel.text = "Adet: \(product.adet)"
        cell.productImage.sd_setImage(with: URL(string: "\(product.image)"), placeholderImage: UIImage(named: "none"))
        cell.titleLabel.text = product.title
        cell.totalLabel.text = "Fiyat: $\(product.totalPara)"
        print(siparisID)
        return cell
    }
}
