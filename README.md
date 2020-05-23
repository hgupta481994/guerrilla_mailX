# GuerrillaMailX

guerrilla_mailX provides easy methods to call guerilla_mail API's and also you can easily verify subject and body of any mail received over the guerrila_mail.

It is very helpful in testing of mails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'guerrilla_mailX'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install guerrilla_mailX


### Getting started
----
###### Get new random mail Id:
You can use Guerrilla.new to get random email id which will be active only for 1 hour.
This method returns an object with attributes: `sid_token`, `email`, `time timestamp`,  `alias_id` and `valid_till`

    > guerrilla_mail = Guerrilla.new

You can also set your custom email:

    > guerrilla_mail = Guerrilla.new(custom_test)


###### To verify last received mail:
**_verify_last_mail_** can be used to verify body and subject of last mail received.
```sh
> guerrilla_mail.verify_last_mail(subject: "Welcome to guerrilla_mail")
```
While `subject:` is required argument and `body:` is optional. This method will return true for subject, if given string is present in last mail. Default wait time is 120 seconds, which you can change by argument `wait:` 

If you want to verify particular mail by offset in a list you can use:
```sh
> guerrilla_mail.verify_mail(subject: "Welcome to guerrilla_mail", offset: 3)
```
This will test 3rd email from last recently received mail. You can also provide `email_id:` if you dont want to use offset. You will get email_id from **_get_email_list_** method. In this wait time is also 120 sec but you can change it by providing `wait:` argument. You can also provide `body:` argument that takes a string and check if it is present in a mail body. This method returns hash for subject and body, if present they are set to true else false.

##### Methods available
- **initialize**
- **set_email_user**
- **verify_last_mail**
- **verify_mail**
- **check_email**
- **get_email_list**
- **fetch_email**
- **forget_me**
- **del_email**
- **get_older_list**

All these method can take `sid_token:` argument and then work for that sid_token.

##### Class methods available
- **get_email_address**
- **forget_me**
- **del_email**

#####  Reference
You can check Guerrilla Mail API and argument it takes from [Guerrilla Mail JSON API](https://docs.google.com/document/d/1Qw5KQP1j57BPTDmms5nspe-QAjNEsNg8cQHpAAycYNM)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/himanshu-thinkfuture/guerrilla_mailX. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/himanshu-thinkfuture/guerrilla_mailX/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GuerrillaMailX project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/himanshu-thinkfuture/guerrilla_mailX/blob/master/CODE_OF_CONDUCT.md).
