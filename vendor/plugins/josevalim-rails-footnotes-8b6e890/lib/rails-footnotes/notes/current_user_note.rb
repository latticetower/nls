require "#{File.dirname(__FILE__)}/abstract_note"

module Footnotes
    module Notes
      class CurrentUserNote < AbstractNote
        # This method always receives a controller
        #
        def initialize(controller)
          @current_user = controller.instance_variable_get("@current_user")
        end

        # Returns the title that represents this note.
        #
        def title
          "Current user: #{@current_user.name}"
        end

        # This Note is only valid if we actually found an user
        # If it's not valid, it won't be displayed
        #
        def valid?
          @current_user
        end

        # The fieldset content
        #
        def content
          escape(@current_user.inspect)
        end
      end
    end
  end