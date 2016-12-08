class ContactsController < ApplicationController
#GET request to /conyacy-us
#Show new contact form
    def new
    #instance variable = new object
        @contact = Contact.new
    end
#POST request /contacts    
    def create
    #Mass assignments of form fields into Contact object
        @contact = Contact.new(contact_params)
        #Save contact object to db
        if @contact.save
            #Store form fields via parameters, in variables
            name = params[:contact][:name]
            email = params[:contact][:email]
            body = params[:contact][:comments]
            #Plug  vars into Contact Maileremail method
            #and send email
            ContactMailer.contact_email(name, email, body).deliver
            #Store success msg in flash hash
            #and redirct to the 'new' action
            flash[:success] = "Message sent!"
            redirect_to new_contact_path
        else
            #Otherwise, Store error msg in flash hash
            #and redirct to the 'new' action 
            flash[:danger] = @contact.errors.full_messages.join(', ')
            redirect_to new_contact_path
        end
    end
    #security feature
    private
        #To collect data from form, 
        #we need to use strong parameters and whitelist
        #the form fields
        def contact_params
            params.require(:contact).permit(:name, :email, :comments)
        end
end