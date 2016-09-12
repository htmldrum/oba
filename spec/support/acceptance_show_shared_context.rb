RSpec.shared_context 'acceptance_show' do
  let(:id) { subject.id }

  example_request 'show' do
    expect(status).to eq(200)
  end
end
