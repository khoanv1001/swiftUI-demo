//
//  ContentView.swift
//  demo
//
//  Created by Nguyen Viet Khoa on 19/03/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var dragOffset: CGSize = .zero
    @State private var isPlanetInfoShown = false
    @State private var selectedPlanet: Post?
    @State private var zoomScale: CGFloat = 1.0
    @State private var prevOffset: CGPoint = .zero
    @State private var planetPositions: [CGPoint] = []
    @State private var planets: [Post] = []

    let backgroundWidth: CGFloat = UIScreen.main.bounds.width * 2
    let backgroundHeight: CGFloat = UIScreen.main.bounds.height * 1
    let numberOfPlanets = 10
    let gridSize: CGFloat = 100
    let planetSizes: [CGSize] = [
        CGSize(width: 40, height: 40),
        CGSize(width: 30, height: 30),
        CGSize(width: 20, height: 20),
        CGSize(width: 10, height: 10)
    ]

    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation
                        }
                        .onEnded { _ in
                            prevOffset.x += dragOffset.width
                            prevOffset.y += dragOffset.height
                            dragOffset = .zero
                        }
                )
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            setZoomScale(zoomScale + (value - 1) * 0.1)
                        }
                )
                .scaleEffect((zoomScale - 1) * 0.1 + 1)
                .animation(.easeInOut(duration: 0.5), value: zoomScale)

            ForEach(planets, id: \.self) { planet in
//                    Image(planet.imageUrl)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
                    ThumbnailView(post: planet)
                    .frame(width: planet.size.width, height: planet.size.height)
                        .fixedSize(horizontal: true, vertical: true)
                        .position(
                            CGPoint(
                                x: planet.position.x + dragOffset.width + prevOffset.x,
                                y: planet.position.y + dragOffset.height + prevOffset.y
                            )
                        )
                        .gesture(
                            TapGesture()
                                .onEnded {
                                    selectedPlanet = planet
                                    isPlanetInfoShown = true
                                }
                        )
                        .scaleEffect(zoomScale)
                        .animation(.easeInOut(duration: 0.5), value: zoomScale)
            }
            VStack {
                HStack {
                    Button(action: {
                        setZoomScale(zoomScale - 1)
                    }) {
                        Image(systemName: "minus.magnifyingglass")
                            .font(.title)
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                    }
                    Slider(value: $zoomScale, in: 1...5, step: 0.1)
                        .frame(width: 150)
                        .accessibilityAction {
                            print("Zoom scale: \(zoomScale)")
                        }
                    Button(action: {
                        setZoomScale(zoomScale + 1)
                    }) {
                        Image(systemName: "plus.magnifyingglass")
                            .font(.title)
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                    }
                }
                .padding([.leading, .trailing], 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 60)
                        .stroke(Color.gray, lineWidth: 3)
                )
            }
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 100)
            if isPlanetInfoShown {
                CustomDialog(isActive: $isPlanetInfoShown, title: selectedPlanet?.title ?? "default", message: selectedPlanet?.detail ?? "haha", buttonTitle: "Save", action: {})
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            let width = Int(backgroundWidth)
            let height = Int(backgroundHeight)

            let map = createParkingMap(width: width, height: height)
            var usedPositions: Set<[Int]> = []

            for _ in 0..<numberOfPlanets {
                let position = generateUniquePosition(map: map, usedPositions: &usedPositions)
                let point = CGPoint(x: position[0], y: position[1])
                let randomSize = planetSizes.randomElement()!

                planets.append(Post(title: "This is the title", imageUrl: ["post1","post2", "post3", "post4", "post5"].randomElement()!, detail: "Hello, everyone! This is the LONGEST TEXT EVER! I was inspired by the various other on the internet, and I wanted to make my own. So here it is! This is going to be a WORLD RECORD! This is actually my third attempt at doing this. The first time, I didn't save it. The second time, the Neocities editor crashed. Now I'm writing this in Notepad, then copying it into the Neocities editor instead of typing it directly in the Neocities editor to avoid crashing. It sucks that my past two attempts are gone now. Those actually got pretty long. Not the longest, but still pretty long. I hope this one won't get lost somehow. Anyways, let's talk about WAFFLES! I like waffles. Waffles are cool. Waffles is a funny word. There's a Teen Titans Go episode Hello, everyone! This is the LONGEST TEXT EVER! I was inspired by the various other on the internet, and I wanted to make my own. So here it is! This is going to be a WORLD RECORD! This is actually my third attempt at doing this. The first time, I didn't save it. The second time, the Neocities editor crashed. Now I'm writing this in Notepad, then copying it into the Neocities editor instead of typing it directly in the Neocities editor to avoid crashing. It sucks that my past two attempts are gone now. Those actually got pretty long. Not the longest, but still pretty long. I hope this one won't get lost somehow. Anyways, let's talk about WAFFLES! I like waffles. Waffles are cool. Waffles is a funny word. There's a Teen Titans Go episode Hello, everyone! This is the LONGEST TEXT EVER! I was inspired by the various other on the internet, and I wanted to make my own. So here it is! This is going to be a WORLD RECORD! This is actually my third attempt at doing this. The first time, I didn't save it. The second time, the Neocities editor crashed. Now I'm writing this in Notepad, then copying it into the Neocities editor instead of typing it directly in the Neocities editor to avoid crashing. It sucks that my past two attempts are gone now. Those actually got pretty long. Not the longest, but still pretty long. I hope this one won't get lost somehow. Anyways, let's talk about WAFFLES! I like waffles. Waffles are cool. Waffles is a funny word. There's a Teen Titans Go episode", position: point, size: CGSize(width: 60, height: 60)))
            }
        }
    }
    func adjustedPosition(for position: CGPoint, with offset: CGSize) -> CGPoint {
      return CGPoint(x: position.x + offset.width, y: position.y + offset.height)
    }

    func setZoomScale(_ scale: CGFloat) {
        zoomScale = max(min(scale, 5), 1)
    }

    func generateUniquePosition(map: [Int: [Int: [Int]]], usedPositions: inout Set<[Int]>) -> [Int] {
        var position: [Int] = []

        repeat {
            position = getRandomParkingSpace(parkingMap: map)
        } while usedPositions.contains(position)

        usedPositions.insert(position)
        return map[position[0]]![position[1]]!
    }


    func createParkingMap(width: Int, height: Int) -> [Int: [Int: [Int]]] {
        let size = Int(gridSize)
        let rows = height / size
        let cols = width / size

        var parkingMap = [Int: [Int: [Int]]]()

        for i in 0..<rows {
            for j in 0..<cols {
                let x = j * size
                let y = i * size

                if parkingMap[i] == nil {
                    parkingMap[i] = [Int: [Int]]()
                }
                parkingMap[i]?[j] = [x, y]
            }
        }

        return parkingMap
    }

    func getRandomParkingSpace(parkingMap: [Int: [Int: [Int]]]) -> [Int] {
        let randRow = Int.random(in: 0..<parkingMap.count)
        let row = Array(parkingMap.keys)[randRow]
        let randCol = Int.random(in: 0..<parkingMap[row]!.count)

        return [randRow, randCol]
    }
}


struct Post: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let imageUrl: String
    let detail: String
    let position: CGPoint
    let size: CGSize
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
}



#Preview {
    ContentView()
}
