# My Shop 🛒
## Covered Futures :
- State Managment with Provider
- MultiProvider with ProxyChangeNotifier
- FireBase 
  - Email Authentication
  - RealTime Databse
- Basic Animation
- Custom Page Transition 
- Custom Exception builder
- Managing Data & UI Efficiently 
  
</br>

---
###  (😊)=> Create a constans file
at lib/utils/constants.dart add this two constans line of code
- const BASE_API_REALTIMEdb = your firebase App link.
- const WEB_API_KEY = goto project settings and paste web api key here.

This has been removed for app security purpose. Also described on [.gitignore](https://github.com/yeasin50/My-Shop/blob/master/.gitignore#L2-L6) for more. 
  


<center>  🔔 Lines are mentioned as TODO & FIXME </center>

------

## Firebase Rules
~~~
{
  "rules": {
    ".read": "auth !=null",  
    ".write": "auth !=null",
    "products":{
      ".indexOn":["creatorId"]
    }
  }
}
~~~
-----

### Getting Started
This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
