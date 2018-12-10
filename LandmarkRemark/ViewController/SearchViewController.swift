//
//  SearchViewController.swift
//  LandmarkRemark
//
//  Created by Miley Liu on 10/12/18.
//  Copyright © 2018 Simeng Liu. All rights reserved.
//

import UIKit
import CoreLocation
//send back location coordinate to show in map
protocol SearchControllerDelegate {
    func findLocation(coordinate:CLLocationCoordinate2D)
}
class SearchViewController: UIViewController, UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource{
    var delegate:SearchControllerDelegate?
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultTableView: UITableView!
    
    var locations = [Location]()
    var results = [Location]()
    
    lazy var geoCoder: CLGeocoder = {
        return CLGeocoder()
    }()
    
    var isSearch = false//default
    //MARK: - IBAction
    @IBAction func closePage(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultTableView.delegate = self
        resultTableView.dataSource = self
        
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        
        listLocations()
    }
    
    func listLocations(){
        
        RequestManager.init(APIName: LIST_ALL_API, parameter: [:]).requestMany { (array, error) in
            
            guard error == nil, array!.count > 0 else{
                
              let alert =  getErrorAlert(error: error)
                self.present(alert, animated: true, completion: nil)
                return
            }
            for location in array! {
                let locationData = Location.init(with: location as! [String : Any])
                self.locations.append(locationData)
            }
            self.resultTableView.reloadData()
        }
    }
    
    //MARK: UITableviewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearch{
            return self.results.count
        }
        else {return self.locations.count}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! ResultTableViewCell
        
        var loc :Location?
       
        if isSearch {
            loc = results[indexPath.row]
        }
        else{
            loc = locations[indexPath.row]

        }
        cell.nameLabel.text = loc?.user_name
        cell.noteLabel.text = loc?.note
        
        let location = CLLocation(latitude: CLLocationDegrees((loc?.latitude)!), longitude: CLLocationDegrees(loc!.longitude))
        
        geoCoder.reverseGeocodeLocation(location) { (pls: [CLPlacemark]?, error: Error?) -> Void in
            if error == nil {
                let pl = pls?.first
                
                cell.placeLabel.text = "\(pl?.locality ?? ""),\(pl?.name ?? "")"
            }
            else {print("geocoder:\(error.debugDescription)")}
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var loc :Location?
        
        if isSearch {
            loc = results[indexPath.row]
            
        }
        else{
            loc = locations[indexPath.row]

        }
        let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees((loc?.latitude)!), CLLocationDegrees(loc!.longitude))
        self.dismiss(animated: true) {
            self.delegate?.findLocation(coordinate: coordinate)
        }
    }
    
    //MARK: UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            isSearch = false
        } else {
            print(searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchText = searchBar.text {
            
            isSearch = true
            request(keyword: searchText)
            self.resultTableView.reloadData()
        }
        
        self.searchBar.resignFirstResponder()
    }

    //MARK: NETWORKING
    func request(keyword:String){
        let param = ["searchNote":keyword] as [String:AnyObject]
        RequestManager.init(APIName: SEARCH_API, parameter: param).requestMany { (array, error) in
            
            guard error == nil, array!.count > 0 else{
                self.resultTableView.reloadData()
                return
            }
            
            self.results = [Location]()

            for loc in array! {
                let locationData = Location.init(with: loc as! [String : Any])
                
                self.results.append(locationData)
            }
            self.resultTableView.reloadData()
        }
    }
}
