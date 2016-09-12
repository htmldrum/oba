RSpec.shared_examples_for 'HasStatus' do
  let(:model) { described_class }
  let(:inst) { model.new }
  describe '::STATUS' do
    it 'has a STATUS constant' do
      expect(model::STATUSES[0]).to eq(:green)
      expect(model::STATUSES[1]).to eq(:red)
    end
  end
  describe '#status' do
    context 'with a truthy value for green?' do
      it 'has a status accessor that returns the first status on a truthy green? result' do
        allow(inst).to receive(:green?).and_return(true)
        expect(inst.status).to eq(model::STATUSES[0])
      end
    end
    context 'with a truthy value for green?' do
      it 'has a status accessor that returns the first status on a truthy green? result' do
        allow(inst).to receive(:green?).and_return(false)
        expect(inst.status).to eq(model::STATUSES[1])
      end
    end
  end
  describe '#green' do
    it 'implements a #green? instance method' do
      expect(model.instance_methods.select { |m| m == :green? }.length).to eq(1)
    end
  end
end
