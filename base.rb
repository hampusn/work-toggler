require 'sinatra/base'

module Hampusn
  module WorkToggler
    class Base < Sinatra::Base

      set :root, File.dirname(__FILE__)
      set :sessions, true

      register do
        def use_basic_auth (use_basic_auth)
          condition do
            basic_auth_protected!
          end
        end
      end

      helpers do
        def basic_auth_protected!
          unless basic_auth_authorized?
            response['WWW-Authenticate'] = %(Basic realm="Authentication required.")
            throw(:halt, [401, "Oops... we need your login name & password\n"])
          end
        end

        def basic_auth_authorized?
          @auth ||=  Rack::Auth::Basic::Request.new(request.env)

          unless ENV['ACCESS_AUTH'].nil? || ENV['ACCESS_AUTH'].empty?
            admin_auth = ENV['ACCESS_AUTH'].unpack("m*").first.split(/:/, 2)
          end

          @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == admin_auth
        end
      end

    end
  end
end