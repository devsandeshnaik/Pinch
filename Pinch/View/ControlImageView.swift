//
//  ControlImageView.swift
//  Pinch
//
//  Created by Sandesh Naik on 19/06/23.
//

import SwiftUI

struct ControlImageView: View {
    var icon: String
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 36))
    }
}

struct ControlImageView_Previews: PreviewProvider {
    static var previews: some View {
        ControlImageView(icon: "plus.magnifyingglass")
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
