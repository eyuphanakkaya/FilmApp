//
//  FilmDetayViewController.swift
//  FilmlerUygulamasi
//
//  Created by Kasım Adalan on 30.07.2019.
//  Copyright © 2019 info. All rights reserved.
//

import UIKit

class FilmDetayViewController: UIViewController {
    
    var film:Filmler?
    @IBOutlet weak var imageViewFilmResim: UIImageView!
    @IBOutlet weak var labelFilmAd: UILabel!
    @IBOutlet weak var labelFilmYil: UILabel!
    @IBOutlet weak var labelFilmKategori: UILabel!
    @IBOutlet weak var labelFilmYonetmen: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let f = film {
            if let url = URL(string: "http://kasimadalan.pe.hu/filmler/resimler/\(f.film_resim!).png"){
                DispatchQueue.global().async {
                    let data  = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        self.imageViewFilmResim.image = UIImage(data: data!)
                    }
                }
            }
            
            
                imageViewFilmResim.image = UIImage(named: f.film_resim!)
                labelFilmAd.text = f.film_ad
                labelFilmKategori.text = f.kategori_ad
                labelFilmYonetmen.text = f.yonetmen_ad
                labelFilmYil.text = String(f.film_yil!)
            
               
            
            // Do any additional setup after loading the view.
        }
        
    }
}
