class UserMailer < ActionMailer::Base
    default from: "Live Seasonal <welcome@liveseasonal.com>"

    def signup_email(user)
        @user = user
        @twitter_message = "#liveseasonal #discoveralifestyle #connectwithlocals. Excited for @liveseasonal new platform launch."

        mail(:to => user.email, :subject => "Thanks for signing up!")
    end
end
