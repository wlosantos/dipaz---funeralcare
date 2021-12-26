class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :cnpj, null: false, index: { unique: true }
      t.string :domain, null: false, default: 'default.com'
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
