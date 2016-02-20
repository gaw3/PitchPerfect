//
//  UIViewControllerExtensions.swift
//  PitchPerfect
//
//  Created by Gregory White on 2/20/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import UIKit

extension (UIViewController) {

	// MARK: - API

	func presentAlert(title: String, message: String) {
		let alert  = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
		alert.addAction(action)

		self.presentViewController(alert, animated: true, completion: nil)
	}
	
}