//
//  AllOrdersVC.swift
//  E-Commerce-Admin
//
//  Created by Göktuğ Üstüner on 22.05.2021.
//

import UIKit
import Firebase
class AllOrdersVC: UIViewController {

    let db = Firestore.firestore()
    var fetchedGivenOrders = [GivenOrderFromFirestore]()
    
    @IBOutlet weak var rightItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(false)
        givenOrdesDB()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "AdresCell", bundle: nil), forCellReuseIdentifier: "adresCell")
        
    }
    @IBAction func rightItemPressed(_ sender: UIBarButtonItem) {
        givenOrdesDB()
    }
    
    //MARK: - fetching given orders data from firestore(condition: status = Hazırlanıyor)
    func loadDB(onCompletion: @escaping ([GivenOrderFromFirestore]) -> ()) {
        
        db.collection("Siparisler").whereField("status", isEqualTo: "Hazırlanıyor").order(by: "time").getDocuments { (snapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            }else {
                guard let snap = snapshot else {return}
                
                for document in snap.documents{
                    let data = document.data()
                    let totalPara = data["totalPara"] as? String ?? ""
                    let user = data["user"] as? String ?? ""
                    let payment = data["payment"] as? String ?? ""
                    let status = data["status"] as? String ?? ""
                    let adres = data["adres"] as? String ?? ""
                    let siparisNotu = data["siparisNotu"] as? String ?? ""
                    let siparisId = data["siparisId"] as? Int ?? 0
                    let orderFromUser = GivenOrderFromFirestore(user: user, status: status, payment: payment, adres: adres, totalPara: totalPara, siparisNotu: siparisNotu, siparisId: siparisId)
                    self.fetchedGivenOrders.append(orderFromUser)
                }
                onCompletion(self.fetchedGivenOrders)
            }
        }
    }
    
    func givenOrdesDB(){
        self.fetchedGivenOrders = []
        let anonFunc = {(fetchedList: [GivenOrderFromFirestore]) in
            self.fetchedGivenOrders = fetchedList
                DispatchQueue.main.async {
                    self.tableView.reloadData()
            }
        }
        loadDB(onCompletion: anonFunc)
    }
    
}

//MARK: - Tableview handling with fetched given order data
extension AllOrdersVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedGivenOrders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "adresCell", for: indexPath) as! AdresCell
        let siparis = fetchedGivenOrders[indexPath.row]
        cell.adresAdi.text = "\(siparis.totalPara)"
        cell.adresTarifi.text = siparis.adres
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detay", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? OrderDetailsVC {
            
            destination.adres = fetchedGivenOrders[tableView.indexPathForSelectedRow!.row].adres
            destination.total = fetchedGivenOrders[tableView.indexPathForSelectedRow!.row].totalPara
            destination.payment = fetchedGivenOrders[tableView.indexPathForSelectedRow!.row].payment
            destination.user = fetchedGivenOrders[tableView.indexPathForSelectedRow!.row].user
            destination.siparisID = fetchedGivenOrders[tableView.indexPathForSelectedRow!.row].siparisId
            destination.note = fetchedGivenOrders[tableView.indexPathForSelectedRow!.row].siparisNotu
            
            
        }
    }
}

