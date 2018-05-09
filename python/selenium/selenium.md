```python
# The selenium.webdriver module provides all the WebDriver implementations
from selenium import webdriver
# The Keys class provide keys in the keyboard like RETURN, F1, ALT etc.
from selenium.webdriver.common.keys import Keys

# the instance of Firefox WebDriver is created.
driver = webdriver.Firefox()
# The driver.get method will navigate to a page given by the URL. WebDriver will wait until the page has fully loaded (that is, the “onload” event has fired) before returning control to your test or script. It’s worth noting that if your page uses a lot of AJAX on load then WebDriver may not know when it has completely loaded.
driver.get("http://www.python.org")
assert "Python" in driver.title
# WebDriver offers a number of ways to find elements using one of the find_element_by_* methods.
elem = driver.find_element_by_name("q")
# Next, we are sending keys, this is similar to entering keys using your keyboard. Special keys can be sent using Keys class imported from selenium.webdriver.common.keys. To be safe, we’ll first clear any pre-populated text in the input field (e.g. “Search”) so it doesn’t affect our search results:
elem.clear()
elem.send_keys("pycon")
elem.send_keys(Keys.RETURN)
assert "No results found." not in driver.page_source
# Finally, the browser window is closed. You can also call quit method instead of close. 
driver.close()
```
