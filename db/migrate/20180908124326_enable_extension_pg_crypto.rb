# frozen_string_literal: true

# Class of migrations which enable `pgcrypto` extension of PostgreSQL
class EnableExtensionPgCrypto < ActiveRecord::Migration[5.2]
  # Enables reversibly `pgcrypto` extension
  def change
    enable_extension 'pgcrypto'
  end
end
