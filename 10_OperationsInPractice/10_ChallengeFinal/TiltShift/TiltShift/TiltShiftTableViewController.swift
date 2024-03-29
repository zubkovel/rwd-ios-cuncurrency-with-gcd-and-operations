/*
* Copyright (c) 2016 Razeware LLC
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
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

class TiltShiftTableViewController: UITableViewController {
  
  let imageList = TiltShiftImage.loadDefaultData()
  var imageProviders = Set<TiltShiftImageProvider>()
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return imageList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TiltShiftCell", for: indexPath)
    
    if let cell = cell as? ImageTableViewCell {
      cell.tiltShiftImage = imageList[(indexPath as NSIndexPath).row]
    }
  
    return cell
  }
  
}

extension TiltShiftTableViewController {
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? ImageTableViewCell else { return }
    let imageProvider = TiltShiftImageProvider(tiltShiftImage: imageList[(indexPath as NSIndexPath).row]) {
      image in
      OperationQueue.main.addOperation {
        cell.updateImageViewWithImage(image)
      }
    }
    imageProviders.insert(imageProvider)
  }
  
  override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? ImageTableViewCell else { return }
    for provider in imageProviders.filter({ $0.tiltShiftImage == cell.tiltShiftImage }) {
      provider.cancel()
      imageProviders.remove(provider)
    }
  }
}
