# Odin Facebook

For `PostsController#show` I tried to preload the many nested records for `@post`, but I don't think it worked.

```ruby
@post = Post.includes(
                   :likes,
                   comments: [
                     :likes,
                     author: { avatar_attachment: :blob},
                     comments: [
                        :likes,
                        author: { avatar_attachment: :blob }
                     ]
                   ]
                 )
                .find(params[:id])
```





###### OAuth

https://github.com/simi/omniauth-facebook options in config/initializers/devise.rb

https://github.com/simi/omniauth-facebook/issues/343 500 Internal Service Error

https://github.com/simi/omniauth-facebook/issues/345

https://stackoverflow.com/questions/30748779/want-to-save-facebook-image-into-my-rails-app

https://stackoverflow.com/questions/7131909/facebook-callback-appends-to-return-url#:~:text=When%20the%20callback%20returns%20with,need%20not%20worry%20about%20it.







###### Active Storage

https://blog.capsens.eu/how-to-use-activestorage-in-your-rails-5-2-application-cdf3a3ad8d7 Helpful overview

https://stackoverflow.com/questions/51027995/how-to-save-an-image-from-a-url-with-rails-active-storage basic setup for attaching image



https://github.com/rails/rails/pull/37901 confirms it is checked whether a variant already exists

https://bigbinary.com/blog/rails-6-1-tracks-active-storage-variant-in-the-database explains improvement with Rails 6.1



https://edgeapi.rubyonrails.org/classes/ActiveStorage/Attached/One.html#method-i-attach attaching to persisted vs unpersisted records



User::from_omniauth

```ruby
File.open(URI.open(auth.info.image)) do |io|
	user.avatar.attach(io: io, filename: 'image-download')
end
```

Cannot be inside `where(provider: auth.provider, uid: auth.uid).first_or_create do |user|` block because the `io` file needs to be open at the end of the block. Things seemed to work ok if I just left the File open, but I wanted to ensure I closed it once it was used





###### Mail

I briefly tried to use SendGrid again for this project — I got further than I ever did when I spent much more time on it for my Flight Booker project, but when I tried to setup the first step they recommended after logging into my app's account, Single Sender Verification, it shut me out of the account and said I was unauthorized to access SendGrid without telling me why.