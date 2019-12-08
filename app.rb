require 'optparse'
require 'ostruct'
require 'require_all'

def gather_cmd_line_opts
    options = OpenStruct.new
    OptionParser.new do |opt|
      opt.on('--jsondir JSON_DIRECTORY_PATH', 'The directory containing the initial json files') { |o| options.jsondir = o }
      options.jsondir ||= __dir__
    end.parse!
    options
end

# will not run if this file was loaded or required
if __FILE__==$0
    require_all __dir__+'/src'

    opts = gather_cmd_line_opts
    Navigator.new(Loader.load_json_data(opts.jsondir)).run

    puts 'bye!'
end
