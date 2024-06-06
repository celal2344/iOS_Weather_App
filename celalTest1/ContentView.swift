//
//  ContentView.swift
//  celalTest1
//
//  Created by Eminullah Yaşar on 29.09.2023.
//

import SwiftUI
struct ContentView: View {
    @State private var isNight = false
    @State private var weatherData:WeatherResponse?
    var body: some View {
        ZStack{
            if let weatherData = weatherData{
                backgroundView(isNight: isNight)
            VStack{
                cityTextView(cityName: "İzmir")
                mainWeatherStatusView(imgName: isNight ? "moon.stars.fill" : "cloud.sun.fill",temperature: (weatherData.current.temperature2M) )
                Spacer()
                HStack(spacing: 12){
                    ForEach(1..<weatherData.daily.temperature2MMax.count-1, id: \.self){ i in
                        weatherDayView(dayOfWeek: String(getWeekday(from: weatherData.daily.time[i])!.prefix(3)),imageName: getWeatherIcon(from: weatherData.daily.rainSum[i]),temperature: (weatherData.daily.temperature2MMax[i].rounded())
                        )
                    }
                }
                Spacer()
                Button{
                    isNight.toggle()
                }label: {
                    weatherButton(title: "Change Day Time", textColor: .blue, backgroundColor: .white)
                }
                Spacer()
            }
            }
        }
        .task(){
            do{
                weatherData = try await fetchWeatherDataFromAPI()
                
            }catch{
                print("error")
            }
            
        }
    }
}

let apiURL = "https://api.open-meteo.com/v1/forecast?latitude=38.4127&longitude=27.1384&current=temperature_2m,is_day,rain,snowfall&daily=temperature_2m_max,rain_sum,snowfall_sum&timezone=Europe%2FMoscow"
func fetchWeatherDataFromAPI() async throws -> WeatherResponse{
    guard let url = URL(string: apiURL) else {
        throw apiError.invalidURL
    }

    let (data, response) = try await URLSession.shared.data(from: url)
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
        throw apiError.invalidResponse
    };
    let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
    return decoded
}
func getWeatherIcon(from rainfall:Double)->String{
    if rainfall>0{
        return "cloud.rain.fill"
    }else{
        return "sun.max.fill"
    }
    
}
func getWeekday(from dateString: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    if let date = dateFormatter.date(from: dateString) {
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEEE" // This will give you the full weekday name

        return weekdayFormatter.string(from: date)
    } else {
        return nil // Return nil if the date string is invalid
    }
}
enum apiError : Error {
    case invalidURL
    case invalidResponse
    case invalidData
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct weatherDayView: View {
    var dayOfWeek:String
    var imageName:String
    var temperature:Double
    
    var body: some View {
        VStack{
            Text(dayOfWeek)
                .font(.system(size: 30, weight: .medium, design: .default))
                .foregroundColor(.white)
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60,height: 60)
            Text("\(String(format:"%.0f",temperature))°")
                .font(.system(size: 35, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

struct backgroundView: View {
    var isNight:Bool
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [isNight ? .black: .blue,
                                                 isNight ? .gray: Color("lightBlue")]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .ignoresSafeArea()
    }
}
struct cityTextView: View{
    var cityName: String
    var body: some View{
        Text(cityName)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.white)
    }
}
struct mainWeatherStatusView: View{
    var imgName: String
    var temperature: Double
    
    var body: some View{
        VStack{
            Image(systemName: imgName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180,height: 180)
            Text("\(String(format:"%.1f",temperature))°")
                .font(.system(size: 80, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.bottom, 30)
    }
}

