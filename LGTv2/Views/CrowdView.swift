//
//  CrowdView.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 8/27/25.
//

import SwiftUI



struct CrowdView: View {
    
    @Environment(MapTabViewModel.self) var mapTabViewModel
    @State var skyIcon = ""
    
    var body: some View {
        expectedCrowds
    }
}

extension CrowdView {
    
    var expectedCrowds: some View {
        VStack (spacing: 0) {
            
            if mapTabViewModel.crowds.isEmpty {
                Image(systemName: "person.fill.questionmark")
                    .font(.system(size: 32))
                    .scaledToFit()
                    .frame(width: 48, height: 49)
                    .padding(.trailing)
                    .offset(y: -8)
            } else {
                ForEach(mapTabViewModel.crowds) {crowd in
                    switch crowd.level {
                    case "Low":
                        Image(systemName: "person.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 32))
                            .scaledToFit()
                            .frame(width: 48, height: 49)
                            .padding(.trailing)
                            .offset(y: -8)
                    case "Moderate":
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 32))
                            .scaledToFit()
                            .frame(width: 48, height: 49)
                            .padding(.trailing)
                            .offset(y: -8)
                    case "Heavy":
                        Image(systemName: "person.3.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 32))
                            .scaledToFit()
                            .frame(width: 48, height: 49)
                            .padding(.trailing)
                            .offset(y: -8)
                    default:
                        Image(systemName: "person.fill.xmark")
                            .font(.system(size: 32))
                            .scaledToFit()
                            .frame(width: 48, height: 49)
                            .padding(.trailing)
                            .offset(y: -10)
                    }
                }
            }
        }
    }
}

#Preview {
    CrowdView()
        .environment(MapTabViewModel())
}
