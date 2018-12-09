//
//  SearchViewController.swift
//  LandmarkRemark
//
//  Created by Miley Liu on 10/12/18.
//  Copyright © 2018 Simeng Liu. All rights reserved.
//

import UIKit
import CoreLocation

protocol SearchControllerDelegate {
    func findLocation(coordinate:CLLocationCoordinate2D)
}

class SearchViewController: UIViewController, UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource{

    var delegate:SearchControllerDelegate?

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultTableView: UITableView!
    var dataSource : NSMutableArray = NSMutableArray()
    var resultArray :NSMutableArray = NSMutableArray()
    var locations = [Location]()
    var results = [Location]()
  
//    var selectedLocations = Location()
    var isSearch = false//default
    
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
                print("error:\(error)")
                return
            }
            
            for location in array! {
                
                let locationData = Location.init(with: location as! [String : Any])
                self.locations.append(locationData)
                self.dataSource.add(location)
                
            }
            self.resultTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if isSearch{
            return self.resultArray.count
        }
        else {return self.dataSource.count}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        if isSearch {
            let loc = results[indexPath.row]
            cell.textLabel?.text = loc.user_name
            cell.detailTextLabel?.text = loc.note
        }
        else{
            let loc = locations[indexPath.row]
            cell.textLabel?.text = loc.user_name
            cell.detailTextLabel?.text = loc.note
        }
        
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        if isSearch {
            let loc = results[indexPath.row]
            let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(loc.latitude), CLLocationDegrees(loc.longitude))
            self.dismiss(animated: true) {
                
                //todo point to the coordinate
                
              self.delegate?.findLocation(coordinate: coordinate)
            }
        }
        else{
            let loc = locations[indexPath.row]
            let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(loc.latitude), CLLocationDegrees(loc.longitude))
            
            self.dismiss(animated: true) {
                   //todo point to the coordinate
                self.delegate?.findLocation(coordinate: coordinate)
                
            }
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
    
   
    
    func request(keyword:String){
        let param = ["searchNote":keyword] as [String:AnyObject]
        RequestManager.init(APIName: SEARCH_API, parameter: param).requestMany { (array, error) in
           
            guard error == nil, array!.count > 0 else{
               self.resultTableView.reloadData()
            
                return
            }
            self.resultArray = NSMutableArray()
            self.results = [Location]()
            print("array:\(array!.count)")
            for loc in array! {
                let locationData = Location.init(with: loc as! [String : Any])

                self.results.append(locationData)
                self.resultArray.add(loc)

            }
             self.resultTableView.reloadData()
        }
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
