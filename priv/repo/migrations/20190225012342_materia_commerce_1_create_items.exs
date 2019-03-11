defmodule MateriaBatch.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :category1, :string
      add :category2, :string
      add :category3, :string
      add :category4, :string
      add :item_code, :string
      add :model_number, :string
      add :jan_code, :string
      add :thumbnail, :string
      add :image_url, :string
      add :size1, :string
      add :size2, :string
      add :size3, :string
      add :size4, :string
      add :weight1, :string
      add :weight2, :string
      add :weight3, :string
      add :weight4, :string
      add :delivery_area, :string
      add :manufacturer, :string
      add :color, :string
      add :description, :text
      add :start_datetime, :utc_datetime
      add :end_datetime, :utc_datetime
      add :tax_category, :string
      add :status, :integer
      add :lock_version, :integer

      timestamps()
    end

  end
end
