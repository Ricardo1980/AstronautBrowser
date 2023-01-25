Several notes about this app.

I used Xcode 14.2 and iOS 16.2

The app has not been localised, that's out of scope.
However, the date of birth of every astronaut was localised properly according to the current device's locale.
That's because some regions have month and day reversed and it can be confusing if this is not properly localised.

Unit testing: There are a lot of unit tests across the app in different layers, but not all of them, the reason is lack of time.

UI testing: No UI testing was added, doing this properly requires some time.

Accessibility: No accessibility was added, as this is out of scope. In any case, SwiftUI adds VoiceOver support automatically. 
If something does not work well, using some easy SwiftUI modifiers everything can be done.

Architecture: I used VMMV. The view models expose a state that changes when some input is received. Examples of input: screen appears, bottom of the list is reached (so we request the next page)...
The state is exposed using @Published, so SwiftUI will repaint what is required when the states changes, automatically.
Internally, I use Combine for the view models logic.
The networking layer also uses Combine.
For a such a simple app, perhaps async await is a better choice, but I still have to learn that.

Navigation: App's navigation when using SwiftUI is debatable. There is no a standard way. In this case, I am using a new approach that is exxplain in this course:
https://www.pointfree.co/collections/swiftui/navigation
With that approach, navigation is driven by data in the view models (and not in the views), which means we can implement any possible combination or hierarchy of screens and go there programatically using universal links.
The explanation is that when using the .sheet modifier, we can use a bool or one optional item. This means we can also very easily represent invalid states and requires a lot of code.
Now we can represent the screen we want to present using an optinal enumeration with associated values. No more invalid states.
To achieve that, we use a new concept, CasePath, which is like KeyPath but for enumarations.
That's why the app has one dependency:
https://github.com/pointfreeco/swiftui-navigation
In any case, that logic can be achieve using Binding but the code is very ugly and long. In fact, the course explains how to do that.

Design: There is no design system or amazing art. I am not a designer.
Everything about fonts, colors, spacing, iconografy is hardcoded.
However, I generated the app's icon using MidJourney, with just the following prompt: "astronaut portrait, cartoon, app icon"
