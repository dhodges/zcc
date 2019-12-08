
describe Finder do
    subject { Finder.new(fixture_data) }
        
    let(:results) { subject.locate(search_path, search_term) }
    let(:result_names) { results.map {|item| item['name']}.sort }

    describe 'when locating which data array to search' do
        let(:search_path) { ['user', '_id'] }
        let(:search_array) { subject.search_array(search_path) }
        let(:result_ids) { search_array.map {|item| item['_id']}.sort }
        let(:expected_ids) { [*1..75] }

        it 'the correct results are found' do
            expect(result_ids).to match_array(expected_ids)
        end
    end

    describe 'when searching' do
        describe 'String attributes' do
            let(:search_path) { ['organization', 'details'] }
            let(:search_term) { 'Non profit' }
            let(:expected_names) do 
                ['Bitrex', 
                 'Geekfarm', 
                 'Kindaloo', 
                 'Multron', 
                 'Nutralab', 
                 'Plasmos', 
                 'Zolarex']
            end

            it 'the correct results are found' do
                expect(result_names).to match_array(expected_names)
            end
        end

        describe 'an empty String attribute' do
            let(:search_path) { ['organization', 'details'] }
            let(:search_term) { '' }
            let(:expected_names) { ['Zentry'] }

            it 'the correct results are found' do
                expect(result_names).to match_array(expected_names)
            end
        end

        describe 'Array attributes' do
            let(:search_path) { ['organization', 'tags'] }
            let(:search_term) { 'Mclaughlin' }
            let(:expected_names) { ['Xylar'] }
        
            it 'the correct results are found' do
                expect(result_names).to match_array(expected_names)
            end
        end

        describe 'an empty Array attribute' do
            let(:search_path) { ['organization', 'tags'] }
            let(:search_term) { '' }
            let(:expected_names) { ['Zentry'] }
        
            it 'the correct results are found' do
                expect(result_names).to match_array(expected_names)
            end
        end

        describe 'numeric attributes' do
            let(:search_path) { ['organization', '_id'] }
            let(:search_term) { '108' }
            let(:expected_names) { ['Zolarex'] }
        

            it 'the correct results are found' do
                expect(result_names).to match_array(expected_names)
            end
        end

        describe 'boolean attributes' do
            let(:search_path) { ['organization', 'shared_tickets'] }
            let(:search_term) { 'true' }
            let(:expected_names) do 
                ['Bitrex', 
                 'Comtext', 
                 'Geekfarm', 
                 'Hotcâkes', 
                 'Isotronic', 
                 'Kindaloo', 
                 'Noralex', 
                 'Speedbolt', 
                 'Sulfax', 
                 'Terrasys']
            end
        
            it 'the correct results are found' do
                expect(result_names).to match_array(expected_names)
            end
        end
    end

    describe 'when searching organizations' do
        let(:search_path) { ['organization', '_id'] }
        let(:search_term) { 122 }
        let(:organization) { subject.locate(search_path, search_term).first }

        let(:ticket_subjects) { organization['tickets'] }
        let(:expected_ticket_subjects) do [
            'A Catastrophe in Maldives',
            'A Catastrophe in US Minor Outlying Islands',
            'A Drama in Indonesia',
            'A Nuisance in Chile',
            'A Catastrophe in Gibraltar',
            'A Catastrophe in Brazil',
            'A Nuisance in Bhutan',
            'A Drama in Canada',
            'A Nuisance in Uganda',
            'A Nuisance in United States',
            'A Catastrophe in Singapore',
            'A Drama in Kazakhstan',
            'A Problem in Malawi']
        end

        it 'the ticket subjects are included' do
            expect(ticket_subjects).to match_array(expected_ticket_subjects)
        end

        let(:user_names) { organization['users'] }
        let(:expected_user_names) do
            ['Rose Newton', 'Charlene Coleman', 'Dawson Schultz', 'Benjamin Stephenson']
        end

        it 'the user names are included' do
            expect(user_names).to match_array(expected_user_names)
        end
    end

    describe 'when searching tickets' do
        let(:search_path) { ['ticket', 'organization_id'] }
        let(:search_term) { 113 }
        let(:tickets) { subject.locate(search_path, search_term) }

        let(:assignee_names) { tickets.map{|ticket| ticket['assignee_name']} }
        let(:expected_assignee_names) do [
            'Jessica Raymond', 
            'Boone Cooke', 
            'Herrera Norman', 
            'Moran Daniels', 
            'Burgess England', 
            'Jeri Estrada', 
            'Key Mendez']
        end

        it 'the assignee_names are included' do
            expect(assignee_names).to match_array(expected_assignee_names)
        end

        let(:submitter_names) { tickets.map{|ticket| ticket['submitter_name']} }
        let(:expected_submitter_names) do [
            'Brôôks Burke', 
            'Daniel Agüilar', 
            'Deanna Terry', 
            'Edwards Garrétt', 
            'Geneva Poole', 
            'Moran Daniels', 
            'Sampson Castillo']
        end

        it 'the submitter_names are included' do
            expect(submitter_names).to match_array(expected_submitter_names)
        end
    end
end
