//
//  ViewController.swift
//  Stormy
//
//  Created by BK on 3/8/15.
//  Copyright (c) 2015 Bokang Huang. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
	
	@IBOutlet weak var iconView: UIImageView!
	@IBOutlet weak var currentTimeLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
	@IBOutlet weak var humidityLabel: UILabel!
	@IBOutlet weak var precipitationLabel: UILabel!
	@IBOutlet weak var summaryLabel: UILabel!
	@IBOutlet weak var currentLocationLabel: UILabel!
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
	
	private let apiKey = "f038070bd7ace19b10621d8380c2fb5d"
	let locationManager = CLLocationManager()
	let sharedSession = NSURLSession.sharedSession()
	
	// MARK:
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		// Location manager config
		self.locationManager.requestWhenInUseAuthorization()		
		if CLLocationManager.locationServicesEnabled() {
			
			self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
			self.locationManager.delegate = self
			
			// Start updating location
			self.locationManager.startUpdatingLocation()
			
		}
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK:
	
	func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
		
		// Start animating
		loadingIndicator.startAnimating()
		
		// Optional binding
		if let location = manager.location {
			
			let coordinate = location.coordinate
			
			// Stop location update, just to save some battery
			self.locationManager.stopUpdatingLocation()
			
			// Configure requestURL based on lat and long
			var requestURL = configureRequestURL(coordinate.latitude, long: coordinate.longitude)
			
			updateCurrentLocality(location)
			retrieveWeatherData(requestURL)
			
		}
		
	}
	
	func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
		
		println("Error: " + error.localizedDescription)
		
	}
	
	// MARK:
	
	func configureRequestURL(lat: Double, long: Double) -> NSURL {
		
		let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
		let forecastURL = NSURL(string: "\(lat),\(long)", relativeToURL: baseURL)
		
		return forecastURL!
		
	}
	
	func updateCurrentLocality(location: CLLocation){
		
		CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
	
			if placemarks.count > 0 {
				
				let placemark: CLPlacemark = placemarks[0] as CLPlacemark
				self.currentLocationLabel.text = placemark.locality + ", " + placemark.administrativeArea
				
			}
			
 		})
		
	}
	
	func retrieveWeatherData(forecastURL: NSURL?) {
		
		let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL!, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
			
			if (error == nil) {
				
				let dataObject = NSData(contentsOfURL: location)
				let weatherDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
				
				let currentWeather = Current(weatherDictionary: weatherDictionary)
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					
					self.updateWeatherInterface(
						"\(currentWeather.temperature!)",
						image: currentWeather.icon!,
						currentTime: "At \(currentWeather.currentTime!) it is",
						humidity: "\(currentWeather.humidity)",
						precip: "\(currentWeather.precipProbability)",
						summary: "\(currentWeather.summary)")
					
					// Stop indicator animation
					self.loadingIndicator.stopAnimating()
					
				})
				
			} else {
				
				let networkIssueController = UIAlertController(title: "Error", message: "Unable to load data. Connection failed", preferredStyle: .Alert)
				
				let okButton = UIAlertAction(title: "Okay", style: .Default, handler: nil)
				let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
				
				networkIssueController.addAction(okButton)
				networkIssueController.addAction(cancelButton)
				
				self.presentViewController(networkIssueController, animated: true, completion: nil)
				
			}
			
		})
		
		downloadTask.resume()
	
	}
	
	func updateWeatherInterface(temp: String, image: UIImage, currentTime: String, humidity: String, precip: String, summary: String) {
		
		self.temperatureLabel.text = temp
		self.iconView.image = image
		self.currentTimeLabel.text = currentTime
		self.humidityLabel.text = humidity
		self.precipitationLabel.text = precip
		self.summaryLabel.text = summary
		
	}
	
	@IBAction func reloadingData(sender: AnyObject) {
		
		self.locationManager.startUpdatingLocation()
		
	}
	
}

