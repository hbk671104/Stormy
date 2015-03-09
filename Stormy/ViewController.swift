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
	
	private let apiKey = "f038070bd7ace19b10621d8380c2fb5d"
	let locationManager = CLLocationManager()
	let sharedSession = NSURLSession.sharedSession()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		// Location manager config
		self.locationManager.requestWhenInUseAuthorization()		
		if CLLocationManager.locationServicesEnabled() {
			self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
			self.locationManager.delegate = self
			self.locationManager.startUpdatingLocation()
		}
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
		
		// Optional binding
		if let location = manager.location {
			
			let coordinate = location.coordinate
			
			// Stop location update, just to save some battery
			self.locationManager.stopUpdatingLocation()
			
			// Configure requestURL based on lat and long
			var requestURL = configureRequestURL(coordinate.latitude, long: coordinate.longitude)
			
			retrieveWeatherData(requestURL)
			
		}
		
	}
	
	func configureRequestURL(lat: Double, long: Double) -> NSURL {
		
		let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
		let forecastURL = NSURL(string: "\(lat),\(long)", relativeToURL: baseURL)
		
		return forecastURL!
		
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
					
				})
				
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

}

