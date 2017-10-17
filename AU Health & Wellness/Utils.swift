//
//  Utils.swift
//  AU Health & Wellness
//
//  Created by You, EuiBin on 10/10/17.
//  Copyright © 2017 You, EuiBin. All rights reserved.
//

import Foundation

typealias IndicesTuple = (start:String.Index, end:String.Index)
typealias IndicesTuple2 = (location: Int, length: Int)

typealias SubstringIndices = [IndicesTuple]
typealias SubstringIndices2 = [IndicesTuple2]

extension Int {
    func toStringIndex() -> String.Index {
        return String.Index.init(encodedOffset: self)
    }
}

func toNSRange(_ indices: IndicesTuple) -> NSRange {
    return NSMakeRange(indices.start.encodedOffset+1, indices.end.encodedOffset-indices.start.encodedOffset-1)
}

extension String {
    func rangeFromUtf32Indices(_ location: Any?, _ length: Any?) -> NSRange {
        // change behavior on error from crashing app to something else
        guard let location = location as? Int else { fatalError("location (Any?) could not be unwrapped to (Int)") }
        guard let length = length as? Int else { fatalError("length (Any?) could not be unwarpped to (Int)") }
        
        let utf32StartIndex = self.unicodeScalars.index(self.startIndex, offsetBy: location)
        
        return NSMakeRange(utf32StartIndex.encodedOffset, length)
    }
}
