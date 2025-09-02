//
//  CrowdView.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 8/27/25.
//

import SwiftUI



struct CrowdView: View {
    
    @Environment(CrowdModel.self) var crowdModel
    @State var dataService:DataService = DataService()
    @State var skyIcon = ""
    
    var body: some View {
        expectedCrowds
    }
}

extension CrowdView {
    
    var expectedCrowds: some View {
        VStack (spacing: 0) {
            
            if crowdModel.crowds.isEmpty {
                Image(systemName: "person.fill.questionmark")
                    .font(.system(size: 24))
                    .scaledToFit()
                    .frame(width: 48, height: 49)
                    .padding(.trailing)
            } else {
                ForEach(crowdModel.crowds) {crowd in
                    switch crowd.level {
                    case "Low":
                        Image(systemName: "person.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 24))
                            .scaledToFit()
                            .frame(width: 48, height: 49)
                            .padding(.trailing)
                    case "Moderate":
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 24))
                            .scaledToFit()
                            .frame(width: 48, height: 49)
                            .padding(.trailing)
                    case "Heavy":
                        Image(systemName: "person.3.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 24))
                            .scaledToFit()
                            .frame(width: 48, height: 49)
                            .padding(.trailing)
                    default:
                        Image(systemName: "person.fill.xmark")
                            .font(.system(size: 24))
                            .scaledToFit()
                            .frame(width: 48, height: 49)
                            .padding(.trailing)
                    }
                }
            }
        }
    }
}

#Preview {
    CrowdView()
        .environment(EventModel())
        .environment(CrowdModel())
}
