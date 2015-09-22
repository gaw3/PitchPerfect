//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Gregory White on 9/9/15.
//  Copyright (c) 2015 Gregory White. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
	var filePathUrl: NSURL!
	var title: String!

	init(filePathUrl: NSURL, title: String) {
		self.filePathUrl = filePathUrl
		self.title = title
	}

}
