#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'
require 'require_all'
require 'ruby-prof'

def gather_cmd_line_opts
    options = OpenStruct.new
    OptionParser.new do |opt|
      opt.on('--jsondir JSON_DIRECTORY_PATH', 'The directory containing the initial json files') { |o| options.jsondir = o }
      options.jsondir ||= __dir__
      opt.on('--profile', 'capture profiling stats') { |o| options.profile = true }
    end.parse!
    options
end

# will not run if this file was loaded or required
if __FILE__==$0
    require_all __dir__+'/src'

    opts = gather_cmd_line_opts
    RubyProf.start if opts.profile

    at_exit do
      if opts.profile
        result = RubyProf.stop
        printer = RubyProf::GraphHtmlPrinter.new(result)
        printer.print(File.new __dir__+'/profile.html', 'w')
      end
    end

    Navigator.new(Loader.load_json_data(opts.jsondir)).run

    puts 'bye!'
end
