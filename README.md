#  What's Blueprints
Making choices every day, every hour is actually more expensive than it sounds. No wonder so many people start having exactly the same outfits everyday since they don't want to waste a piece of their attention on trivial things like that.
That's where Blueprints come. Blueprints are a way to start collection information of what different days in the month look like and start creating common templates with common patterns by documenting them and having them available to repeat them again another day by making the same choices on clothes, activities, schedules, transportation among other aspects of life.

# Work in progress
I'm using classic vanilla MVVM here with RxSwift. I want to use this project as a way of documenting the standard ways of addressing an app by using MVVM the right way. The codebase right now is still far from being perfect, but we can already grasp an idea of what the intention is.

# Considerations
- Since we're using Storyboards here rather than writing UI programmatically, Dip will solve the problem of injecting dependencies onto controllers correctly by also allowing a clean approach to unit tests for them.
- We're using RxSwift and RxCocoa to address the bi-directional bindings.
- We're using Cocoapods and we don't plan to use SPM soon, since the idea of this project is to also document stantard insdustry practices instead of cutting edge technologies.
- This can't be called a product yet, since it's still lacking its core functionalities, but we're expecting to have a first MVP in the following months.
