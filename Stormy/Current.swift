//
//  Current.swift
//  Stormy
//
//  Created by BK on 3/8/15.
//  Copyright (c) 2015 Bokang Huang. All rights reserved.
//

import Foundation

struct Current {
	
	var currentTime: String?
	var temperature: Int
	var humidity: Double
	var precipProbability: Double
	var summary: String
	var icon: String
	
	init(weatherDictionary: NSDictionary) {
		let currentWeather = weatherDictionary["currently"] as NSDictionary

		temperature = currentWeather["temperature"] as Int
		humidity = currentWeather["humidity"] as Double
		precipProbability = currentWeather["precipProbability"] as Double
		summary = currentWeather["summary"] as String
		icon = currentWeather["icon"] as String
		
		let currentTimeIntValue = currentWeather["time"] as Int
		currentTime = dateStringFromUnixTime(currentTimeIntValue)
		
	}
	
	func dateStringFromUnixTime(unixTime: Int) -> String {
		let timeInSeconds = NSTimeInterval(unixTime)
		let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.timeStyle = .ShortStyle
		
		return dateFormatter.stringFromDate(weatherDate)
	}
}
