//
//  ViewController.swift
//  ISSCodingChallenge
//
//  Created by Ryan Sander on 2/20/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit
import CoreLocation

final class PassesTableViewController: UITableViewController {
    
    private var passes = [Pass]()
    private var currentLat: Double?
    private var currentLong: Double?
    
    private let riseTimeFormatter = DateFormatter()
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = barButton
        
        riseTimeFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        /* Be a good samaritan since we do not need very specific location data. */
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl = refresh
    }
    
    // MARK: TableView delegate & datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pass = passes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "passCell", for: indexPath)
        
        let riseTimeDate = Date(timeIntervalSince1970: pass.risetime)
        cell.textLabel?.text = riseTimeFormatter.string(from: riseTimeDate)
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        let durationMinutes = pass.duration / 60
        cell.detailTextLabel?.text = "\(String(durationMinutes)) min"
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        
        return cell
    }
    
    // MARK: Pull to Refresh
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        /* If user has not accepted yet, they are being prompted. */
        if CLLocationManager.authorizationStatus() == .notDetermined {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse  {
            locationManager.startUpdatingLocation()
        } else {
            let alert = UIAlertController(title: "Error", message: "Could not get location. If it is not turned on, please turn it on in your settings.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true) {
                refreshControl.endRefreshing()
            }
        }
    }
    
    @objc private func infoButtonTapped() {
        performSegue(withIdentifier: "infoSegue", sender: self)
    }
    
    // MARK: Private Methods
    
    /* Would normally abstract network calls into a network layer, but due to time I'm just leaving it here. */
    private func loadData() {
        guard let currentLat = currentLat, let currentLong = currentLong else {
            present(PassesTableViewController.authorizeLocationAlert(), animated: true, completion: nil)
            return
        }
        
        var passesRequest = URLRequest(url: ISSNetworking.passesURL(lat: currentLat, long: currentLong))
        passesRequest.httpMethod = "GET"
        passesRequest.setValue(URLHeader.Value.json, forHTTPHeaderField: URLHeader.Key.contentType)
        
        let getPassesTask = URLSession.shared.dataTask(with: passesRequest) { [weak self] data, urlResponse, error in
            guard let data = data else { print("no data."); return }
            
            if let networkResponse = try? JSONDecoder().decode(NetworkResponse<PassNetworkRequest, Array<Pass>>.self, from: data) {
                self?.passes.reserveCapacity(networkResponse.request.passes)
                self?.passes = networkResponse.response
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.refreshControl?.endRefreshing()
                }
            } else if let serverMessage = try? JSONDecoder().decode(ServerMessage.self, from: data) {
                DispatchQueue.main.async {
                    self?.refreshControl?.endRefreshing()
                    self?.present(PassesTableViewController.alertController(for: serverMessage.reason), animated: true, completion: nil)
                }
            } else {
                self?.present(PassesTableViewController.alertController(for: ""), animated: true, completion: nil)
                self?.refreshControl?.endRefreshing()
            }
        }
        
        getPassesTask.resume()
    }
}

// MARK: CLLocationManagerDelegate

extension PassesTableViewController: CLLocationManagerDelegate {
    /* The location currently triggers twice, so I would further do logic to get this to happen once. To the user, this works fine for now. */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /* Get first location for API. */
        guard let location = locations.first else {
            return
        }
        
        currentLat = location.coordinate.latitude
        currentLong = location.coordinate.latitude
        
        manager.stopUpdatingLocation()
        
        loadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            refreshControl?.endRefreshing()
        }
        if status == .authorizedWhenInUse {
            refreshControl?.beginRefreshing()
            manager.startUpdatingLocation()
        }
    }
}
