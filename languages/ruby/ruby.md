# Ruby

## Visual Studio Code

* Install the `Ruby` extension.
* Install the `Ruby Solargraph` extension (and gem).
  * https://marketplace.visualstudio.com/items?itemName=castwide.solargraph
  * `gem install solargraph solargraph-rails`


## bundler

```shell
# Install all gems as specified in Gemfile.lock or Gemfile if .lock does not exist

$ bundle install


# Executes a command in the context of a bundle, making all gems available to
# `require` in ruby programs.
#
# It's generally safer to run programs using `bundle exec` to ensure you're using
# the gems specified in the project

$ bundle exec rspec spec/my_spec.rb

```


## gem


## rspec

```ruby

#
# describe and context create "context" classes under the hood.
#
# it blocks (called "examples")  are evaluated in an instance
# of it's parent context class.
#
RSpec.describe "something" do

  # Before and after hooks execute arbitrary code before
  # and/or after the body of a context (:all) or example (:each)
  before(:all) {
  }

  before(:each) {
  }

  # use let (lazy) and let! (eager) to define memoized helper methods
  # The value will be cached across multiple calls within an example.
  # NOTE: helper methods are invoked before *each* example, not *all*
  # examples.
  let(:count): { $count += 1 }
  
  context "in one context" do
    it "does one thing" do
    end
  end
  context "in another context" do
    it "does another thing" do
    end
  end
end

```

```shell

# Run all tests
$ bundle exec rake spec

# Individual test or pattern of tests
$ bundle exec rspec --color --pattern spec/services/\*\*/\*_spec.rb
$ bundle exec rspec --color spec/services/flight_plan/v2/service_spec.rb

```
