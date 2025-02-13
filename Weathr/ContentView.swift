//
//  ContentView.swift
//  Weathr
//
//  Created by Thomas Versteeg on 13/02/2025.
//

import SwiftUI

struct ContentView: View {
    @State var weatherData: WeatherData?
    let urlString = "https://api.openweathermap.org/data/2.5/weather?q=Oss&units=metric&appid=[APPID]"
    var body: some View {
        ZStack {
            Image("Lenticular_Cloud")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(edges: .all)
            VStack {
                Text("Oss")
                    .font(.custom("Helvetica Neue UltraLight", size: 60))
                Text(getTemperatureString())
                    .font(.custom("Helvetica Neue UltraLight", size: 90))
            }
            .padding()
        }
        .onAppear(perform: loadData)
    }
    func loadData() {
        guard let url = URL(string: urlString) else {
            print("ERROR: Cannot create URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("ERROR: (Fetch failed) \(error)")
                return
            }
            guard let data = data else {
                print("ERROR: No data returned from API call")
                return
            }
            var newWeatherData: WeatherData?
            do {
                newWeatherData = try JSONDecoder().decode(WeatherData.self, from: data)
            } catch let error as NSError {
                print("ERROR: (JSON decoding failed) \(error)")
            }
            if newWeatherData == nil {
                print("ERROR: Read or decoding failed for JSON data")
            }
            DispatchQueue.main.async {
                self.weatherData = newWeatherData
            }
        }
        task.resume()
    }
    
    func getTemperatureString() -> String {
        if let weatherData = weatherData {
            return String(format: "%.1f°C", weatherData.main.temp)
        } else {
            return "?°C"
        }
    }
}

#Preview {
    ContentView()
}
