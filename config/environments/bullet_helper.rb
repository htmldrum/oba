def configure_bullet
  Bullet.enable = false
  return # disabling bullet for demo
  Bullet.raise = true
  if Rails.env.development?
    Bullet.rails_logger = true
    Bullet.raise = false
  end

  Bullet.add_whitelist :type => :unused_eager_loading,
                       :class_name => "Site",
                       :association => :locations
  # TODO: report#create - conditionally visit Tickets table
  Bullet.add_whitelist :type => :n_plus_one_query,
                       :class_name => "Report",
                       :association => :ticket
  if block_given?
    yield
  end

end
