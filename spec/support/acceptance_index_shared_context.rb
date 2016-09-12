RSpec.shared_context 'acceptance_index' do
  parameter :page, 'Current page of results. Default: 1'
  parameter :limit, 'Results per page. Default: 20.'
  parameter :order_by, 'Results order by attribute. Default: id.'
  parameter :sort, 'Results Sorting, asc or desc. Default: asc.'
  parameter :updated_since, 'Limit results by \'updated_at\' time. ISO8601 format: https://www.ietf.org/rfc/rfc3339.txt.'
  parameter :created_since, 'Limit results by \'created_at\' time. ISO8601 format: https://www.ietf.org/rfc/rfc3339.txt.'

  let(:page) { 1 }
  let(:limit) { 20 }
  let(:order_by) { 'email' }
  let(:sort) { 'asc' }
  let(:updated_since) { (Time.zone.now - 3.hours).iso8601 }
  let(:created_since) { (Time.zone.now - 3.hours).iso8601 }

  example_request 'index' do
    expect(status).to eq(200)
    if subject.class == User
      # +1 for requesting user
      expect(json[subject.class.name.underscore.pluralize].length)
        .to eq(send(subject.class.name.underscore.pluralize.to_sym).length + 1)
    else
      expect(json[subject.class.name.underscore.pluralize].length)
        .to eq(send(subject.class.name.underscore.pluralize.to_sym).length)
    end
  end
end
