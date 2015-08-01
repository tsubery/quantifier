About
================

This app is the code behind [beemind.me][1], a web app I made to automatically send data to [Beeminder][2].
If you are not familiar with Beeminder, it could be described as "goal tracking with teeth". The basic idea is they take your money if you don't meet the goals you have committed to.

They can automatically gather data from many 3rd party services that track excercise, sleep, productivity, and much more.
This app adds a few more integrations by allowing users to sign in with their Beeminder account to [beemind.me][1] and configure one of the supported integrations.

Scoring Debt
-----
There are many ways to measure productiviy. Beeminder's native support for [Trello][4] counts the daily cards moved from a "todo" list to "done" and expects it to be above predefined threshold per day. When I tried to use this metric I noticed a tendency to focus on short and easy tasks while other tasks were left in the "todo" list indefinitely.
The way [beemind.me][1] measures productivity is with a simple proxy for procrastination. The app assigns one point for each day since the last activity on each card. All the points are summed as the total "debt" score. The goal is to reduce the debt score. Adding a comment, checking a checkbox, or attaching a file to any card will zero its score. The premise is that with enough tiny steps you can complete any task. And of course by incentivizing working on older cards, it ensures no card is left behind.
Similarly, for [pocket][3] score, a point is added for every day an item waits to be read or watched in the list.

Moar integrations
-----
The app can send Beeminder your hourly steps taken from [Google Fit][5] and the count of races you completed from the [Typeracer][6] typing game.

Supported Providers
-----
|Provider        | metric                | 
|----------------|-----------------------|
|[Trello][4]     |Specific board's Debt |
|[Pocket][3]     |Reading list Debt      |
|[Google Fit][5] |Hourly steps           |
|[Typeracer][6]  |Completed games        |

Todo
-----
It coule be interesting to track activity hours from Google Fit.
Another idea I had is to configure an ideal wake up time and have the app report the amount of oversleeping taken from Sleep as Android.
Do you have any suggestions?
Just mention @galtsubery on the [Beeminder forum][7] 



[1]: https://www.beemind.me
[2]: https://www.beeminder.com
[3]: https://www.getpocket.com
[4]: https://www.trello.com
[5]: https://fit.google.com
[6]: https://www.typeracer.com
[7]: http://forum.beeminder.com/

