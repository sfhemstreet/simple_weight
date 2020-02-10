# simple_weight

iOS / android app, a simple way to keep track of weight and calories. 

## about

I wanted to checkout Flutter, so this is a simple app to see how to use the framework.

The app tracks daily caloric intake and daily weight, and displays weight/calorie data on a chart, as well as information such as how much weight is lost on average per week, and what average calorie intake is like on weekdays vs weekend, etc.

Its UI only uses Cupertino widgets for an iOS look, and is based on a Tab layout with a single settings page on the root navigator.

For persistant storage of weight and calorie data I used sqflite, an SQLite plugin for flutter, and used Shared Preferences (key-value storage) plugin to store users goal weight and daily calorie target.

For state management the Provider package was super useful and easy, used it's MultiProvider to stream all persistant data.

The chart used to visualize weight and calorie history is a TimeLinechart from the charts_flutter package.


## Getting Started

This utilizes Flutter, if you haven't used Flutter check out the  
[online documentation](https://flutter.dev/docs).


