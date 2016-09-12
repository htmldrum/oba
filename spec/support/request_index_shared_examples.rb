RSpec.shared_examples 'request_index' do
  context 'first page' do
    subject! { get "/v0/#{described_class.name.underscore.pluralize}", { limit: limit, page: page }, headers }
    specify 'has a first page' do
      expect(response).to be_success
      expect(json[described_class.name.underscore.pluralize].length).to eq(limit)
      expect(json['meta']['total']).to eq(resources.length)
      expect(json['meta']['page']).to eq(page)
      expect(json['meta']['limit']).to eq(limit)
      try(:first_page_assertions)
    end
  end
  context 'second page' do
    subject! { get "/v0/#{described_class.name.underscore.pluralize}", { limit: limit, page: page + 1 }, headers }
    specify 'has a second page' do
      expect(response).to be_success
      expect(json[described_class.name.underscore.pluralize].length).to eq(resources.length - limit)
      expect(json['meta']['total']).to eq(resources.length)
      expect(json['meta']['page']).to eq(page + 1)
      expect(json['meta']['limit']).to eq(limit)
      try(:second_page_assertions)
    end
  end

  describe 'order_by' do
    let(:order_by) { :id }
    let(:response_ids) { json[t_resource_name.pluralize].map { |resource| resource['id'] } }
    subject! { get "/v0/#{t_resource_name.pluralize}", { order_by: order_by, sort: sort }, headers }
    context 'when order by nothing' do
      let(:order_by) { nil }
      let(:sort) { nil }
      let(:sorted_resource_ids) { resources.sort_by(&:id).map(&:id) }

      it 'sorts by id asc as default' do
        expect(response).to be_success
        expect(response_ids).to eq(sorted_resource_ids)
        expect(json['meta']['order_by']).to eq('id')
        expect(json['meta']['sort']).to eq('asc')
      end
    end

    context 'when order by exist attribute' do
      context 'when sort is not given' do
        let(:order_by) { :id }
        let(:sort) { nil }
        let(:sorted_resource_ids) { resources.sort_by(&order_by).map(&:id) }

        it 'sorts by attribute asc' do
          expect(response).to be_success
          expect(response_ids).to eq(sorted_resource_ids)
          expect(json['meta']['order_by']).to eq(order_by.to_s)
          expect(json['meta']['sort']).to eq('asc')
        end
      end

      context 'when sort is given' do
        let(:sort) { 'desc' }
        let(:sorted_resource_ids) { resources.sort_by(&order_by).map(&:id).reverse }

        it 'sorts by attribute with given sort' do
          expect(response).to be_success
          expect(response_ids).to eq(sorted_resource_ids)
          expect(json['meta']['order_by']).to eq(order_by.to_s)
          expect(json['meta']['sort']).to eq(sort)
        end
      end
    end

    context 'when order by non-exist attribute' do
      let(:order_by) { 'non-exist-attribute' }
      let(:sort) { nil }
      let(:sorted_resource_ids) { resources.sort_by(&:id).map(&:id) }

      context 'when sort is not given' do
        let(:sort) { nil }
        let(:sorted_resource_ids) { resources.sort_by(&:id).map(&:id) }

        it 'ignores order and sorts by id asc as default' do
          expect(response).to be_success
          expect(response_ids).to eq(sorted_resource_ids)
          expect(json['meta']['order_by']).to eq('id')
          expect(json['meta']['sort']).to eq('asc')
        end
      end

      context 'when sort is given' do
        let(:sort) { 'desc' }
        let(:sorted_resource_ids) { resources.sort_by(&:id).map(&:id).reverse }

        it 'sorts by id as default with given sort' do
          expect(response).to be_success
          expect(response_ids).to eq(sorted_resource_ids)
          expect(json['meta']['order_by']).to eq('id')
          expect(json['meta']['sort']).to eq(sort)
        end
      end
    end

    describe 'invalid sort' do
      let(:order_by) { :id }
      let(:sort) { 'invalid-sort' }
      let(:sorted_resource_ids) { resources.sort_by(&order_by).map(&:id) }

      it 'ignores given sort and use asc as default' do
        expect(response).to be_success
        expect(response_ids).to eq(sorted_resource_ids)
        expect(json['meta']['order_by']).to eq(order_by.to_s)
        expect(json['meta']['sort']).to eq('asc')
      end
    end
  end

  describe 'created_since' do
    let(:new_record) { create(described_class.name.underscore.to_sym, created_at: Time.zone.now + 3.minutes) }
    subject do
      get "/v0/#{described_class.name.underscore.pluralize}", { created_since: new_record.created_at.iso8601 }, headers
    end
    specify do
      subject
      expect(response).to be_success
      expect(json[described_class.name.underscore.pluralize].length).to eq(1)
      expect(json['meta']['total']).to eq(1)
    end
  end
  describe 'updated_since' do
    let(:updated_record) { create(described_class.name.underscore.to_sym, updated_at: Time.zone.now + 3.minutes) }
    subject do
      get "/v0/#{described_class.name.underscore.pluralize}",
          { updated_since: updated_record.updated_at.iso8601 },
          headers
    end
    specify do
      subject
      expect(response).to be_success
      expect(json[described_class.name.underscore.pluralize].length).to eq(1)
      expect(json['meta']['total']).to eq(1)
    end
  end
end
