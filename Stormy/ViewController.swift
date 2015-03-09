//
//  ViewController.swift
//  Stormy
//
//  Created by BK on 3/8/15.
//  Copyright (c) 2015 Bokang Huang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var iconView: UIImageView!
	@IBOutlet weak var currentTimeLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
	@IBOutlet weak var humidityLabel: UILabel!
	@IBOutlet weak var precipitationLabel: UILabel!
	@IBOutlet weak var summaryLabel: UILabel!
	
	
	private let apiKey = "f038070bd7ace19b10621d8380c2fb5d"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
		let forecastURL = NSURL(string: "40.816526,-77.886265", relativeToURL: baseURL)
		
		let sharedSession = NSURLSession.sharedSession()
		let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL!, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
			
			if (error == nil) {
				let dataObject = NSData(contentsOfURL: location)
				let weatherDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
				
				let currentWeather = Current(weatherDictionary: weatherDictionary)
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					self.temperatureLabel.text = "\(currentWeather.temperature!)"
					self.iconView.image = currentWeather.icon!
					self.currentTimeLabel.text = "At \(currentWeather.currentTime!) it is"
					self.humidityLabel.text = "\(currentWeather.humidity)"
					self.precipitationLabel.text = "\(currentWeather.precipProbability)"
					self.summaryLabel.text = "\(currentWeather.summary)"
				})
			}
				
		})
		downloadTask.resume()
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

