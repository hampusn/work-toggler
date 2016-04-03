require 'sinatra/base'

module Hampusn
  module WorkToggler
    class Base < Sinatra::Base

      set :root, File.dirname(__FILE__)
      set :sessions, true

      register do
        def protect_with (type)
          condition do
            case type
              when 'basic_auth'
                basic_auth_protected!
              when 'query_auth'
                query_auth_protected!
              else
                throw(:halt, [500, "Invalid auth type.\n"])
            end
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

        def query_auth_protected!
          has_key    = !!params[:auth] && !params[:auth].empty?
          query_auth = params[:auth]
          env_auth   = ENV['ACCESS_AUTH'].unpack("m*").first

          unless has_key && query_auth == env_auth
            throw(:halt, [401, "Oops... you seem to have missed the very unsecure auth key.\n"])
          end
        end
      end

    end
  end
end