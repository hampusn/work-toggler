require 'sinatra/base'

# base.rb contains a subclass of Sinatra::Base
require './base'

Dir.glob("controllers/*.rb").each { |r| require_relative r }

module Hampusn
  module WorkToggler
    class App < Hampusn::WorkToggler::Base

      use Hampusn::WorkToggler::Controllers::EntriesController

      # Boot it up!
      run! if __FILE__ == $0
    end
  end
end