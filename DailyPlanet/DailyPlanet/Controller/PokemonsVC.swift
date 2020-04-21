//
//  ViewController.swift
//  DailyPlanet
//
//  Created by Thomas Vandegriff on 2/7/19.
//  Copyright © 2019 Make School. All rights reserved.
//

import UIKit

class PokemonsVC: UIViewController {
        
    let table = UITableView()
    var pokemons = [Pokemon]()
    var nextTenURL : String? = nil
    var pokemonImageURL : String? = nil
    let pokemonsURL = "https://pokeapi.co/api/v2/pokemon?limit=10"
//    let pokemonOffsetURL = "&offset=10"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPokemonList(url: "\(pokemonsURL)")
                
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
    
    // CODE BASE for In-Class Activity I
    func fetchPokemonList(url: String) {
        
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
//                    print(pokemons)
                    self.pokemons.append(contentsOf: pokemons.results)
                    
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                    //                    print(self.pokemons)
                    //                    print(pokemons.results[0].name)
                    self.nextTenURL = pokemons.next!
                    
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
            
//            print(url)
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
                    self.pokemonImageURL = pokemonImage.sprites.frontDefault
//                    print(self.pokemonImage!)
                    
                    DispatchQueue.main.async {
                        let pokemonImageViewController = PokemonImageVC()
                        
                        pokemonImageViewController.imageURL = self.pokemonImageURL!
                        
                        self.present(pokemonImageViewController, animated: true, completion: nil)
                        
                    }
                    
                    
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
                
            })
            dataTask.resume()
        }
    }
}



extension PokemonsVC: UITableViewDataSource, UITableViewDelegate {
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
            fetchPokemonList(url: "\(nextTenURL!)")
            print("end")
        }
    }
}
