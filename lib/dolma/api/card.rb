module Dolma
  module Api
    class Card < Base
      has_many :checklists

      def self.fields
        [:name]
      end

      def self.find_by_url(url)
        return if url.blank?
        id = url.scan(/\/c\/(.+)\//).flatten.first
        find(id)
      end

      def self.for(username)
        with("members/:username/cards/open").where(username: username)
      end

      def find_or_create_checklist
        if checklists.size > 1
          Table.new(checklists).pick
        elsif checklists.none?
          Checklist.create(idCard: id, name: "To-Do")
        else
          checklists.first
        end
      end

      def url
        attributes[:shortUrl]
      end
    end
  end
end