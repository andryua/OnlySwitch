//
//  BarProvider.swift
//  OnlySwitch
//
//  Created by Jacklandrin on 2022/1/7.
//

import Foundation

@objc protocol BarProvider {
    var barName:String {get}
    var weight:Int {get set}
}

