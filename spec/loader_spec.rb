
describe Loader do
    describe 'when a JSON file cannot be read' do
        before do
            allow(File).to receive(:read) { raise Errno::EACCES.new('GCHQ') }
            allow(Loader).to receive(:system_exit)
        end

        it 'a "Permission denied" error is sent to STDOUT' do
            expect { Loader.load_json_data }.to output("\nERROR: Permission denied - GCHQ\n").to_stdout
        end

        it 'the program exits' do
            Loader.load_json_data
            expect(Loader).to have_received(:system_exit)
        end
    end

    describe 'when a JSON file is missing' do
        before do
            allow(File).to receive(:read) { raise Errno::ENOENT.new('marie celeste') }
            allow(Loader).to receive(:system_exit)
        end

        it 'a "No such file" error is sent to STDOUT' do
            err = "\nERROR: No such file or directory - marie celeste\n"
            expect { Loader.load_json_data }.to output(err).to_stdout
        end

        it 'the program exits' do
            Loader.load_json_data
            expect(Loader).to have_received(:system_exit)
        end
    end

    describe 'when a JSON file is invalid' do
        before do
            allow(JSON).to receive(:parse) { raise JSON::ParserError.new('big bad message') }
            allow(Loader).to receive(:system_exit)
        end

        it 'a "No such file" error is sent to STDOUT' do
            expect { Loader.load_json_data }.to output("\nERROR: big bad message\n").to_stdout
        end

        it 'the program exits' do
            Loader.load_json_data
            expect(Loader).to have_received(:system_exit)
        end
    end
end
