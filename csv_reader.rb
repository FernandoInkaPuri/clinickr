require 'sinatra'
require 'json'
require 'pg'
require 'csv'

get '/' do
  begin
    con = PG.connect :host => 'localhost', :port => 5432, :dbname => 'postgres', :user => 'postgres',
    :password => '123456'
    con.exec "SELECT cpf FROM tests"
  rescue PG::Error => e
    puts e.message      
  ensure
    con.close if con  
  end
  erb :index 
end

get '/upload' do
  erb :upload
end

post '/save_data' do
  @filename = params['myfile'][:filename]
  file = params['myfile'][:tempfile]

  File.open("./public/#{@filename}", 'wb') do |f|
    f.write(file.read)
  end
  save_db(@filename)
  redirect '/'
end

def save_db(namefile)
  begin
    con = PG.connect :host => 'localhost', :port => 5432, :dbname => 'postgres', :user => 'postgres',
    :password => '123456'
    con.exec "CREATE TABLE IF NOT EXISTS tests(cpf varchar(50), nome_paciente varchar(50), email_paciente varchar(50),
    data_nascimento_paciente varchar(50), endereço_rua_paciente varchar(50), cidade_paciente varchar(50), estado_paciente varchar(50),
    crm_medico varchar(50), crm_medico_estado varchar(50), nome_medico varchar(50), email_medico varchar(50), 
    token_resultado_exame varchar(50), data_exame varchar(50), tipo_exame varchar(50), limites_tipo_exame varchar(50), resultado_tipo_exame varchar(50))"
    con.exec "COPY tests FROM '/home/fernandoinkapuri/workspace/clinickr/public/#{namefile}' with delimiter as ';'"
  rescue PG::Error => e
    puts e.message      
  ensure
    con.close if con  
  end
end