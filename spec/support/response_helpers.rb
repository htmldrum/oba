module ResponseHelpers
  def json
    if try(:body)
      JSON.load(body)
    elsif respond_to? :response_body
      JSON.load(response_body)
    else
      sez(resource, described_class, try(:serializer_options) || {})
    end
  end

  def sez(resource, serializer_class, serializer_options = {})
    str = if resource.respond_to? :each
            ActiveModel::Serializer::CollectionSerializer.new(resource,
                                                              serializer_options: serializer_options,
                                                              serializer: serializer_class,
                                                              each_serializer: serializer_class)
          else
            serializer_class.new(resource, serializer_options)
          end
    JSON.load(str.to_json)
  end
end
