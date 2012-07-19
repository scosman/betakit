require 'test_helper'

class ApiControllerTest < ActionController::TestCase
   test "invalid request invite" do
     initialCount = User.count
     get(:request_invite, {'email' => "test"}, {})
     assert_response 400
     assert User.count == initialCount
     assert @response.body == "false"
   end

   test "valid request invite" do
     initialCount = User.count
     get(:request_invite, {'email' => "test@gmail.com"}, {})
     assert_response :success
     assert User.count == initialCount + 1
     assert @response.body == "true"
     assert User.last.email == "test@gmail.com"
     assert User.last.state = User.STATES.requested
   end


end
