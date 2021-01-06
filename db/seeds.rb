User.destroy_all
Note.destroy_all

User.create(username: "ObinnaSam")
Note.create(user: "ObinnaSam", description: "This is our demo note.")