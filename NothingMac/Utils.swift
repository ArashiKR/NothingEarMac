//
//  Utils.swift
//  NothingMac
//
//  Created by Joe on 29/04/2023.
//

import Foundation

func PrintBinary(data: Data) {
    let byteArray = [UInt8](data)

    let hexArray = byteArray.map { String($0, radix: 16) }
    let hexString = hexArray.joined(separator: " ")

    print(hexString)
}
