//
//  ViewController.swift
//  DailyPlanet
//
//  Created by Thomas Vandegriff on 2/7/19.
//  Copyright © 2019 Make School. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokiCell", for: indexPath)
        cell.textLabel!.text = pokemons[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let characterURL = (pokemons[indexPath.row].url)
        fetchPokemonImage(url: characterURL)
//        print(pokemonImage!)
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == tableView.numberOfSections - 1 &&
            indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            // Notify interested parties that end has been reached
            fetchNasaDailyImage(url: nextTenURLS!)
            print("end")
        }
    }


    @IBOutlet weak var nasaDailyImageView: UIImageView!
    
    let table = UITableView()
    var pokemons = [Pokemon]()
    var nextTenURLS : String? = nil
    var pokemonImage : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNasaDailyImage(url: "https://pokeapi.co/api/v2/pokemon?limit=10&offset=10")

//        fetchHeaderData()
        
        //TODO: Call function to fetch image data here
        setUpTable()

        
    }
    
    func setUpTable() {
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false

        table.register(UINib(nibName: "PokiCell", bundle: nil), forCellReuseIdentifier: "pokiCell")
        
        table.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        table.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        table.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
    }

    //MARK: Data Fetch functions
    
    func fetchHeaderData() {
        
        let defaultSession = URLSession(configuration: .default)
        
        // Create URL
        let url = URL(string: "https://httpbin.org/headers")
        
        // Create Request
        let request = URLRequest(url: url!)
        
        // Create Data Task
        let dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
//            print("data is: ", data!)
//            print("response is: ", response!)
            
        })
        dataTask.resume()
    }

     // CODE BASE for In-Class Activity I
    func fetchNasaDailyImage(url: String) {
        
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
                
                do {
//                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let pokemons = try decoder.decode(PokemonList.self, from: data!)
                    self.pokemons.append(contentsOf: pokemons.results)
                    
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
//                    print(self.pokemons)
//                    print(pokemons.results[0].name)
                    self.nextTenURLS = pokemons.next!
                    
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
                
            })
            dataTask.resume()
        }
    }
    
    func fetchPokemonImage(url: String) {
            
            //TODO: Create session configuration here
            let defaultSession = URLSession(configuration: .default)

            //TODO: Create URL (...and send request and process response in closure...)
            if let url = URL(string: url) {
                
               //TODO: Create Request here
                let request = URLRequest(url: url)

                print(url)
                // Create Data Task...
                let dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                    
    //                print("data is: ", data!)
    //                print("response is: ", response!)
                    
                    do {
//                        let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
//                        print(jsonObject)
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let pokemonImage = try decoder.decode(GetPokemonImage.self, from: data!)
                        self.pokemonImage = pokemonImage.sprites.frontDefault
                        print(self.pokemonImage!)
                        
                        DispatchQueue.main.async {
                            let newVC = ViewController2()
                                                           
                            newVC.imageURL = self.pokemonImage!
                           
                            self.present(newVC, animated: true, completion: nil)


                            print("selected")
                        }
                       
                        
                    } catch {
                        print("JSON error: \(error.localizedDescription)")
                    }
                    
                })
                dataTask.resume()
            }
        }
}

struct Pokemon : Codable{
    let name: String
    let url: String
}

struct PokemonList: Codable {
    let next: String?
    let results: [Pokemon]
}


struct GetPokemonImage: Codable {
    let sprites: Image
}

struct Image : Codable {
    let frontDefault: String
}


class ViewController2: UIViewController {
    
    var imageURL : String? = nil
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.backgroundColor = .systemGray
        setImage(from: imageURL!)
        setupImage()
    }
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            print(image!)
            DispatchQueue.main.async {
                self.imageView.image = image
               
            }
        }
    }
    
    func setupImage(){
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
}
