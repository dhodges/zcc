require 'json'

class Loader
    @@types = ['organization', 'user', 'ticket']

    class << self
        def load_json_data(dir=__dir__+'/..')
        {}.tap do |hash|
            @@types.each {|name| hash[name] = JSON.parse(File.read "#{dir}/#{name}s.json")}
        end

        # catching errors means: never having to see a stacktrace
        rescue StandardError => err
            puts "\nERROR: #{err.message}"
            system_exit
        end

        # implemented as a separate method to help when testing
        def system_exit
            exit 1
        end
    end
end