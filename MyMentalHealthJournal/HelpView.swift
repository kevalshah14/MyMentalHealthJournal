//
//  HelpView.swift
//  MyMentalHealthJournal
//
//  Created by Keval Shah on 4/22/23.
//

import SwiftUI
import MapKit
import CoreLocation
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var mapView: MKMapView
    var annotations: [MKPointAnnotation]

    func makeUIView(context: Context) -> MKMapView {
        mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.removeAnnotations(view.annotations)
        view.addAnnotations(annotations)
    }
}

struct HelpView: View {
    @StateObject var helpViewModel = HelpViewModel()
    @State private var city: String = ""

    var body: some View {
        ZStack {
            MapView(mapView: helpViewModel.mapView, annotations: helpViewModel.searchResults)
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    VStack {
                        HStack {
                            TextField("Enter city name", text: $city)
                                .padding(12)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                                .padding(.horizontal)
                                .overlay(
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.gray)
                                        Spacer()
                                    }.padding(.horizontal, 8)
                                )
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(10)
                                .padding(.horizontal)
                                .padding(.top, 20)
                            
                            Button(action: {
                                helpViewModel.searchNearbyPlaces(in: city)
                            }) {
                                Text("Search")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 24)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }
                            .padding(.top, 20)
                            .padding(.trailing)
                        }
                        Spacer()
                    }
                )
        }
        .navigationBarTitle("Help", displayMode: .inline)
    }
}



struct SearchBar: UIViewRepresentable {
    @Binding var text: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }

    class Coordinator: NSObject, UISearchBarDelegate {
        let parent: SearchBar

        init(_ parent: SearchBar) {
            self.parent = parent
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            parent.text = searchText
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
