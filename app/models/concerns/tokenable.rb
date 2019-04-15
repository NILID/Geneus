module Tokenable
  extend ActiveSupport::Concern

  class_methods do

    def get_model_name
      self.class_name.downcase
    end

    def get_attr
      :name
    end

    def tokens(query)
      # sql current for mysql for case sensitive
      competences = where("lower(#{get_attr}) like ?", "%#{query.downcase}%")
           .order(get_attr)
           .map{|item| { id: item.id, text: item[get_attr] } }

      competences_results = competences.empty? ? [{ id: "<<<#{query}>>>", "#{get_attr}": "new: \"#{query}\"" }] : competences
      { results: competences_results } # select2_rails specific format json { results: [{ id: 1, name: 'name' }] }
    end


    def ids_from_tokens(tokens)
      tokens.select{ |i| i[/<<<(.+?)>>>/] }.each do |t|
        t.gsub!(/<<<(.+?)>>>/, '\1')

        token = create!("#{get_attr}": t)

        tokens[tokens.index(t)] = token.id
      end
      tokens
    end
  end
end
