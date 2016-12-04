class ContactsController < ApplicationController
    def new
        /instance variable = new object/
        @contact = Contact.new
    end
    
    def create
        @contact = Contact.new(contact_params)
        if @contact.save
            flash[:success] = "Message sent!"
            redirect_to new_contact_path
        else
            flash[:danger] = @contact.errors.full_messages.join(', ')
            redirect_to new_contact_path
        end
    end
    /security feature/
    private
        def contact_params
            params.require(:contact).permit(:name, :email, :comments)
        end
end