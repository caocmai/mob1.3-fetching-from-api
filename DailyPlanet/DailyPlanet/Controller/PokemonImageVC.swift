//
//  PokemonVC.swift
//  DailyPlanet
//
//  Created by Cao Mai on 4/18/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

class PokemonImageVC: UIViewController {
    
    var imageURL : String? = nil
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.backgroundColor = .systemGray
//        setImage(from: imageURL!)
        fetchPokemonImage(url: imageURL!)
        setupImage()
    }
    
//    func setImage(from url: String) {
//        guard let imageURL = URL(string: url) else { return }
//
//            // just not to cause a deadlock in UI!
//        DispatchQueue.global().async {
//            guard let imageData = try? Data(contentsOf: imageURL) else { return }
//
//            let image = UIImage(data: imageData)
//            print(image!)
//            DispatchQueue.main.async {
//                self.imageView.image = image
//
//            }
//        }
//    }
//
    // Or can just use this function
    func fetchPokemonImage(url: String) {
        
        //TODO: Create session configuration here
        let defaultSession = URLSession(configuration: .default)

        
        //TODO: Create URL (...and send request and process response in closure...)
        if let url = URL(string: url) {
            
           //TODO: Create Request here
            let request = URLRequest(url: url)
            // Create Data Task...
            let dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                
//                print("data is: ", data!)
//                print("response is: ", response!)
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                          //TODO: Insert downloaded image into imageView
                    }
                }
            })
            dataTask.resume()
        }
    }
    
    func setupImage(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor)
        ])
    }
    
}
