module ResourceHelpers
  def test_image_data
    Base64.encode64(open("#{Rails.root}/spec/support/fixtures/logo.png", &:read))
  end

  def t_resource_name
    self.class.described_class.name.underscore
  end

  def resource_to_sym
    t_resource_name.to_sym
  end

  def resource_from_path(path, nesting = 1)
    case nesting
    when 1
      uuid_to_str_int_to_int(path.split('/').fourth)
    end
  end

  def http_verb_from_test_action
    case to_s.match(/create|destroy|index|show|update/i)[0].downcase
    when 'create'
      'post'
    when 'destroy'
      'delete'
    when 'index', 'show'
      'get'
    when 'update'
      'put'
    end
  end

  private

  def uuid_to_str_int_to_int(s)
    if s =~ /[A-z]/
      s
    else
      s.to_i
    end
  end
end
