require 'json'

class Finder
    def initialize(data)
        @data = data
    end

    def locate(search_path, search_term)
        return unless search_path.count > 1
        search_term = search_term.to_s

        attribute = search_path.last # e.g. 'name'
        search_array(search_path).filter do |item| 
            attr = item[attribute]
            case attr
            when Array
                (attr.empty? && search_term.empty?) || attr.include?(search_term)
            else
                attr.to_s == search_term
            end
        end
    end

    # decide which array of json objects to search
    def search_array(search_path)
        fields = search_path.dup
        target = @data[fields.shift]
        fields.pop # ignore the final search term
        fields.each do |field| 
            target = target[field]
            target = target[0] if target.class == Array
        end
        target
    end
end

