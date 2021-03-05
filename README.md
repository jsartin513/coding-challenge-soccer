## The Solution

To run the command line application, simply run `ruby generate_soccer_scores.rb` 

This will read the scores from `sample-input.txt` and output results to `default-output.txt`.


To run unit tests, run
`bundle install`
`bundle exec rake spec`

## The Problem

We want you to create a command-line application that reads a listing of game
results for a soccer league as a stream and returns the top teams at
the end of each matchday.

### Input/output

The input and output will be text. To keep things simple a static file will be
used to represent the input stream of game results. Your solution should read
and process game results one at a time by reading the provided sample-input.txt
file, via stdin (pipe or redirect) or as a file path passed as input argument.
Your solution should then output the correct result via stdout to the console.

The input contains results of games, one per line and grouped by matchday. All
teams play exactly once during a matchday, e.g. given a league of six teams,
each matchday would consist of three games. There is no specific delimiter
between matchdays so your application should recognize the start and end of
a matchday. See sample-input.txt as an example.

After reading and processing a game result, if this is the end of a matchday,
your solution should output the top three teams, ordered from most to least
points. If this is not the end of a matchday, your solution should move on to
the next game result. See the expected format specified in expected-output.txt.

You can expect that the input will be well-formed. Bonus points if your
solution handles a few basic error cases.

### The rules

In this league, a draw (tie) is worth 1 point and a win is worth 3 points. A
loss is worth 0 points. If two or more teams among the top three teams have
the same number of points, they should have the same rank and be printed in
alphabetical order. That said, at most three teams should be listed in the
output per matchday.


### Platform support

This runs in a unix-ish environment (OS X). If you choose to use a
compiled language, please keep this in mind. (Dependency on Xcode is acceptable
for objective-c solutions) Please use platform-agnostic constructs where
possible (line-endings and file-path-separators are two problematic areas).

Please email your sponsor at Jane if you have any questions.
