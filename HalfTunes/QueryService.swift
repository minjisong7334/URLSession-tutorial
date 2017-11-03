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

// Runs query data task, and stores results in array of Tracks
class QueryService {

  typealias JSONDictionary = [String: Any]
  typealias QueryResult = ([Track]?, String) -> ()

  var tracks: [Track] = []
  var errorMessage = ""

  // created URLsession with default configuration
  let defaultSession = URLSession(configuration: .default)
  // when a user perform search, will make an HTTP GET reqeust to iTunes Search web service
  // The data task will re-initialized each time depends on the new string
  var dataTask: URLSessionDataTask?

  func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {
    // For new query cancle the old task
    dataTask?.cancel()
    
    // Create URLComponenets Object with iTunes search base URL
    if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
      // Then set the its query string
      // This ensures that chracters in the search string are properly escaped
      urlComponents.query = "media=music&entity=song&term=\(searchTerm)"
      // url property of urlComponenets might be null, so you optional-bind it to url
      guard let url = urlComponents.url else { return }
      
      // From the session you created, you initialize a URLSessionDataTask with the query url and a completion handler to call when the data task completes.
      // default request method is GET. If you want a data take to POST,PUT or DELETE, create a URLRequest with the url, set the request's HTTPMethod property appropriately, then create a data task with the URLRequest, instead of with the URL
//      ex)
//      var urlRequest = URLRequest.init(url: url)
//      urlRequest.httpMethod = "POST"
//      dataTask = defaultSession.dataTask(with: urlRequest)
      
      dataTask = defaultSession.dataTask(with: url) {data, response, error in
        defer { self.dataTask = nil }
        
        // If the HTTP request is successful, you call the helper method updateSearchResults(_:), which parses the reponse data into the tracks array.
        if let error = error {
          self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
        } else if let data = data,
        let response = response as? HTTPURLResponse,
          response.statusCode == 200 {
          self.updateSearchResults(data)

          // You switch to the main queue to pass tracks to the completion handler in SearchVC+SearchBarDelegate.swift
          DispatchQueue.main.async {
            completion(self.tracks, self.errorMessage)
          }
        }
      }
      // All tasks start in a suspended state by default, calling resume() starts the data task. 
      dataTask?.resume()
    }
  }

  fileprivate func updateSearchResults(_ data: Data) {
    var response: JSONDictionary?
    tracks.removeAll()

    do {
      response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
    } catch let parseError as NSError {
      errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
      return
    }

    guard let array = response!["results"] as? [Any] else {
      errorMessage += "Dictionary does not contain results key\n"
      return
    }
    var index = 0
    for trackDictionary in array {
      if let trackDictionary = trackDictionary as? JSONDictionary,
        let previewURLString = trackDictionary["previewUrl"] as? String,
        let previewURL = URL(string: previewURLString),
        let name = trackDictionary["trackName"] as? String,
        let artist = trackDictionary["artistName"] as? String {
        tracks.append(Track(name: name, artist: artist, previewURL: previewURL, index: index))
        index += 1
      } else {
        errorMessage += "Problem parsing trackDictionary\n"
      }
    }
  }

}
