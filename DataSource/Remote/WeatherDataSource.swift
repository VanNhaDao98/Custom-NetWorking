//
//  WeatherDataSource.swift
//  DataSource
//
//  Created by Dao Van Nha on 16/01/2024.
//

import Foundation

public enum WeatherApi {
    case weather
}

extension WeatherApi: ApiRequestBuilder {
    public var requestBuilder: URLRequestBuilder {
        switch self {
        case .weather:
            return .default(domain: "//api.openweathermap.org/data",
                            path: "/2.5/weather",
                            params: ["lat": "21.0188373", "lon": "105.8056225", "appid" : "25fc77580a6dbd9f0123f08822f52f8a"])
        }
    }
}


public class WeatherDataSource: RemoteDateSource<WeatherApi>{
    public func getWeather(completion: @escaping (Result<HTTPResponse<WeatherModel>, Error>) -> Void) -> Cancellable {
        execute(api: .weather, completion: completion)
    }
}
