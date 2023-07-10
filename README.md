# What does it do?
This NetworkManager class represents a network manager used to communicate with an API.

1.It sends HTTP requests using the Dio library.
2.Configures the base URL and how requests are handled.
3.Keeps a log of requests and responses.
4.Adds the authorization token to the headers of the requests.
5.Sets the timeout period for requests.
6.It provides the appropriate error handling mechanism in cases where requests fail.

# Key features of this class are:

- "_baseUrl": A constant containing the base URL of the API. Requests are configured based on this base URL.
- "_dio": The dio object is the main object used to perform HTTP requests. It is configured by the initiator and allows requests to be sent and responses received.
- "_onRequest": This method is an interceptor that is called every time a request is made. Edits the request configuration and adds the authorization token to the request headers.
- _getRequestOptions": This method generates request options for each request, such as timeout.
- "_handleError": This method provides the appropriate error handling mechanism in the event of an error. It checks for dio errors and throws an appropriate NetworkException.
- "_onError and _onResponse": These methods represent error and response interceptors. They currently do not take any action, just pass incoming errors and responses.

  #This class provides a generic network manager that supports common HTTP methods such as GET, POST, PUT, and DELETE. With these methods, you can make requests and receive responses from these requests.

  A special error class called NetworkException is also defined. This class can be used to represent network errors and raises a custom exception containing the error message.
