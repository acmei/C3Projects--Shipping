Anita & Jeri - Team FedAx
- don't have to integrate tracking information, but if an API returns it, we should add that info for the user
- may have to add functionality to betsy to get a weight for a product
  - items could have size attributes, which determine shipping characteristics
  - then you have a routine to figure out what that total would be
- add a column to account for carrier (maybe also tracking number?)
- checkout flow changes:
  - if user hasn't already estimated shipping costs, display a confirmation page that shows the adjusted price with shipping costs included
  - allow the user to click an estimate shipping button in the cart
    - to generate a form that will get the required info for calculating shipping
    - and then display updated shipping cost / total for order including shipping costs
- model in Shipping API to cache shipping results
- __once a user picks something, make a second API call back to FedAx to say, hey, the user picked this one.__
  - you don't have to track the ones they don't pick.

- spinning up two servers.
  - `rails s` starts a server on 3000
  - `rails s -p 3001` starts a server or 3001

shipping providers:
- kunika - CD/DVD manufacturer and shipper. __not just shipping__ & _probably not a viable shipping option_.

sellers
- need shipment origin location (country, state / province, city, zipcode)

products
- need size information (weight, dimensions)

  ActiveShipping::Package.new( 100,                  # 100 grams
                               [93,10],              # 93 cm long, 10 cm diameter
                               :cylinder => true),   # cylinders have different volume calculations

  ActiveShipping::Package.new( 7.5 * 16,             # 7.5 lbs, times 16 oz/lb.
                               [15, 10, 4.5],        # 15x10x4.5 inches
                               :units => :imperial)  # not grams, not centimetres

# Shipping!
Build a stand-alone shipping service API that calculates estimated shipping cost for an order from another team's bEtsy application.

## Learning Goals
- Develop the ability to read 3rd party code
- APIs
    - design
    - build
    - test
- Continue working with JSON
- Revisit
    - HTTP interactions
    - Testing of 3rd party services
- Increased confidence in working with 3rd party APIs

## Guidelines
- Practice TDD to lead the development process for Models and Controllers
- Create user stories and keep the stories up-to-date throughout the project
- Deploy on Heroku
- Shipping API will communicate with the bEtsy app via JSON
- Integrate the [Active Shipping](https://github.com/Shopify/active_shipping) gem to do shipping-specific logic for you

## Project Baseline
When you've accomplished all of the baseline requirements, please issue a PR back to the bEtsy team's fork. We will review and merge your baseline, but you don't need to wait for that to happen before helping your classmates and moving on to the project requirements.

### The baseline requirements are...
- a ruby-gemset and ruby-version.
- a new rails 4.2.2 application.
- [rspec](https://github.com/rspec/rspec-rails) setup in document format (hint: use a .rspec config file and the `rspec_rails` gem)
- [factory_girl](https://github.com/thoughtbot/factory_girl_rails) included and set up to work with rspec
- code coverage reporting
- fork the repo from the original bEtsy team's fork
  - your team will work from branches and issue PRs back to this fork rather than the project master
- create a preliminary Heroku deployment of the bEtsy project
- review bEtsy code to come up with a basic understanding of the current checkout user flow
  - feel free to ask the "original" bEtsy team questions, but be sure you are prepared to ask them specific questions. Assume the original developers are on a new team now and are just as busy working on new work as you are.

## Expectations
Given shipping addresses and a set of packages, generate a quote for the cost of shipping for these items for a given shipper.

## Requirements
### Technical Requirements
#### Your API will:
- Respond with JSON and proper HTTP response codes  
- Allow Users to get shipping cost quotes for different delivery types  
- Allow Users to get a cost comparison of two or more shippers  
- Log all requests and their associated responses such that an audit could be conducted  
- Have appropriate error handling:
  - When a User's request is incomplete, return an appropriate error
  - When a User's request does not process in a timely manner, return an appropriate error

#### Your bEtsy application will:
- Integrate packaging estimates into the checkout workflow to be able to utilize the shipping API
- Present the relevant shipping information to the user during the checkout process
  - Cost
  - Delivery estimate
  - Tracking information (when available)

### Testing
- 95% test coverage for all API Controller routes, Model validations, and Model methods

### Added Fun!
- Do some refactoring of the bEtsy project you're working on
- Find the seam in bEtsy app between the shopping and payment processing, and build a payment processing service
