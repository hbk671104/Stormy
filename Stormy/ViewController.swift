//
//  ViewController.swift
//  Stormy
//
//  Created by BK on 3/8/15.
//  Copyright (c) 2015 Bokang Huang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
				
				
			}
				
		})
		downloadTask.resume()
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

