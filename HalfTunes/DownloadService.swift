/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

// Downloads song snippets, and stores in local file.
// Allows cancel, pause, resume download.
class DownloadService {
  
  // This dictionary simply mainatains a mapping between a URL and its active Download
  var activeDownloads: [URL: Download] = [:]

  // SearchViewController creates downloadsSession
  var downloadsSession: URLSession!

  // MARK: - Download methods called by TrackCell delegate methods

  func startDownload(_ track: Track) {
    // Initialize download track
    let download = Download(track: track)
    // Using your new session obejct, you create a URLSessionDownloadTask with the track's preview URL, and set it to the task property of the Download.
    download.task = downloadsSession.downloadTask(with: track.previewURL)
    // start the download task by calling resume() on it.
    download.task!.resume()
    // Indicate that the download is in progress.
    download.isDownloading = true
    // You map the download URL to its Download in the activeDownload dictionary.
    activeDownloads[download.track.previewURL] = download
  }
  // TODO: previewURL is http://a902.phobos.apple.com/...
  // why doesn't ATS prevent this download?

  func pauseDownload(_ track: Track) {
    // TODO
  }

  func cancelDownload(_ track: Track) {
    // TODO
  }

  func resumeDownload(_ track: Track) {
    // TODO
  }

}
