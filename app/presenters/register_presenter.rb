class RegisterPresenter < SimpleDelegator
  def initialize(model)
    @model = model
    super(@model)
  end

  def list
    @model.all.map do |register|
      {
        id: register.id,
        name: register.name,
        birthday: register.birthday.strftime('%Y-%m-%d'),
        cpf: register.cpf,
        rg: register.rg,
        accession_at: register.accession_at.strftime('%Y-%m-%d'),
        plan: register.plan,
        status: register.status
      }
    end
  end

  def description
    {
      id: @model.id,
      name: @model.name,
      birthday: @model.birthday.strftime('%Y-%m-%d'),
      cpf: @model.cpf,
      rg: @model.rg,
      accession_at: @model.accession_at.strftime('%Y-%m-%d'),
      plan: @model.plan,
      status: @model.status
    }
  end
end
