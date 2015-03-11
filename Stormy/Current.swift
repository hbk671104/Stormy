//
//  Current.swift
//  Stormy
//
//  Created by BK on 3/8/15.
//  Copyright (c) 2015 Bokang Huang. All rights reserved.
//

import Foundation
import UIKit

struct Current {
	
	var currentTime: String?
	var temperature: Int?
	var humidity: Double
	var visibility: Double
	var summary: String
	var icon: UIImage?
	
	init(weatherDictionary: NSDictionary) {
		
		let currentWeather = weatherDictionary["currently"] as NSDictionary
		
		humidity = currentWeather["humidity"] as Double
		visibility = currentWeather["visibility"] as Double
		summary = currentWeather["summary"] as String
		
		let tempInFahrenheit = currentWeather["temperature"] as Int
		temperature = fahrenheitToCelsius(tempInFahrenheit)
		
		let currentTimeIntValue = currentWeather["time"] as Int
		currentTime = dateStringFromUnixTime(currentTimeIntValue)
		
		let iconString = currentWeather["icon"] as String
		icon = weatherIconFromString(iconString)
		
	}
	
	func dateStringFromUnixTime(unixTime: Int) -> String {
		
		let timeInSeconds = NSTimeInterval(unixTime)
		let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.timeStyle = .ShortStyle
		
		return dateFormatter.stringFromDate(weatherDate)
		
	}
	
	func weatherIconFromString(stringIcon: String) -> UIImage {
		
		var imageName: String
		
		switch stringIcon {
			case "clear-day":
				imageName = "clear-day"
			case "clear-night":
				imageName = "clear-night"
			case "rain":
				imageName = "rain"
			case "snow":
				imageName = "snow"
			case "sleet":
				imageName = "sleet"
			case "wind":
				imageName = "wind"
			case "fog":
				imageName = "fog"
			case "cloudy":
				imageName = "cloudy"
			case "partly-cloudy-day":
				imageName = "partly-cloudy"
			case "partly-cloudy-night":
				imageName = "cloudy-night"
			default:
				imageName = "default"
		}
		
		return UIImage(named: imageName)!
		
	}
	
	func fahrenheitToCelsius(fahrenhietTemp: Int) -> Int {

		return (fahrenhietTemp-32)*5/9
		
	}
	
}
