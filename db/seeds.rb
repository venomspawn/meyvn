# frozen_string_literal: true

seed = proc do |model, key, values|
  field = model.arel_table[key]
  lower = Arel::Nodes::NamedFunction.new('lower', [field])
  existing = model.pluck(lower)
  values.each do |value|
    model.create(key => value) unless existing.include?(value.downcase)
  end
end

seed[City, :name, %w[London St.\ Petersburg Kazan]]
seed[Topic, :title, %w[Politics Support Games]]
