//
//  Repository.swift
//  DataSource
//
//  Created by Dao Van Nha on 16/01/2024.
//

import Foundation

public class Repository {
    public static var shared = Repository()
}

public extension Repository {
    var weather: WeatherDataSource {
        .init()
    }
}
