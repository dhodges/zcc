
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
end
