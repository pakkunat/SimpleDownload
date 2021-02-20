//
//  ContentView.swift
//  SimpleDownload
//
//  Created by pakkun on 2021/02/20.
//

import SwiftUI

struct ContentView: View {
  // for binding textfield
  @State var status: String = ""
  
  var body: some View {
    VStack {
      // to act download
      Button("Start Download", action: startDownload)
      // to show download status
      TextField("Status", text: $status)
    }
  }
  
  func startDownload() {
    // sample source
    // https://developer.apple.com/documentation/foundation/url_loading_system/downloading_files_from_websites
    
    // weather data path of japan
    let url = URL(string: "https://www.data.jma.go.jp/obd/stats/data/mdrr/snc_rct/alltable/snc00_rct.csv")!
    // 1. create instance using singleton method
    let downloadTask = URLSession.shared.downloadTask(with: url) { urlOrNil, responseOrNil, errorOrNil in
      // 3. callback
      // urlOrNil == nil, return
      guard let fileURL = urlOrNil else { return }
      print("fileURL.lastPathComponent: \(fileURL.lastPathComponent)")
      do {
        // get local documents directory
        let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        print("documentsURL.absoluteURL: \(documentsURL.absoluteURL)")
        // get saved file path
        let savedURL = documentsURL.appendingPathComponent(fileURL.lastPathComponent)
        print("savedURL.absoluteURL: \(savedURL.absoluteURL)")
        // move file
        try FileManager.default.moveItem(at: fileURL, to: savedURL)
        status = "succeed"
      } catch {
        status = "file error: \(error)"
      }
    }
    // 2. execute download
    downloadTask.resume()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
