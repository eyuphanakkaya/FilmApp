//
//  ViewController.swift
//  FilmlerUygulamasi
//
//  Created by Kasım Adalan on 30.07.2019.
//  Copyright © 2019 info. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var kategoriTableView: UITableView!
    
    var kategorilerListe = [Kategoriler]()
    var ref:DatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        ref = Database.database().reference()
        kategoriTableView.delegate = self
        kategoriTableView.dataSource = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        tumList()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indeks = sender as? Int
        
        let toDestination = segue.destination as? FilmViewController
        toDestination?.kategori = kategorilerListe[indeks!]
        
    }
    func tumList(){
        ref?.child("kategoriler").observe(.value, with: { snapshots in
            if let gelenVeriButunu = snapshots.value as? [String:AnyObject] {
                self.kategorilerListe.removeAll()
                for gelenSatirVerisi in gelenVeriButunu {
                    if let sozluk = gelenSatirVerisi.value as? NSDictionary {
                        let key = gelenSatirVerisi.key
                        let kategori_ad = sozluk["kategori_ad"] as? String ?? ""
                        
                        let ktg = Kategoriler(kategori_id: key, kategori_ad: kategori_ad)
                        
                        self.kategorilerListe.append(ktg)
                        
                        
                        
                    }
                    
                }
                
              
            }else {
                self.kategorilerListe = [Kategoriler]()
            }
            DispatchQueue.main.async {
                self.kategoriTableView.reloadData()
            }
        })
    }

}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kategorilerListe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let kategori = kategorilerListe[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "kategoriHucre", for: indexPath) as! KategoriHucreTableViewCell
        
        cell.labelKategoriAd.text = kategori.kategori_ad
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toFilm", sender: indexPath.row)
    }
}
