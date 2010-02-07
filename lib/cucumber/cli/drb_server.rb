require 'drb'

module Cucumber
  module Cli

    class DRbServer
      DEFAULT_PORT = 8787

      def self.run
        port ||= ENV["CUCUMBER_DRB"] || DEFAULT_PORT

        puts "Listening for Cucumber requests..."
        DRb.start_service("druby://localhost:#{port}", Cucumber::Cli::DRbServer.new)
        DRb.thread.join
      end

      def run(args, error_stream, out_stream)
        out_stream.puts "Running #{args}"
      end

    end
  end
end
