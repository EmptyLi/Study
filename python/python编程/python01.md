```python
def Hcounter(name):
   count = [0]
   def counter():
      count[0] += 1
      print 'Hello, ',name, str(count[0]) + 'access'
   return counter

helloa = Hcounter("aaa")
helloa()
helloa()

hellob = Hcounter("bbb")
hellob()
hellob()
```
> 单元测试
```python
import unittest
def camel_to_underline(camel_format):
   underline_format = ''
   if isinstance(camel_format, str):
      underline_format += _s_ if _s_.islower() else '_' + _s_.lower()
   return underline_format

def underline_to_camel(underline_format):
   camel_format = ''
   if isinstance(underline_format, str):
      for _s_ in underline_format.split('_'):
         camel_format += _s_.capitalize()
   return camel_format

class TestCamelToUnderline(unittest.TestCase):
   def test_upper(self):
      camel = 'aaaBbbbCccc'
      underline = 'aaa_bbbb_cccc'
      self.assertEqual(camel_to_underline(camel), underline)

if __main__ == "__main__":
   unittest.main()
```
