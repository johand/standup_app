# frozen_string_literal: true

file_path = 'config/plans.yml'

if File.exist?(file_path)
  PLANS = YAML.safe_load(File.read(file_path)).with_indifferent_access
end
