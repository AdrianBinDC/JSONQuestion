import Foundation
import PlaygroundSupport

/*
 Code adapted from:
 https://gist.github.com/marslin1220/6d4774b56a34dd9b32ced1b9d3d60a4f
 */

// https://stackoverflow.com/questions/52677119/how-to-use-nested-json-with-structs-in-swift
struct Holiday: Codable {
    let responseCode, responseMsg: String
    let holidayCount: Int
    let holidays: [HolidayElement]
    
    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case responseMsg = "response_msg"
        case holidayCount = "holiday_count"
        case holidays
    }
}
struct HolidayElement: Codable {
    let month: String
    let image: String
    let details: [Detail]
}
struct Detail: Codable {
    let title, date, day: String
    let color: Color
}
enum Color: String, Codable {
    case b297Fe = "#B297FE"
    case e73838 = "#E73838"
    case the0D8464 = "#0D8464"
}

/*
 Code adapted from:
 https://gist.github.com/marslin1220/6d4774b56a34dd9b32ced1b9d3d60a4f
 */

URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
PlaygroundPage.current.needsIndefiniteExecution = true

// Refer to the example: https://grokswift.com/simple-rest-with-swift/
let todoEndpoint: String = "http://mahindralylf.com/apiv1/getholidays"
guard let url = URL(string: todoEndpoint) else {
    print("Error: cannot create URL")
    exit(1)
}

let session = URLSession.shared
let urlRequest = URLRequest(url: url)

let task = session.dataTask(with: urlRequest) { (data, response, error) in
    
    // check for any errors
    guard error == nil else {
        print("error calling GET on /todos/1")
        print(error!)
        return
    }
    
    // make sure we got data
    guard let responseData = data else {
        print("Error: did not receive data")
        return
    }
    
    // check the status code
    guard let httpResponse = response as? HTTPURLResponse else {
        print("Error: It's not a HTTP URL response")
        return
    }
    
    
    // Reponse status
    print("Response status code: \(httpResponse.statusCode)")
    print("Response status debugDescription: \(httpResponse.debugDescription)")
    print("Response status localizedString: \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
    
    // parse the result as JSON, since that's what the API provides
    do {
        let jsonResponse = try JSONDecoder().decode(Holiday.self, from: responseData)
        print(jsonResponse.holidays[0].details)
    } catch  {
        print("error trying to convert data to JSON")
        return
    }
    
    PlaygroundPage.current.finishExecution()
}
task.resume()
