# Sass-Swatch-Colors

Small script that will echo out the colors used in a Sass file with their names and swatches.

## Usage

``` ruby colors.rb -f ~/path/to/_colors.rb > index.html ```

## Thanks

Special thanks to http://causes.github.io/blog/2013/06/06/showing-color-chips-from-sass-variables/ that solved much of the problem.

## @ToDo
- Currently the script does not follow includes, and can fail on darken($color, 20%).
- Does not show color variations in use.
- Cannot parse an entire tree.
- I would like to see the colors arranged better and with more information on usage.