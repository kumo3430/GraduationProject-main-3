//
//  TaskCompletionIndicator.swift
//  GraduationProject
//
//  Created by heonrim on 8/8/23.
//

import SwiftUI

struct TaskCompletionIndicatorView: View {
    @State private var selectedTimeFrame: TimeFrame = .week
    @State private var selectedDate: Date = Date()
    @ObservedObject var viewModel: TaskCompletionViewModel = TaskCompletionViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("任務完成指標")
                .font(.system(size: 32, weight: .bold))
                .padding(.top, 20)

            Picker("選擇查看方式", selection: $viewModel.viewingMode) {
                ForEach(ViewingMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 20)

            if viewModel.viewingMode == .byTime {
                TaskCompletionTimeBasedView(selectedTimeFrame: $selectedTimeFrame, selectedDate: $selectedDate, viewModel: viewModel)
            } else {
                TaskCompletionEventBasedView(selectedDate: $selectedDate, viewModel: viewModel)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.blue.opacity(0.05))
    }
}

struct TaskCompletionIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCompletionIndicatorView()
    }
}
