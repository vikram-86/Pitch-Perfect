//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Suthananth Arulanantham on 08.03.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//

import Foundation

class RecordedAudio :NSObject{
    var filePathURL: NSURL!
    var title:String!
    
    init(fileUrl: NSURL!, title: String!) {
        self.filePathURL = fileUrl
        self.title = title
    }
}
