//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Noah J Anderson on 7/28/15.
//  Copyright (c) 2015 Noah J Anderson. All rights reserved.
//

import Foundation

class RecordedAudio {
    var title: String!
    var filePathUrl: NSURL!

    init(title: String, filePathUrl: NSURL){
        self.title = title
        self.filePathUrl = filePathUrl
    }
}
