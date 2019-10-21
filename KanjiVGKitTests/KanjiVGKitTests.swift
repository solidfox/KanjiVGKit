//
//  KanjiVGKitTests.swift
//  KanjiVGKitTests
//
//  Created by Daniel Schlaug on 6/29/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

import XCTest
import Foundation
import KanjiVGKit
import UIKit

class KanjiVGKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParser() {
        let filePath = NSBundle(forClass:KanjiVGKitTests.self).pathForResource("09078", ofType: "svg")
        XCTAssertNotNil(filePath)
        let data = NSData(contentsOfFile: filePath)
        XCTAssertNotNil(data)
        let parser = KVGParser(SVGData: data)
        let entry = parser.parse()!
        XCTAssertEqual(entry.character, Character("選"))
        XCTAssertEqual(entry.strokes.count , 15)
        let includedPoints = [
            CGPoint(x:53 , y:19),
            CGPoint(x:43.5 , y:26.5),
            CGPoint(x:48 , y:36),
            CGPoint(x:82 , y:16),
            CGPoint(x:71 , y:24.8),
            CGPoint(x:78 , y:33),
            CGPoint(x:82 , y:51),
            CGPoint(x:55.5 , y:48),
            CGPoint(x:74.5 , y:45.5),
            CGPoint(x:44.9 , y:67.3),
            CGPoint(x:57 , y:73),
            CGPoint(x:82.5 , y:78.5),
            CGPoint(x:26.5 , y:23.5),
            CGPoint(x:25 , y:51),
            CGPoint(x:26 , y:83)
        ]
        let types: [Character] = ["㇕","㇐","㇟","㇕","㇐","㇟","㇐","㇑","㇑","㇐","㇒","㇔","㇔","㇋","㇏"]
        let parentUnicodes: [Character?] = ["己","己","己","己","己","己",nil,nil,nil,nil,"八","八","⻌","⻌","⻌"]
        var i = 0
        for stroke in entry.strokes {
            let parent: KVGElement = stroke.parent
            let parentUnicode: Character? = parent.mostSimilarUnicode
            XCTAssertEqual(stroke.strokeOrder, i+1)
            XCTAssertEqual(stroke.type, types[i])
            if let desiredParentUnicode = parentUnicodes[i] {
                XCTAssert(parentUnicode != nil)
                XCTAssertEqual(parentUnicode!, desiredParentUnicode)
            } else {
                XCTAssert(parentUnicode == nil)
            }
            XCTAssert(stroke.path.containsPoint(includedPoints[i]), "Stroke test failed for stroke \(i+1)")
            ++i
        }
        
    }
    
}
