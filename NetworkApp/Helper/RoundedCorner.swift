//
//  RoundedCorner.swift
//  MobileDesign
//
//  Created by Md Shabbir Alam on 27/03/26.
//

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = 20
    var corners: UIRectCorner = []
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
