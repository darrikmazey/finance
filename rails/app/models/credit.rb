require 'account.rb'

class Credit < Account
end

# so that credit knows Client < Credit
require 'client.rb'
