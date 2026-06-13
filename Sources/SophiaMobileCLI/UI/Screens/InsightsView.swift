import Foundation

struct InsightsView: View {
    let insightData:InsightModel

    init(insightData:InsightModel){
        self.insightData = insightData
    }

    func render() -> String  {
        VStack([ 
            HStack([
                 Text("INSIGHT:").bold(),
                 Text(insightData.insight).bold().foregroundColor(.green)
            ]),
            HStack([
                 Text("PATTERN:").bold(),
                 Text(insightData.pattern).bold().foregroundColor(.green)
            ]),
            HStack([
                 Text("LEVEL:").bold(),
                 Text(insightData.level).bold().foregroundColor(.green)
            ]),
            HStack([
                 Text("SUGGESTION:").bold(),
                 Text(insightData.suggestion).bold().foregroundColor(.green)
            ]),
            HStack([
                 Text("OBSERVATION:").bold(),
                 Text(insightData.observer_confidence.tostring()).bold().foregroundColor(.green)
            ])
           
            
        ]).render()

    }
}

extension Double {
    func tostring() -> String {
        return String(format: "%.2f", self)
    }
}