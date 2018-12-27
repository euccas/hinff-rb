##############################################################
##  Ruby Code Rstone -- Email
##  File Name:   email.rb
##  Owner:  Euccas Chen <euccas.chen@gmail.com>
##############################################################

module Rstone
  require 'net/smtp'

  def send_mail(smtp_host, smtp_port, sender, to, cc, message)
    smtp = Net::SMTP.new smtp_host, smtp_port
    recipients = Array.new
    recipients = to + cc
    smtp.start() do |smtp|
      smtp.send_message(message, sender, recipients)
    end
  end

  def gen_mail_recipients(domain, users)
    ### input: [string] domain, [array] recipient user accounts
    ### output: [array] recipients
    addrs = Array.new
    if is_var_defined(domain) == true
      users.each do |u|
        if is_var_defined(u)
          addrs.push(u + '@' + domain)
        end
      end
    end
    return addrs
  end

  def gen_mail_recipients_str(domain, users)
    ### input: [string] domain, [array] recipient user accounts
    ### output: [string] recipients
    addrs = Array.new
    if is_var_defined(domain) == true
      users.each do |u|
        if is_var_defined(u)
          addrs.push(u + '@' + domain)
        end
      end
    end
    recipients = addrs.join(', ')
    return recipients
  end

  def gen_mail_style_html(css_file)
    ### input: [file] css file describing styles
    ### output: [string] code used in html for style
    css = File.read(css_file)
    style =<<-END_STYLE
    <style>#{css}</style>
    END_STYLE
    return style
  end

  def gen_mail_shorturl_html(url, length)
    ### output: [string] html code for a link to shorturl
    # default use at least 6 characters as shorturl
    if length <= 6
      length = 6
    end
    shorturl = 'http://' + rand(36**length).to_s(36)
    shorturl_html =<<-END_shorturl_html
    <a href="#{url}" target=_blank>#{shorturl}</a>
    END_shorturl_html

    return shorturl_html
  end

end # Module: Rstone
