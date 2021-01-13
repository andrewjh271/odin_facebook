# Social Scrolls

A social media app inspired by Facebook. Created as part of the Odin Project [curriculum](https://www.theodinproject.com/courses/ruby-on-rails/lessons/final-project). View [live page](https://socialscrolls.herokuapp.com/).

OmniAuth is implemented for Facebook and Github. Active Storage is used for avatar and photo uploads, using cloud storage on [Cloudinary](https://cloudinary.com/). Action Mailer is used with the default [Mail](https://github.com/mikel/mail) gem.

Test suite covers Models, Controllers, Mailers, and Integration Testing with Capybara.

### Thoughts

###### Reciprocal Friendships

It was challenging to implement friendships since a user could be on either side of the `friendship` association (`friend_a` or `friend_b`). I found a number of possible solutions — possibly the simplest was to just duplicate the association in reverse, but I didn't like the idea of doubling all that data. What I came up with and liked best was to rely more on SQL rather than Active Record queries:

```sql
def friends
	join_statement = <<-SQL
  	INNER JOIN friendships
    	ON (friendships.friend_a_id = users.id OR friendships.friend_b_id = users.id)
    	AND (friendships.friend_a_id = #{id} OR friendships.friend_b_id = #{id})
		SQL
   User.joins(join_statement).where.not(id: id)
end
```

I only write the join statment in SQL so that I can incorporate it into an Active Record query and ultimately still return an `ActiveRecord::Relation`. I used similar strategies to create methods that for a given user returned other users who were not friends, or who had no relationship (no `friendship` or ` friend_request` association).

###### Active Storage

I decided to use Cloudinary rather than AWS for cloud storage because I wanted to avoid dealing with the AWS S3 1 year free trial period ending. Configuring Active Storage with Cloudinary was seamless, and after testing in development and fairly generous seeding I am still only at 5% the monthly allotment.

Some helpful links:

- This [article](https://blog.capsens.eu/how-to-use-activestorage-in-your-rails-5-2-application-cdf3a3ad8d7) gives a great overview of using Active Storage. Particularly useful was the mention of the `with_attached` scope for preloading.

- This [Stack Overflow](https://stackoverflow.com/questions/51027995/how-to-save-an-image-from-a-url-with-rails-active-storage) post describes the basic setup for saving an image from a URL.
- This [article](https://bigbinary.com/blog/rails-6-1-tracks-active-storage-variant-in-the-database) and this [pull request](https://github.com/rails/rails/pull/37901) explain an improvement with Rails 6.1 involving tracking variants in the database.
- This page in the [docs](https://edgeapi.rubyonrails.org/classes/ActiveStorage/Attached/One.html#method-i-attach) clarify what happens when attaching persisted vs unpersisted records.


I encountered some difficulties attaching an image from a file or URL rather than a user upload. `User::from_omniauth`, for instance, involves some gymnastics to attach a file without leaving it open:

```ruby
where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  File.open(URI.open(auth.info.image)) do |io|
    user.avatar.attach(io: io, filename: 'image-download')
  end
end
```

throws a `IOError: closed stream` because the `io` file needs to still be open at the end of the `first_or_create` block. Things seemed to work ok if I just left the file open and didn't use a block for it, but I wanted to ensure I closed it once it was used. I encountered this error in other places as well (attaching default avatars, testing...), and this comment from a [Rails Issue](https://github.com/rails/rails/issues/38185#issuecomment-572848893) explains what's going on.

I wanted to be mindful when I created variants of images vs just using CSS to resize them, since the number of transactions on Cloudinary counts against the free allotment. I only create variants for the avatar thumbnails, since many of those can appear on a page at once and the server should not be retrieving full sized images for each one. I experimented with using Cloudinary's `cl_image_tag` to create the image variants, but ended up using Active Storage's `variant`, which uses the `image-processing` gem.

###### OmniAuth

Facebook requires some extra work to allow OmniAuth to work in Live Mode, including having a privacy policy, instructions for data deletion, and Valid OAuth Redirect URIs listed. It's a little deceptive that everything works perfectly for me in Development Mode since my account is connected to the app, but wouldn't work for anyone else.

`User::new_with_session` as recommended on the Devise/OmniAuth [page](https://github.com/heartcombo/devise/wiki/OmniAuth:-Overview) allows the data retrieved from an unsuccessful OAuth attempt to be prefilled in the rerendered form.

Some helpful links:

- [Stack Overflow](https://stackoverflow.com/questions/30748779/want-to-save-facebook-image-into-my-rails-app) post with helpful advice for getting Facebook OmniAuth to work (particularly `secure_image_url: true`)
- [Pull request](https://github.com/simi/omniauth-facebook/issues/345) that also discusses `secure_image_url: true` to avoid a 500 Internal Service Error.
- [Stack Overflow](https://stackoverflow.com/questions/7131909/facebook-callback-appends-to-return-url#:~:text=When%20the%20callback%20returns%20with,need%20not%20worry%20about%20it) post that discusses why Facebook appends `#_=_` to the redirect_uri.

###### Mail

I briefly tried to use SendGrid again for this project — I got further than I did when I spent much more time on it for my Flight Booker project, but when I tried to setup Single Sender Verification (the first step they recommended after I logged in), it shut me out of the account and said I was unauthorized to access SendGrid without telling me why.

Instead I am just using the default [Mail](https://github.com/mikel/mail) gem, configured for Yahoo Mail.

###### Javascript

I really felt the lack of Javascript in this project — it was onerous having to rerender pages for small things like liking a post or displaying a form to reply to a particular comment.

###### Configuring Devise Controllers

I wanted the `:ensure_avatar`, `:create_friend_invitations`, `:send_welcome_email` callbacks to be attached to the controller and not the model, so I followed the steps in the Devise [instructions](https://github.com/heartcombo/devise#configuring-controllers) to customize them. It looked daunting but ended up being fairly straightforward.

-Andrew Hayhurst