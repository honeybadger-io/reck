require 'cobra/application'

describe Cobra::Application do
  let(:env) { ::Rack::MockRequest.env_for("http://www.example.com#{path}", 'REMOTE_ADDR' => '127.0.0.1') }
  let(:path) { '/' }

  before do
    Cobra::Application.routes.clear
  end

  context "when path is found in routes" do
    it "responds with Ok response" do
      Cobra.route('/') { raise Cobra::Ok, 'Hello World' }
      expect(described_class.call(env)).to eq [200, {}, ['Hello World']]
    end

    it "responds with Created response" do
      Cobra.route('/') { raise Cobra::Created }
      expect(described_class.call(env)).to eq [201, {}, []]
    end

    it "responds with Forbidden response" do
      Cobra.route('/') { raise Cobra::Forbidden }
      expect(described_class.call(env)).to eq [403, {}, []]
    end

    it "responds with NotFound response" do
      Cobra.route('/') { raise Cobra::NotFound }
      expect(described_class.call(env)).to eq [404, {}, []]
    end
  end

  context "when path is not found in routes" do
    it "responds with 404" do
      expect(described_class.call(env)).to eq [404, {}, ['Not Found']]
    end
  end

  context "when non-response-related exception happens" do
    it "responds with 500" do
      Cobra.route('/') { raise RuntimeError, 'oops!' }
      expect(described_class.call(env)).to eq [500, {}, ['Internal Server Error']]
    end
  end
end
