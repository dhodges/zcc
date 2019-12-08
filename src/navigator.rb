require 'readline'
require_relative 'display'
require_relative 'finder'

# see: http://bogojoker.com/readline/#handling_x2303c_interrupts
stty_save = `stty -g`.chomp
trap('INT') { system('stty', stty_save); exit }

USAGE = """
Welcome to Zendesk Zearch

Search for organizations/tickets/users by attribute
e.g. Enter 'user' to search all users           
      then 'name' to search all users by name         
                                                      
Enter 'help' for this help info
      '..'   to step back up the search fields
      TAB    for suggestions
      SPACE, RETURN and arrow keys to navigate search results
      'quit' or 'q' to exit at any time

"""

# CLI navigation up & down the json hierarchy, searching for fields therein
class Navigator
    def initialize(data)
        @data = data
        @search_path = [] # accumulated sesarch fields, e.g. ['organization', 'name']
        init_readline
    end

    def loop_for_input
        puts USAGE

        while search_term = next_line
            puts
            if search_term.empty?
                next
            elsif tab_completion_fields.include?(search_term)
                @search_path.push search_term
                loop_for_input
            else 
                case @search_path.count
                when 2
                    locate_and_show(search_term)
                else
                    puts "no items named: '#{search_term}' (try typing TAB key)\n\n"
                end
            end
        end
    end

    private

    def next_line
        line = Readline.readline(prompt, true).strip rescue nil # 2nd param 'true' == accumulate input history
        case line
        when '..'
            @search_path.pop
            ''
        when 'help'
            puts USAGE
            ''
        when 'quit'
            exit(0)
        when 'q'
            exit(0)
        else
            line
        end
    end

    def prompt
        "> search #{@search_path.join('.')}: "
    end

    def tab_completion_fields
        target = target_instance

        case target
        when Array
            target[0].keys.sort
        when Hash
            target.keys.sort
        else
            @search_path.empty? ? @data.keys : []
        end
    end

    def locate_and_show(search_term)
        results = Finder.new(@data).locate(@search_path, search_term)
        if results
            Display.to_screen(@search_path, search_term, results)
        end
    end

    # for tab complete: provide an object instance of the current search target(s)
    def target_instance
        target = @data
        target = target[@search_path[0]].first if @search_path.count > 0
        target = target[@search_path[1]] if @search_path.count > 1
        target
    end

    def init_readline
        Readline.completion_append_character = ' '
        Readline.completion_proc = proc do |term| 
            tab_completion_fields.grep /^#{Regexp.escape(term)}/
        end
    end
end
