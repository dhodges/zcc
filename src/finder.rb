require 'json'

class Finder
    def initialize(data)
        @data = data
    end

    def locate(search_path, search_term)
        return unless search_path.count > 1
        search_term = search_term.to_s

        attribute = search_path.last # e.g. 'name'
        results = search_items(search_path).filter do |item| 
            attr = item[attribute]
            case attr
            when Array
                (attr.empty? && search_term.empty?) || attr.include?(search_term)
            else
                attr.to_s == search_term
            end
        end
        augment(search_path, results)
    end

    # decide which array of json objects to search
    def search_items(search_path)
        @data[search_path.first] || []
    end

    def augment(search_path, results)
        case search_path.first
        when 'organization'
            augment_organizations(results)
        when 'ticket'
            augment_tickets(results)
        else
            results
        end
    end

    def augment_organizations(results)
        results.each do |org|
            org_id = org['_id'].to_s
            org['tickets'] ||= organization_ticket_subjects(org_id)
            org['users'] ||= organization_user_names(org_id)
        end
    end

    def augment_tickets(results)
        results.each do |ticket|
            unless ticket.has_key?('assignee_name')
                ticket['assignee_name'] ||= user_name(ticket['assignee_id']) || '(unknown)'
            end
            unless ticket.has_key?('submitter_name')
                ticket['submitter_name'] ||= user_name(ticket['submitter_id']) || '(unknown)'
            end
        end
    end

    def organization_ticket_subjects(org_id)
        locate(%w[ticket organization_id], org_id.to_s).map {|ticket| ticket['subject']}
    end

    def organization_user_names(org_id)
        locate(%w[user organization_id], org_id.to_s).map {|user| user['name']}
    end

    def user_name(user_id)
        locate(%w[user _id], user_id.to_s).first['name'] rescue ''
    end
end

