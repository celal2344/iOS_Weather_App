//
//  weeklyWeatherData.swift
//  celalTest1
//
//  Created by Eminullah Yaşar on 12.10.2023.
//

import Foundation

let apiURL = "https://api.open-meteo.com/v1/forecast?latitude=38.4127&longitude=27.1384&current=temperature_2m,is_day,rain,snowfall&daily=temperature_2m_max,rain_sum,snowfall_sum&timezone=Europe%2FMoscow"

struct CurrentWeatherData:Decodable{
    let time: Date
    let temperature: Double
    let rain: Double
    let snowfall: Double
    enum CodingKeys: String, CodingKey{
        case time
        case temperature = "temperature_2m"
        case rain
        case snowfall
        
    }
}

struct WeeklyWeatherData: Decodable{
    let times:[Date]
    let temperatures:[Double]
    let rains:[Double]
    let snowfalls:[Double]
    enum CodingKeys: String, CodingKey{
        case times = "time"
        case temperatures = "temperature_2m_max"
        case rains = "rain_sum"
        case snowfalls = "snowfall_sum"
    }
}
struct WeatherResponse: Decodable{
    let weeklyWeather : WeeklyWeatherData
    let currentWeather: CurrentWeatherData
    
}

func fetchWeatherDataFromAPI() async throws -> WeatherResponse{
    guard let url = URL(string: apiURL) else {
        throw apiError.invalidURL
        
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
        throw apiError.invalidResponse
    }
    
    do{
        let decoder = JSONDecoder()
        print(data)
        return try decoder.decode(WeatherResponse.self, from: data)
    } catch{
        throw apiError.invalidData
    }
}

enum apiError : Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
