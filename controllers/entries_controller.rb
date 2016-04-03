# Entries Controller

require 'sinatra/json'
require 'togglv8'

module Hampusn
  module WorkToggler
    module Controllers
      class EntriesController < Hampusn::WorkToggler::Base

        def toggle_api
          @toggl_api ||= TogglV8::API.new(ENV['TOGGL_API_TOKEN'])
        end

        post '/entries/toggle', protect_with: 'query_auth' do
          result = {
            status: "success"
          }

          begin
            current_entry = toggle_api.get_current_time_entry  
            if !current_entry.nil? && current_entry.has_key?('id')
              result[:action] = "stop"
              result[:data] = toggle_api.stop_time_entry(current_entry['id'])
            else
              result[:action] = "start"
              result[:data] = toggle_api.start_time_entry({
                'pid' => params[:pid],
                'description' => params[:description]
              })
            end
          rescue Exception => e
            result[:status] = "error"
            result[:message] = e.message
          end

          json result
        end

      end
    end
  end
end