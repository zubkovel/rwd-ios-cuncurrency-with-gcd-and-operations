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

import Foundation

// Thread-safe Number
// DONE: Use an isolationQueue with dispatch barrier to make this class thread-safe.

class Number {
  var value: Int
  var name: String
  
  let isolationQueue = DispatchQueue(label: "com.raywenderlich.number.isolation", attributes: DispatchQueue.Attributes.concurrent)
  
  init(value: Int, name: String) {
    self.value = value
    self.name = name
  }
  
  func changeNumber(_ value: Int, name: String) {
    isolationQueue.async(flags: .barrier, execute: {
      randomDelay(0.1)
      self.value = value
      randomDelay(0.5)
      self.name = name
    })
  }
  
  var number: String {
    var result = ""
    isolationQueue.sync {
      result = "\(self.value) :: \(self.name)"
    }
    return result
  }
}

// Not thread-safe
//class Number {
//  var value: Int
//  var name: String
//
//  init(value: Int, name: String) {
//    self.value = value
//    self.name = name
//  }
//
//  func changeNumber(_ value: Int, name: String) {
//    randomDelay(0.1)
//    self.value = value
//    randomDelay(0.5)
//    self.name = name
//  }
//
//  var number: String {
//    return "\(value) :: \(name)"
//  }
//
//}
