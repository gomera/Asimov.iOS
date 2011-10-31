#!/usr/bin/ruby
@defaults = <<DEFAULTS
[color]
        diff = auto
        status = auto
        branch = auto
[alias]
        st = status
        co = checkout
        br = branch
DEFAULTS

def initialize_data
 remote_origin = IO.popen('git remote -v show -n origin').readlines
 @origin_url = remote_origin[1].strip.scan(/Fetch\sURL:\s(.*)/).to_s
end

def config_remotes
  ask "Queres agregar a tu configuracion los alias/colores standard? (Yes/[No]) :" do |answer|
    config_git @defaults if answer.match /yes|y|s|si/i
  end
 
  ask "Queres configurar un remote para hacer push? ([Yes]/No) :" do |answer|
   if answer.match /no|n/i
     puts "Chau!"; 
     exit 0
   end  
  end
  
  @remote_name = :review
  ask "Nombre del remote [review] :" do |answer|
    @remote_name = answer.to_sym unless answer.strip.empty?
  end
  
  @branch_name = :master
  ask "Nombre del branch [master] :" do |answer|
    @branch_name = answer.to_sym unless answer.strip.empty?
  end

  question = <<"QUEST"

Se va a configurar el remote para que puedas pushear de la siguiente forma:
    $ git push #{@remote_name}
y tus cambios vayan al branch #{@branch_name} en el remote: #{@origin_url}

Esto esta bien? ([YES]/No):
QUEST

  ask question do |answer|
    if answer.match /no|n/i
      puts "\nNo configuramos nada :("
      config_remotes
    else
      puts "Configurando"
  text = <<GIT

[remote \"#{@remote_name}\"]
	url = #{@origin_url} 
	push = HEAD:refs/for/#{@branch_name}
GIT

      config_git text 
    end
   end
end

def config_git(text)
  git_config = File.open ".git/config", "a"
  git_config.write text
  git_config.close
end

def ask(question, &block)
  print question
  answer = gets.chomp
  block.call answer
end

def config_gerrit_hook
  ask "Gerrit user?: " do |user|
      @gerrit_user = user
  end
  command =  "scp -p -P 8082 #{@gerrit_user.to_s + "@" unless @gerrit_user.strip.empty?}gerrit.teracode.com:hooks/commit-msg .git/hooks/"
  puts command
  IO.popen command
  IO.popen "chmod +x .git/hooks/commit-msg"
end

config_gerrit_hook

initialize_data

puts "La url de el repositorio origin es: #{@origin_url}"

config_remotes





