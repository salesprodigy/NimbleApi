module NimbleApi

  class Contact

    attr_accessor :contact
    def initialize(nimble)
      @nimble = nimble
    end

    def create params
      # email is used as unique id
      @email = params['email']
      if params['address']
        address = {"city" => params['address'], "street" => "", "zip" => "", "country" => ""}.to_json
      end
      @person = {
        "fields" => {
          "first name" => [{"value" => params['first name'],"modifier" => ""}],
          "last name" => [{ "value"=> params['last name'],"modifier" => ""}],
          "parent company" => [{ "modifier"=>"","value"=>params['company']}],
          "linkedin" => [{"modifier"=>"",  "value"=>params['linkedin']}],
          "URL" => [{ "modifier"=>"other", "value"=>params['website']}],
          "email" => [{"modifier"=>"work", "value"=>params['email']}],
          "lead status" => [{"modifier"=>"", "value"=>"Not Qualified"}],
          "title" => [{"modifier" => "", "value" => params['headline']}],
          "address" => [ { "modifier" => "work","value" => address }]
          },
          "tags" => [params['tags']],
          "record_type" => "person"
        }
      # remove empty fields
      @person['fields'].keys.each {|k| @person['fields'].delete(k) if @person['fields'][k][0]['value'].nil? }
      self
    end

    # convenience methods
    def id
      self.contact['id']
    end

    def email
      self.contact['fields']['email'].first['value']
    end

    def fields
      self.contact['fields']
    end

    # Checks for duplicates by email
    def save
      raise 'must call contact.create(params) before save' unless @person
      raise 'must set email address for unique checking before save' unless @email
      if @email
        raise "#{@email} already exists!" unless self.by_email(@email).nil?
      end
      self.contact = @nimble.post 'contact', @person
      return nil unless self.contact
      self
    end

    def by_email email
      query = { "and" => [{ "email" => { "is"=> email } },{ "record type"=> { "is"=> "person" }} ] }
      resp = @nimble.get 'contacts', { :query => query.to_json }
      self.contact = resp['resources'].first
      return nil unless self.contact
      self
    end

    def fetch id=nil
      id ||= self.id
      resp = @nimble.get "contact/#{id}"
      self.contact = resp['resources'].first
      return nil unless self.contact
      self
    end
    alias_method :get, :fetch

    def update fields
      self.contact = @nimble.put "contact/#{self.id}", { fields: fields }
      return nil unless self.contact
      self
    end

    def notes params=nil
      @nimble.get "contact/#{self.id}/notes", params
    end

    def note note, preview=nil
      preview ||= note[0..64]
      params = {
        contact_ids: [ self.id ],
        note: note,
        note_preview: preview
      }
      @nimble.post "contacts/notes", params
    end

    def delete_note id
      @nimble.delete "contact/notes/#{id}"
    end

    def delete id=nil
      id ||= self.id
      @nimble.delete "contact/#{id}"
    end

    def task due_date, subject, notes=nil
      due = Chronic.parse(due_date).strftime('%Y-%m-%d %H:%M')
      params = {
        related_to: [ self.id ],
        subject: subject,
        due_date: due
      }
      params[:notes] = notes if notes
      @nimble.post "activities/task", params
    end

  end
end