# Mzr::Api::Error
Render a structured and dynamic JSON response body to client applications.
Creates a base class that other errors can be inherit from to make error rendering easier errors uniform and easy

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mzr-api-error'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mzr-api-error

## Example Response

```json
{
    "error": {
        "trace_id": "6CA01AF9E592595F",
        "type": "IterationError",
        "message": "There was an issue processing the Iteration",
        "error_subcode": "IterationInvalid",
        "detail": "The Iteration can not be saved. Invalid and missing data.",
        "sub_errors": [
            {
                "pointer": "iteration",
                "detail": "Iteration can't be blank"
            },
            {
                "pointer": "timezone",
                "detail": "Timezone can't be blank"
            },
            {
                "pointer": "exam_id",
                "detail": "Exam id is invalid"
            }
        ]
    }
}
```

## Usage
There is a method automatically created for each each class that inherits from MZR::ApiError. The method is preprended with 'raise'.
```ruby
  raise_reservation_error
```

You can also pass in options to your method for a more robust response:
```ruby
  raise_reservation_error(controller: self, subcode: :reservation_invalid, object: @reservation)
```

## Setup
Configure the gem. For the gem to recognize the descendant classes you have to provide the name space the errors are under.
```ruby
Mzr::Api::Error.configure do |config|
  config.namespaces = ['Api::V1::Errors']
  config.trace_id_length = 16
end
```

Create a new Error that inherits from the ApiError class. The class needs to be under the configured name space. NOTE: The ``message`` method must be implemented.

```ruby
module Api
  module V1
    module Errors
      class ReservationError < ::Mzr::ApiError
        def message
          "There was an issue processing the reservation"
        end

        def subcodes
          super({
            reservation_invalid: "The Reservation number provided is not in the proper format.",
            reservation_expired: 'The testing window has expired for this reservation', 
          })
        end
      end
    end 
  end 
end 
```

Include the ErrorEngine module in your base api class
```ruby
include ::Mzr::Api::ErrorEngine
```

Next rescue all your api errors. This method could be in your base api class.
```ruby
rescue_from 'Mzr::ApiError' do |exception|
  render json: exception.render, status: exception.status
end
```

