//
//  SwiftyImageTests.swift
//  SwiftyImageTests
//
//  Created by 전수열 on 7/14/15.
//  Copyright (c) 2015 Suyeol Jeon. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
import XCTest
@testable import SwiftyImage

class SwiftyImageTests: XCTestCase {
  func testCache() {
    XCTAssertEqual(
      UIImage.size(width: 10, height: 20).color(.blue).corner(radius: 5).border(width: 12).border(color: .red).image,
      UIImage.size(width: 10, height: 20).color(.blue).corner(radius: 5).border(width: 12).border(color: .red).image
    )
    XCTAssertEqual(
      UIImage.resizable().color(.blue).corner(radius: 5).border(width: 12).border(color: .red).image,
      UIImage.resizable().color(.blue).corner(radius: 5).border(width: 12).border(color: .red).image
    )
    XCTAssertNotEqual(
      UIImage.resizable().color(.blue).corner(radius: 5).border(width: 12).border(color: .red).image,
      UIImage.resizable().color(.red).corner(radius: 5).border(width: 12).border(color: .blue).image
    )
  }

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
#endif
