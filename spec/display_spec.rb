
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

        let(:formatted_key) { Display.format_key('erewhon', 10) }

        it 'keys are padded with the expected number of spaces' do
            expect(formatted_key).to eq('erewhon   ')
        end
        
        let(:formatted_line) { Display.format_line('barsoom', 10, 'yes') }

        it 'lines have a padded key and a value' do
            expect(formatted_line).to eq('barsoom   yes')
        end
    end

    describe 'when formatting a result' do
        let(:search_path) { ['ticket', 'organization_id'] }
        let(:search_term) { 113 }
        let(:finder) { Finder.new(fixture_data) }
        let(:ticket) { finder.locate(search_path, search_term).first }
        let(:formatted_ticket) { Display.prettify([ticket]) }

        # chosen because this ticket's fields have booleans, arrays, numbers and strings
        it 'the prettified results look OK' do
            expect(formatted_ticket).to eq(
"""subject          A Problem in Tonga
-------          
_id              b4875dbc-c167-4625-a1e4-d14ed409c62c
assignee_id      31
assignee_name    Jessica Raymond
created_at       2016-04-22T12:55:29 -10:00
description      Proident est ea duis eiusmod. Deserunt laboris eu cupidatat culpa tempor aliquip eu.
due_at           2016-08-06T07:41:47 -10:00
external_id      0a8d9bab-b265-4801-8d64-ba6cba3df967
has_incidents    no
organization_id  113
priority         urgent
status           open
submitter_id     73
submitter_name   Moran Daniels
tags             Michigan, Florida, Georgia, Tennessee
type             question
url              http://initech.zendesk.com/api/v2/tickets/b4875dbc-c167-4625-a1e4-d14ed409c62c.json
via              voice
""")
        end
    end

    describe 'when searching a boolean field' do
        let(:finder) { Finder.new(fixture_data) }
        let(:search_path) { ['user', 'shared'] }
        let(:users) { finder.locate(search_path, search_term) }
        let(:formatted_value) { Display.format_value('shared', 10, users.first['shared']) }

        describe 'that is false' do
            let(:search_term) { false }
            it 'the result is "no"' do
                expect(formatted_value).to eq 'no'
            end
        end

        describe 'that is true' do
            let(:search_term) { true }
            it 'the result is "yes"' do
                expect(formatted_value).to eq 'yes'
            end
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
