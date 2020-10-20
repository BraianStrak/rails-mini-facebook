class RegistrationMailer < ApplicationMailer
    default from: 'facebookmailertest@email.com'
    def welcome_email(user)
        @user = user
        mail(to: @user.email, subject: 'Thank you for registering with mini-facebook')
    end
end
