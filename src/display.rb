require 'tty-pager'

class Display
    class << self
        def to_screen(search_path, search_term, results)
            puts describe(search_path, search_term, results)+"\n\n"
            TTY::Pager.new.page(prettify(results)) if results.count > 0
        end

        def describe(search_path, search_term, results)
            "#{results.count} #{search_path[0]}(s) found where #{search_path.last} == '#{search_term}'"
        end
        
        def max_key_length(results)
            results.map {|result| result.keys.map(&:length).max}.first
        end

        def prettify(results)
            format_str = "%-#{max_key_length(results)}s"
            results.map do |result|
                preferred_order(result.keys).map do |key|
                    "#{sprintf(format_str, key)}  #{result[key] || ''}"
                end.join("\n") + "\n"
            end.join("\n")
        end

        # order in which to display fields of each result
        def preferred_order(inkeys)
            outkeys = []

            if inkeys.include? 'name'
                outkeys << 'name'
                outkeys << 'alias' if inkeys.include? 'alias'
                outkeys << '----'
            end

            if inkeys.include? 'subject'
                outkeys << 'subject'
                outkeys << '-------'
            end

            outkeys.union(inkeys.filter {|k| !outkeys.include?(k)}.sort)
        end
    end
end
