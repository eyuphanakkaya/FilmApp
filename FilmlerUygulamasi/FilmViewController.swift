//
//  FilmViewController.swift
//  FilmlerUygulamasi
//
//  Created by Kasım Adalan on 30.07.2019.
//  Copyright © 2019 info. All rights reserved.
//

import UIKit
import Firebase

class FilmViewController: UIViewController {
    @IBOutlet weak var filmCollectionView: UICollectionView!
    
    var filmListesi = [Filmler]()
    var ref:DatabaseReference?
    var kategori:Kategoriler?
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        filmCollectionView.delegate = self
        filmCollectionView.dataSource = self
        
        if let k = kategori {
            navigationItem.prompt = k.kategori_ad!
            tumFilm(kategori_ad: k.kategori_ad!)
        }
        
        let tasarim :UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let genislik = self.filmCollectionView.frame.size.width
        
        tasarim.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let hucreGenislik = (genislik-30)/2
        
        tasarim.itemSize = CGSize(width: hucreGenislik, height: hucreGenislik*1.7)
        
        tasarim.minimumInteritemSpacing = 10
        tasarim.minimumLineSpacing = 10
        
        filmCollectionView.collectionViewLayout = tasarim
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indeks = sender as? Int
        
        let toDestination = segue.destination as? FilmDetayViewController
        toDestination?.film = filmListesi[indeks!]
        
    }
    
    func tumFilm(kategori_ad:String){
        let sorgu = ref?.child("filmler").queryOrdered(byChild: "kategori_ad").queryEqual(toValue: kategori_ad)
        
        sorgu!.observe(.value, with: { snapshots in
                if let gelenVeriButunu = snapshots.value as? [String:AnyObject] {
                    self.filmListesi.removeAll()
                    for gelenSatirVerisi in gelenVeriButunu {
                        if let sozluk = gelenSatirVerisi.value as? NSDictionary {
                            let key = gelenSatirVerisi.key
                            let film_ad = sozluk["film_ad"] as? String ?? ""
                            let film_yil = sozluk["film_yil"] as? Int ?? 0
                            let film_resim = sozluk["film_resim"] as? String ?? ""
                            let kategori_ad = sozluk["kategori_ad"] as? String ?? ""
                            let yonetmen_ad = sozluk["yonetmen_ad"] as? String ?? ""
                            
                            let film = Filmler(film_id: key, film_ad: film_ad, film_yil: film_yil, film_resim: film_resim, kategori_ad: kategori_ad, yonetmen_ad: yonetmen_ad)
                            
                            self.filmListesi.append(film)
                            
                            
                            
                        }
                        
                    }
                    
                  
                }else {
                    self.filmListesi = [Filmler]()
                }
                DispatchQueue.main.async {
                    self.filmCollectionView.reloadData()
                }
            })
        
    }

}

extension FilmViewController:UICollectionViewDelegate,UICollectionViewDataSource,FilmHucreCollectionViewCellProtocol{
    
    func sepeteEkle(indexPath: IndexPath) {
        print("Sepete Eklenen Film : \(filmListesi[indexPath.row].film_ad!)")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filmListesi.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let film = filmListesi[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filmHucre", for: indexPath) as! FilmHucreCollectionViewCell
        
        cell.labelFilmAdi.text = film.film_ad
        cell.labelFilmFiyat.text = "14.99 TL"
        
        if let url = URL(string: "http://kasimadalan.pe.hu/filmler/resimler/\(film.film_resim!).png"){
            DispatchQueue.global().async {
                let data  = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    cell.imageViewFilmResim.image = UIImage(data: data!)
                }
            }
        }
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        
        cell.hucreProtocol = self
        cell.indexPath = indexPath
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetay", sender: indexPath.row)
    }
}
