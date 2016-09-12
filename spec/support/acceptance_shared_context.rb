RSpec.shared_context 'acceptance' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  s_model_name = description.underscore
  fact_name = s_model_name.to_sym
  pl_fact_name = s_model_name.pluralize.to_sym
  ft = if const_defined? :FACTORY_TRAITS
         # remove_const :FACTORY_TRAITS
         # called out of parent context
         tmp_ft = FACTORY_TRAITS
         FACTORY_TRAITS = [].freeze
         tmp_ft
       else
         []
       end

  subject!(fact_name) { create(fact_name, *ft) }
  let!(pl_fact_name) { [subject, *create_list(fact_name, 2, *ft)] }
end
