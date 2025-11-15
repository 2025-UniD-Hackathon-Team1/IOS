//
//  Index.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/16/25.
//
import SwiftUI


struct Index: View {
    
    @StateObject private var viewModel: MainViewModel
    @Environment(\.diContainer) private var di
    
    init(viewModel: MainViewModel = MainViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HStack(spacing:1) {
            
            Spacer()
            
            Button(action: {}) {
                Text("현재")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(.mainBrown)
            .foregroundColor(.white)
            .cornerRadius(12, corners: [.topLeft, .topRight])
            
            Button(action: {}) {
                Text("미래")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(.mainBrown)
            .foregroundColor(.white)
            .cornerRadius(12, corners: [.topLeft, .topRight])
            
            Button(action: {}) {
                Text("수면")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(.mainBrown)
            .foregroundColor(.white)
            .cornerRadius(12, corners: [.topLeft, .topRight])
            
            Spacer()
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 10
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}


#Preview {
    Index()
}
