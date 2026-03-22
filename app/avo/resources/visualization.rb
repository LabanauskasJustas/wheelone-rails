class Avo::Resources::Visualization < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :car, as: :belongs_to
    field :rim, as: :belongs_to
    field :status, as: :text
  end
end
