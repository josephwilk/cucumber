require "drb/drb"
require 'cucumber/cli/drb_server'
# This code was taken from the RSpec project and slightly modified.

module Cucumber
  module Cli
    class DRbClientError < StandardError ; end

    class DRbClient
      DEFAULT_PORT = 8787

      class << self

        def run(args, error_stream, out_stream, port = nil)
          port ||= ENV["CUCUMBER_DRB"] || DEFAULT_PORT

          hack_to_support_io_streams

          feature_server = DRbObject.new_with_uri("druby://localhost:#{port}")

          error_stream.extend DRb::DRbUndumped
          out_stream.extend DRb::DRbUndumped

          feature_server.run(cloned_args(args), error_stream, out_stream)
        rescue Exception => e
          raise e
        end

        private

        def hack_to_support_io_streams
          begin
            DRb.start_service("druby://localhost:0")
          rescue SocketError
            # Ruby-1.8.7 on snow leopard doesn't like localhost:0 - but just :0
            # seems to work just fine
            DRb.start_service("druby://:0")
          end
        end

        # I have no idea why this is needed, but if the regular args are sent then DRb magically
        def cloned_args(args)
          cloned_args = []
          args.each { |arg| cloned_args << arg }
        end

      end
    end
  end
end
