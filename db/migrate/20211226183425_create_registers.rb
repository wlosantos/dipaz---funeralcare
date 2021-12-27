class CreateRegisters < ActiveRecord::Migration[6.1]
  def change
    create_table :registers do |t|
      t.string :name, null: false
      t.datetime :birthday, null: false
      t.string :cpf, index: { unique: true }
      t.string :rg
      t.datetime :accession_at, null: false
      t.integer :plan, default: 0
      t.integer :status, default: 0
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
