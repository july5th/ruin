capybara-webkit

Capybara.current_session.driver.browser.manage.all_cookies
manage.delete_cookie(cookie_name)

require 'capybara'
Capybara.default_driver = :selenium

require 'capybara'
require 'capybara/poltergeist'
Capybara.current_driver = :poltergeist

include Capybara::DSL
@register_addr = "http://reg.email.163.com/unireg/call.do?cmd=register.entrance"
visit(@register_addr)



page.find(:xpath, "//a[@class='a1']").click
page.evaluate_script("document.getElementById(\"nameIpt\").focus();")
page.evaluate_script("document.getElementById(\"nameIpt\").click();")
page.find_by_id("nameIpt").set "lfr_0011222"
page.evaluate_script("document.getElementById(\"nameIpt\").blur();")
page.evaluate_script("document.getElementById(\"mainPwdIpt\").focus();")
page.evaluate_script("document.getElementById(\"mainPwdIpt\").click();")
page.find_by_id("mainPwdIpt").set "11112222llll"
page.evaluate_script("document.getElementById(\"mainPwdIpt\").blur();")
page.evaluate_script("document.getElementById(\"mainCfmPwdIpt\").focus();")
page.evaluate_script("document.getElementById(\"mainCfmPwdIpt\").click();")
page.find_by_id("mainCfmPwdIpt").set "11112222llll"
page.evaluate_script("document.getElementById(\"mainCfmPwdIpt\").blur();")

page.evaluate_script("document.getElementById(\"vcodeIpt\").focus();")
page.evaluate_script("document.getElementById(\"vcodeIpt\").click();")
page.find_by_id("vcodeIpt").set "UEEKB"
page.evaluate_script("document.getElementById(\"vcodeIpt\").blur();")

