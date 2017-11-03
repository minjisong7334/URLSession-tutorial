//
//  Download.swift
//  HalfTunes
//
//  Created by minji song on 11/3/17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import Foundation

class Download {
  // The track to download. The track's url property also acts as a unique identifier for a Download.
  var track: Track
  init(track:Track) {
    self.track = track
  }
  
  //Download service sets there values:
  var task: URLSessionDownloadTask? // The URLSessionDownloadTask that downloads the track
  var isDownloading = false // Whether the download is ongoing or paused
  var resumeData: Data? // Store the Data produced when the user paused a download task. If the host server supoorts it, your app can use this to resume a pasued downlad in the future.
  
  //Download delegate sets this values:
  var progress: Float = 0 // The fractional prograss of the download: a float between 0.0 and 1.0
}
