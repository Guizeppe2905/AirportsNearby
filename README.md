# Airports - Аэропорты
[![Typing SVG](https://readme-typing-svg.herokuapp.com?font=Fira+Code&pause=1000&color=2A8659&width=435&lines=%D0%9F%D1%80%D0%BE%D0%BB%D0%BE%D0%B6%D0%B8+%D0%BF%D1%83%D1%82%D1%8C+%D0%BD%D0%B0%D1%81%D1%82%D0%BE%D1%8F%D1%89%D0%B5%D0%B3%D0%BE+%D0%94%D0%B6%D0%B5%D0%B4%D0%B0%D1%8F)](https://git.io/typing-svg)
***
Приложение позволяет искать ближайший аэропорт или все аэропорты в городе, указывает общую информацию и вычисляет растояние от пользователя до выбранного аэропорта. Также прокладывает маршрут к нему.
***

### Quick testing
***
<img align="right" src="https://ie.wampi.ru/2022/06/24/SNIMOK-EKRANA-2022-06-24-V-17.29.10.png" alt="drawing" style="width:250px;"/> The pet-project has two modes: Business & Private User. The quickest way to test it would be:
1. Proceed first to the User Mode, have a quick view of defaults settings. At Profile folder one can personalize the App. Once you choose the field you work at (Occupation folder), the ads below will be changed. Every time you provide more info at Hobbies, Food, Pets etc. folders, the ads at the scroll view below will get more and more relevant to your personal interests and needs. Account form has some basic info such as email&password to test Sign-In menu. The last folder named Balance calculates the number of ads watched and the total amount earned. 
2. Proceed to Business Mode, here you can imagine that you need to place an ad for your target audience. Very quick and short forms - Profile & Create your ad - will help you to set personalized advertising (Remember the industry you have chosen for your company). Check the preview of your ad at "Watch your ad"
3. Go back to Private User Mode. If you indicate the same industry at Occupation folder that you have chosen at Business mode before, and run the ad below after that, the user will get the Company's personalized ad & info. 
Those are main and basic stuff to test, but if you have time there are more things to test.
***

### Description
***
#### Mission
YoDaBox mission is to help both users and companies to meet each other interests in the most convinient and efficient way. 
People get tired of useless and annoying ads, spam etc. But imagine if you get paid for watching ads, moreover, all ads are totally relevant to your job, hobbies, status, pets, travels etc...
Also companies are much more interested in people who really watch / read / listen to the provided information. Business is still spending money on phone calls, mailing, posting ads, even if the data base is quite cold. Intead of paying for such advertising, one can use YoDaBox and always be sure that your ad reaches your potential customer.
#### Demo
This pet-project is just a demo, that's why it proposes you a set of videos which can be transformed into an ad. The demo is set for comfortable and quick testing and to get a first glance of the project. 
User mode can be personalized in 6 fields - Occupation, Travel, Pets, Food, Hobbies, Other Interests & Needs. If you select any option, the App will propose you a new set of ads relevant to your info. 
By default all ads inform you that you can use them as a template for advertising your Company. Once settings at Business Mode are changed, the ad gets changed too and provides your information - Company's name, Brand name, Slogan, website.
<p align="center">
  <img src="https://media.giphy.com/media/ibPBFAAwnvCfzUfavN/giphy.gif" alt="animated"> 

***
### Stack
***
Private User Mode is made fully using SwiftUI, and Business Mode is made using UIKit. That was made on perpose to show both possibilities. The code is based on MVVM pattern. UserDefaults were enough for saving all user settings as it doesn't consist of any big data. Interface & design was planned in the way to use many animation elements and graphics. Layouts were chosen from Figma, some images transformed by Canva. Libraries used: UIKit, SwiftUI, SnapKit, Foundation, AVKit, Combine, AVFoundation.
<p align="center">
<img src="https://media.giphy.com/media/TC59t6BDltvM82ESoY/giphy.gif" alt="animated" />

