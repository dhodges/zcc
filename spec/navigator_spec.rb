
describe Navigator do
    subject { Navigator.new(fixture_data) }
    before do
        search_fields.each {|name| subject.search_path.push name}
    end

    describe 'the cmd-line prompt is correct with one search_path field' do
        let(:search_fields) { ['organization'] }
        it 'only one search_path field' do
            expect(subject.send(:prompt)).to eq('> search organization: ')
        end
    end

    describe 'the cmd-line prompt is correct with two search_path fields' do
        let(:search_fields) { ['organization', 'name'] }
        it 'only one search_path field' do
            expect(subject.send(:prompt)).to eq('> search organization.name: ')
        end
    end

    describe '#target_instance is correct with one search_path field' do
        let(:search_fields) { ['ticket'] }
        it 'only one search_path field' do
            expect(subject.send(:prompt)).to eq('> search ticket: ')
        end
    end

    describe '#target_instance are correct with two search_path fields' do
        let(:search_fields) { ['ticket', 'name'] }
        it 'two search_path fields' do
            expect(subject.send(:prompt)).to eq('> search ticket.name: ')
        end
    end

    describe '#tab_completion_fields are correct with one search_path field' do
        let(:search_fields) { ['user'] }
        it 'only one search_path field' do
            expect(subject.send(:prompt)).to eq('> search user: ')
        end
    end

    describe '#tab_completion_fields are correct with two search_path fields' do
        let(:search_fields) { ['user', 'name'] }
        it 'two search_path fields' do
            expect(subject.send(:prompt)).to eq('> search user.name: ')
        end
    end
end
