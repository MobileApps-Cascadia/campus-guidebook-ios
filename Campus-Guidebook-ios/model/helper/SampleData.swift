//
//  SampleData.swift
//  Campus-Guidebook-ios
//
//  Created by isaak wheeler on 4/30/22.
//

import Foundation
import UIKit                


class SampleData {
    
    // Sample Data for clubs
    let clubPictures: [String] =
    ["clubs_logo-1",
     "dnd_club_logo",
     "engineers_club",
     "japanese_culture_club"]

    let clubTitles: [String] = ["Clubs at Cascadia", "DnD Club", "Engineers Club", "Japanese Culture Club"]
    let clubDescriptions: [String] = [
        "Roll the dice at EAB and CEB's annual Casino Night!",
        "Roll20 until you reach the lands of 5e",
        "The engineering club is open to any student who is interested in science, technology, engineering, and math (STEM). Through hands on activities, members of all skill levels will have the opportunity to design, build, and share engineered projects with other creative problem solvers. Get ready to strengthen your skills, create a collection of projects related to your career, and connect with your peers! Some of the club projects we've undertaken include designing 3d printing models, making a video game with python, and electronic prototyping with Arduino.",
        "The purpose of this club is to provide a comfortable place for the students at Cascadia college to learn and experience Japanese culture together. In our club, we will share traditional Japanese culture such as Japanese calligraphy, origami, karate, etc. together."]
    let clubStartdates: [String] = ["11/11/2023", "08/23/2023", "05/12/2023", "04/07/2023"]
    let clubStartTimes: [String] = ["2:00 - 3:15 PM", "2:00-3:30 PM", "2:00 - 3:15 PM", "2:00-4:00 PM"]
    let clubLocations: [String] = ["ARC1-210", "ARC2-360", "ARC1-210", "ARC2-360"]
    let clubContacts: [String] = ["cascadiaengineers@gmail.com", "cascadiadg@gmail.com", "test@gmail.com", "xyz@gmail.com"]
    
    // Sample Data for events
    let eventPictures: [String] =
    ["https://padlet-uploads.storage.googleapis.com/621406566/f8a534f5b3cd80d89c87fcf7b2bc9392/Casino_Night_Final__11x17in_.png",
     "https://www.cascadia.edu/images_calendar/collegerelations/CCEngineersClub.png",
     "",
     "",
     ""]
    let eventTitles: [String] = ["Events and Advocacy Board", "Engineering Club - Symposium", "Math Club - Weekly Meeting", "Math Club - Weekly Meeting", "Science Club - Weekly Meeting"]
    let eventDescriptions: [String] = ["Roll the dice at EAB and CEB's annual Casino Night!", "The biggest Engineering event of the year", "Meets every other Tuesday at 3:30", "Meets every other Tuesday at 3:30", "Meets every other Tuesday at 3:30"]
    
    let eventStartDate: [String] = ["11/11/2023", "08/23/2023", "05/12/2023", "04/07/2023", "12/16/2023"]
    let eventStartTimes: [String] = ["2:00 - 3:15 PM", "2:00-3:30 PM", "2:00 - 3:15 PM", "2:00-4:00 PM", "4:00-6:00 PM"]
    let eventLocation: [String] = ["47.761121, -122.192806", "47.760536, -122.191381", "Online", "Online", "Online"]
    let eventContacts: [String] = ["cascadiaengineers@gmail.com", "cascadiadg@gmail.com", "test@gmail.com", "xyz@gmail.com", "zyx@gmail.com"]


    // Sample Data for sustainability
    let sustainabilityPictures: [String] =
    ["sustainability_wetlands",
     "sustainability_green_buidlings",
     "sustainability_campus_grounds",
     "sustainability_stormwater_management"]
    let sustainabilityTitles: [String] = ["Wetlands", "Green Buildings", "Campus Grounds", "Stormwater Management"]
    let sustainabilityDescriptions: [String] = [
        "We protect and continue to restore a 58-acre wetland that is one of the biggest floodplain restoration projects completed in the Pacific Northwest in conjunction with UW Bothell. Cascadia classes use the wetland as a living laboratory to study water quality, botany, ecology and wildlife biology. Cascadia students have done wetland stormwater sampling!",
        "Our Global Learning and the Arts building (CC3) achieved Leadership in Energy and Environmental Design (LEED) Platinum  standard for environmental sustainability and we produce clean, renewable energy via solar panels located on our parking garages and rooftops.",
        "Our campus, shared with University of Washington, Bothell, is Certified Salmon Safe and we produce herbs, flowers, fruits and vegetables in our campus Food Forest and Campus Farm using organic practices. We also provide habitat for native pollinators!",
        "Our Campus is a secondary permitee under the Western Washington Phase II Municipal Stormwater Plan.  We manage stormwater with rain gardens, green stormwater infrastructure, signage and education, and working with our 58-acre restored wetland management!  You can see many of our projects by visiting the campus, or photos on our social media!"]
    
}



