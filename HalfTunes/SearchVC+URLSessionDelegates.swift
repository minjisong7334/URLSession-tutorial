//
//  SearchVC+URLSessionDelegates.swift
//  HalfTunes
//
//  Created by minji song on 11/3/17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import Foundation

extension SearchViewController: URLSessionDownloadDelegate {
  // only non-optional method which is called when a download finishes. For now, you'll just print a message whenever a download completes.
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                  didFinishDownloadingTo location: URL) {
    print("Finished downloading to \(location).")
  }
}
