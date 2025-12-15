import SwiftUI

struct ParticleView: View {

    // MARK: - Properties

    let symbol: String
    let color: Color
    let geometry: GeometryProxy

    @State private var offset: CGSize = .zero
    @State private var opacity = 1.0
    @State private var scale: CGFloat = 0.1
    @State private var rotation: Double = 0

    private let startX: CGFloat
    private let startY: CGFloat
    private let velocityX: CGFloat
    private let velocityY: CGFloat
    private let rotationSpeed: Double

    // MARK: - Lifecycle

    init(
        symbol: String,
        color: Color,
        geometry: GeometryProxy
    ) {
        self.symbol = symbol
        self.color = color
        self.geometry = geometry

        let centerX = geometry.size.width / 2
        let centerY = geometry.size.height / 2

        startX = centerX + .random(in: -50...50)
        startY = centerY + .random(in: -30...30)

        velocityX = .random(in: -150...150)
        velocityY = .random(in: -200...(-50))

        rotationSpeed = .random(in: -360...360)
    }

    // MARK: - Public

    var body: some View {
        Image(systemName: symbol)
            .font(.system(size: 24))
            .foregroundStyle(color)
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
            .offset(offset)
            .position(x: startX, y: startY)
            .onAppear {
                withAnimation(.easeOut(duration: 2.0)) {
                    offset = CGSize(
                        width: velocityX,
                        height: velocityY
                    )
                    opacity = 0.0
                    scale = 1.5
                    rotation = rotationSpeed
                }
            }
    }
}
