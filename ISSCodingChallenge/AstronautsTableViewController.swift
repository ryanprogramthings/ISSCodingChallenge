//
//  AstronautsTableViewController.swift
//  ISSCodingChallenge
//
//  Created by Ryan Sander on 2/20/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit

final class AstronautsTableViewController: UITableViewController {
    
    private var astronauts = [Astronaut]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl = refresh
        
        handleRefresh(refresh)
    }
    
    /* Again, I'd have this networking logic abstracted into a network layer, but I didn't want to go that involved for this challenge. */
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        var passesRequest = URLRequest(url: ISSNetworking.astronautsURL)
        passesRequest.httpMethod = "GET"
        passesRequest.setValue(URLHeader.Value.json, forHTTPHeaderField: URLHeader.Key.contentType)
        
        let getPassesTask = URLSession.shared.dataTask(with: passesRequest) { [weak self] data, urlResponse, error in
            guard let data = data else { print("no data."); return }
            
            if let networkResponse = try? JSONDecoder().decode(AstronautNetworkResponse.self, from: data) {
                self?.astronauts.reserveCapacity(networkResponse.number)
                self?.astronauts = networkResponse.people
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.refreshControl?.endRefreshing()
                }
            } else if let serverMessage = try? JSONDecoder().decode(ServerMessage.self, from: data) {
                DispatchQueue.main.async {
                    self?.refreshControl?.endRefreshing()
                    self?.present(AstronautsTableViewController.alertController(for: serverMessage.reason), animated: true, completion: nil)
                }
            } else {
                self?.present(AstronautsTableViewController.alertController(for: ""), animated: true, completion: nil)
                self?.refreshControl?.endRefreshing()
            }
        }
        
        getPassesTask.resume()
    }
    
    // MARK: TableView delegate and datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return astronauts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let astronaut = astronauts[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "astronautCell", for: indexPath)
        cell.textLabel?.text = astronaut.name
        
        return cell
    }
    
    // MARK: Actions
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
}
