
describe Display do
    let(:ticket_results) { [json_fixture('tickets.json').first] }

    describe 'after finding results' do
        let(:search_path) { ['tickets', 'priority'] }
        let(:search_term) { 'high' }
        let(:results) { [json_fixture('tickets.json').first] }
        let(:description) { Display.describe(search_path, search_term, results) }
        let(:expectation) { "1 tickets(s) found where priority == 'high'" }

        it 'the results are described accurately' do
            expect(description).to eq expectation
        end
    end

    describe 'when formatting results' do
        it 'max_key_length is accurate' do
            expect(Display.max_key_length(ticket_results)).to eq(15)
        end
    end

    describe 'when ordering results' do
        let(:keys) { %w[delta charlie baker able id _id name] }
        let(:expected_keys) { %w[name ---- _id able baker charlie delta id] }

        it 'preferred order is correct (including name)' do
            expect(Display.preferred_order(keys)).to match_array(expected_keys)
        end

        let(:keys) { %w[delta charlie baker able id _id subject] }
        let(:expected_keys) { %w[subject ------- _id able baker charlie delta id] }

        it 'preferred order is correct (including subject)' do
            expect(Display.preferred_order(keys)).to match_array(expected_keys)
        end
    end
end
