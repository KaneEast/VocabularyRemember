### 1. **Powering the Web**
   - **HTTP (HyperText Transfer Protocol)** is the backbone of the web.
   - Each website visit involves sending HTTP requests and receiving responses.
   - Many apps, like ordering coffee, streaming videos, or online gaming, utilize HTTP behind the scenes.
   - HTTP involves a client (e.g., iOS app, web browser, cURL session) and a server. The client sends an HTTP request, and the server provides an HTTP response.

### 2. **HTTP Requests**
   - Components:
     - **Request line**: Specifies HTTP method, requested resource, and HTTP version (e.g., `GET /about.html HTTP/1.1`).
     - **Host**: Server name that will manage the request. Needed when multiple servers share an address.
     - **Request headers**: Examples include Authorization, Accept, Cache-Control, Content-Length, Content-Type, etc.
     - **Optional request data**: Required by some HTTP methods.
   - **HTTP Methods**:
     - GET, HEAD, POST, PUT, DELETE, CONNECT, OPTIONS, TRACE, PATCH
     - **GET**: Retrieve a resource (e.g., clicking a link or tapping a news story).
     - **POST**: Send data to a server (e.g., logging in).
   - **Request Headers**: Key-value pairs providing additional info. Common ones include Authorization, Cookie, Content-Type, and Accept.

### 3. **HTTP Responses**
   - Components:
     - **Status line**: Contains version, status code, and message.
     - **Response headers**.
     - **Optional response body**.
   - Status codes are grouped by the first digit:
     - **1xx**: Informational.
     - **2xx**: Success (e.g., 200 OK).
     - **3xx**: Redirection.
     - **4xx**: Client error (e.g., 404 Not Found).
     - **5xx**: Server error.
   - Fun Fact: 418 I'm a teapot is an April Fools’ joke status code.
   - Responses might include HTML content, images, JSON data, etc.

### 4. **HTTP in Web Browsers**
   - Browsers send a GET request to load a page.
   - External assets like images, JS, CSS trigger additional GET requests.
   - Page rendering depends on the `<head>` and `<body>` HTML sections.
   - Browsers mainly use GET and POST methods.
   - Customizing request headers in browsers requires JavaScript.

### 5. **HTTP in iOS Apps**
   - iOS apps can utilize all HTTP methods, add custom request headers, and customize response handling.
   - This provides flexibility and freedom in development.

### 6. **HTTP 2.0**
   - Modern web services primarily use HTTP/1.1 (from RFC 2068 in 1997).
   - HTTP/2 improves efficiency and latency, supporting parallel requests and server push capabilities.
   - Vapor supports both HTTP/1.1 and HTTP/2.

### 7. **REST (Representational State Transfer)**
   - An architectural standard closely related to HTTP.
   - Many apps use RESTful APIs.
   - REST standardizes resource access, simplifying client development.
   - Example endpoints for an words API: 
     - GET /api/words/: Retrieve all words.
     - POST /api/words: Create a new word.
     - GET /api/words/1: Retrieve the word with ID 1.
     - PUT /api/words/1: Update the word with ID 1.
     - DELETE /api/words/1: Delete the word with ID 1.