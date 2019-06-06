//
//  SwiftyImageTests.swift
//  SwiftyImageTests
//
//  Created by 전수열 on 7/14/15.
//  Copyright (c) 2015 Suyeol Jeon. All rights reserved.
//

import UIKit
import XCTest
import SwiftyImage

class SwiftyImageTests: XCTestCase {
  func testCacheLock() {
    for _ in 0..<100 {
      DispatchQueue.global().async {
        _ = UIImage.resizable().border(width: 1).corner(radius: 15).image
      }
    }

    let expectation = XCTestExpectation()
    XCTWaiter().wait(for: [expectation], timeout: 1)
  }
}
