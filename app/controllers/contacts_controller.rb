class ContactsController < ApplicationController
    def new
        /instance variable = new object/
        @contact = Contact.new
    end
    
    def create
        @contact = Contact.new(contact_params)
        if @contact.save
            redirect_to new_contact_path, notice: "Message sent."
        else
            redirect_to new_contact_path, notice: "Error occured."
        end
    end
    /security feature/
    private
        def contact_params
            params.require(:contact).permit(:name, :email, :comments)
        end
end