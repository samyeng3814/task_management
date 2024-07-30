abstract class BaseConfig {
  String get login;
  String get register;
  String get users;
  String get taskService;
}

const authUrl = "https://reqres.in/api/";
const taskServiceUrl = 'https://jsonplaceholder.typicode.com/todos/';

class DevConfig implements BaseConfig {
  @override
  String get login => "${authUrl}login/";

  @override
  String get register => "${authUrl}register/";

  @override
  String get users => "${authUrl}users/";

  @override
  String get taskService => taskServiceUrl;
}
