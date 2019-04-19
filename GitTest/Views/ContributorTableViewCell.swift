//
//  ContributorTableViewCell.swift
//  GitTest
//
//  Created by Developer on 4/19/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import MapKit

class ContributorTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var amountCommits: UILabel!
    
    private var location: String?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.profileImage.image = UIImage(named: "hacker")
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.height * 0.5
        self.username.text = ""
        self.amountCommits.text = ""
    }

    func configureWith(_ contributor: Contributor?) {
        guard let contributor = contributor else {
            return
        }
        self.username.text = contributor.login
        self.amountCommits.text = "commits: \(contributor.contributions)"
        
        if let url = contributor.avatar_url, !url.isEmpty {
            downloadImageByUrl(url)
        }
        
        ContributorsAPI.fetchLocation(username: contributor.login) { (user, error) in
            guard error == nil else { return }
            
            guard let user = user, let loc = user.location else { return }
            self.location = loc
        }
    }
    
    @IBAction func onLocationButtonPressed(_ sender: UIButton) {
        coordinates(forAddress: self.location) { [weak self] coord in
            self?.openMapForPlace(coordinates: coord)
        }
    }
}

private extension ContributorTableViewCell {
    func downloadImageByUrl(_ url: String) {
        Alamofire.request(url).responseImage { response in
            if let image = response.result.value {
                self.profileImage.image = image
                self.profileImage.layer.cornerRadius = self.profileImage.bounds.height * 0.5
            }
        }
    }
    
    func coordinates(forAddress address: String?, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        guard let add = address else {
            return completion(nil)
        }
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(add) {
            (placemarks, error) in
            guard error == nil else {
                print("Geocoding error: \(error!)")
                completion(nil)
                return
            }
            
            completion(placemarks?.first?.location?.coordinate)
        }
    }
    
    func openMapForPlace(coordinates: CLLocationCoordinate2D?) {
        guard let coordinate = coordinates else { return }
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.02))
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        let options = [
            MKLaunchOptionsMapCenterKey:   NSValue(mkCoordinate: region.center),
            MKLaunchOptionsMapSpanKey:     NSValue(mkCoordinateSpan: region.span)]
        mapItem.name = location ?? ""
        mapItem.openInMaps(launchOptions: options)
    }
}
