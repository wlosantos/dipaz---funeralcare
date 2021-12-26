namespace :company do
  desc 'create company'
  task set_config: :environment do
    company = Company.new(name: ENV['name'], cnpj: ENV['cnpj'], domain: ENV['domain'], status: 'blocked')
    puts
    puts '=' * 20
    puts 'Empresa criada com sucesso!!!' if company.save
    puts
  end

  desc 'actived company'
  task set_status: :environment do
    puts
    puts '=' * 20
    company = Company.find(ENV['id'].to_i)
    if company.update(status: ENV['status'])
      puts "#{company.name} está #{ENV['status'] == 'active' ? 'ativa' : 'bloqueada'}"
    else
      puts company.errors.full_messages
    end
  end

  desc 'setting user company'
  task set_user: :environment do
    puts
    puts '=' * 20
    company = Company.find(ENV['id'].to_i)
    user = User.create(name: ENV['name'], email: ENV['email'], password: '123456', phone: ENV['phone'],
                       company_id: company.id)
    if user.save
      user.add_role :admin
      puts "usuário #{user.name} cadastrado com sucesso!!!"
    else
      puts user.errors.full_messages
    end
  end
end
