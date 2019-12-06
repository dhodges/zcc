require 'require_all'

# will not run if this file was loaded or required
if __FILE__==$0
    require_all __dir__+'/src'
    Navigator.new(Loader.load_json_data).loop_for_input
end
