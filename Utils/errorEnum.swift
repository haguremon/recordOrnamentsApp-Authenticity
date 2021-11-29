//
//  errorEnum.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/11/29.
//

import Foundation


enum SomeError: Error {
    case decodingError
    case domainError
    case urlError
    case assertNilError
}
