# Rclipper

Rclipper is a polygon clipping tool implemented in pure ruby. The algorithm is based on "Efficient clipping of arbitrary polygons by Günther Greiner and Kai Hormann". Degeneracy fix by Erich L Foster and James Overfelt. Also thanks to Helder Correia (https://github.com/helderco/univ-polyclip)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rclipper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rclipper

## Usage example

```ruby

require 'rclipper'

a = [[0,0], [100,0], [100,50], [0,50]]
b = [[0,25], [20,100], [75,25], [100,50], [100,0], [0,50]]
c = Rclipper::clip_polygon(a,b)

```
## Contributing

1. Fork it ( https://github.com/[my-github-username]/rclipper/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
