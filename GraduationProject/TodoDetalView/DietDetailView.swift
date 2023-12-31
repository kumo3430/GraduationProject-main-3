//
//  AddDietView.swift
//  GraduationProject
//
//  Created by heonrim on 8/8/23.
//

import SwiftUI

struct DietDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dietStore: DietStore
    @Binding var diet: Diet
    
    let diets = [
        "減糖", "多喝水", "少油炸", "多吃蔬果"
    ]
    
    @State private var isRecurring = false
    @State private var selectedFrequency = 1
    @State private var recurringOption = 1
    @State private var recurringEndDate = Date()
    
    @State var messenge = ""
    @State var isError = false
    
    let dietsUnitsByType: [String: [String]] = [
        "減糖": ["次"],
        "多喝水": ["豪升"],
        "少油炸": ["次"],
        "多吃蔬果": ["份"]
    ]
    
    let dietsPreTextByType: [String: String] = [
        "減糖": "少於",
        "多喝水": "至少",
        "少油炸": "少於",
        "多吃蔬果": "至少"
    ]
    
    struct TodoData : Decodable {
        var todo_id: Int
        var label: String
        var reminderTime: String
        var dueDateTime: String
        var todoNote: String
        var message: String
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text(diet.title)
                        .foregroundColor(Color.gray)
                    Text(diet.description)
                        .foregroundColor(Color.gray)
                }
                Section {
                    HStack {
                        
                        Image(systemName: "tag.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit) // 保持圖示的原始寬高比
                            .foregroundColor(.white) // 圖示顏色設為白色
                            .padding(6) // 確保有足夠的空間顯示外框和背景色
                            .background(Color.yellow) // 設定背景顏色
                            .clipShape(RoundedRectangle(cornerRadius: 8)) // 設定方形的邊框，並稍微圓角
                            .frame(width: 30, height: 30) // 這裡的尺寸是示例，您可以根據需要調整
                        Spacer()
                        TextField("標籤", text: $diet.label)
                            .onChange(of: diet.label) { newValue in
                                diet.label = newValue
                            }
                    }
                }
                Section {
                    HStack {
                        Image(systemName: "calendar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        Text("選擇時間")
                        Spacer()
                        Text(formattedDate(diet.startDateTime))
                            .foregroundColor(Color.gray)
                    }
                    HStack {
                        Image(systemName: "bell.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.purple)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        DatePicker("提醒時間", selection: $diet.reminderTime, displayedComponents: [.hourAndMinute])
                            .onChange(of: diet.reminderTime) { newValue in
                                diet.reminderTime = newValue
                            }
                    }
                }
                Section {
                    HStack {
                        Image(systemName: "fork.knife.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit) // 保持圖示的原始寬高比
                            .foregroundColor(.white) // 圖示顏色設為白色
                            .padding(6) // 確保有足夠的空間顯示外框和背景色
                            .background(Color.red) // 設定背景顏色
                            .clipShape(RoundedRectangle(cornerRadius: 8)) // 設定方形的邊框，並稍微圓角
                            .frame(width: 30, height: 30) // 這裡的尺寸是示例，您可以根據需要調整
                        Text("目標")
                        Spacer()
                        Text(diet.recurringUnit)
                            .foregroundColor(Color.gray)
                        Text(diet.selectedDiets)
                            .foregroundColor(Color.gray)
                       
                        if let preText = dietsPreTextByType[diet.selectedDiets] {
                            Text(preText)
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                        } else {
                            Text("少於")
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                        }
                        Text(String(diet.dietsValue))
                            .foregroundColor(Color.gray)
                        if let primaryUnits = dietsUnitsByType[diet.selectedDiets] {
                            Text(primaryUnits.first!)
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                        } else {
                            Text("次")
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                        }
                    }
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        DatePicker("結束日期", selection: $diet.dueDateTime, displayedComponents: [.date])
                            .onChange(of: diet.dueDateTime) { newValue in
                                diet.dueDateTime = newValue
                            }
                    }
                }
                TextField("備註", text: $diet.todoNote)
                    .onChange(of: diet.todoNote) { newValue in
                        diet.todoNote = newValue
                    }
            }
            .navigationBarTitle("飲食修改")
            .navigationBarItems(
                                trailing:  Button(action: {
                reviseDiet()
                if diet.label == "" {
                    diet.label = "notSet"
                }
            }) {
                Text("完成")
                    .foregroundColor(.blue)
            })
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:MM"
        return formatter.string(from: date)
    }
    
    func reviseDiet() {
        class URLSessionSingleton {
            static let shared = URLSessionSingleton()
            let session: URLSession
            private init() {
                let config = URLSessionConfiguration.default
                config.httpCookieStorage = HTTPCookieStorage.shared
                config.httpCookieAcceptPolicy = .always
                session = URLSession(configuration: config)
            }
        }
        
        let url = URL(string: "http://127.0.0.1:8888/reviseTask/reviseStudy.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body: [String: Any] = [
            "id": diet.id,
            "label": diet.label,
            "reminderTime": formattedTime(diet.reminderTime),
            "dueDateTime": formattedDate(diet.dueDateTime),
            "todoNote": diet.todoNote
        ]
        
        print("reviseDiet - body:\(body)")
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        URLSessionSingleton.shared.session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("reviseDiet - Connection error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("reviseDiet - HTTP error: \(httpResponse.statusCode)")
            }
            else if let data = data{
                let decoder = JSONDecoder()
                do {
                    print("reviseDiet - Data : \(String(data: data, encoding: .utf8)!)")
                    let todoData = try decoder.decode(TodoData.self, from: data)
                    if (todoData.message == "User revise Study successfully") {
                        print("============== reviseDiet ==============")
                        print(String(data: data, encoding: .utf8)!)
                        print("addDiet - userDate:\(todoData)")
                        print("事件id為：\(todoData.todo_id)")
                        print("事件種類為：\(todoData.label)")
                        print("提醒時間為：\(todoData.reminderTime)")
                        print("結束日期為：\(todoData.dueDateTime)")
                        print("事件備註為：\(todoData.todoNote)")
                        print("reviseDiet - message：\(todoData.message)")
                        isError = false
                        DispatchQueue.main.async {
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        print("============== reviseDiet ==============")
                    } else {
                        isError = true
                        print("reviseDiet - message：\(todoData.message)")
                        messenge = "建立失敗，請重新建立"                    }
                } catch {
                    isError = true
                    print("reviseDiet - 解碼失敗：\(error)")
                    messenge = "建立失敗，請重新建立"
                }
            }
        }
        .resume()
    }
}
struct DietDetailView_Previews: PreviewProvider {
    static var previews: some View {
        @State var diet = Diet(id: 001,
                               label:"我是標籤",
                               title: "英文",
                               description: "背L2單字",
                               startDateTime: Date(),
                               selectedDiets: "減醣",
                               dietsValue: 1,
                               recurringUnit: "每週",
                               recurringOption:2,
                               todoStatus: false,
                               dueDateTime: Date(),
                               reminderTime: Date(),
                               todoNote: "我是備註")
        DietDetailView(diet: $diet)
    }
}
