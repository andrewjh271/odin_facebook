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

