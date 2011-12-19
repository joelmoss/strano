class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :task
      t.text :notes, :results
      t.references :project, :user

      t.timestamps
    end
  end
end
