type alias Request = ##org.eclipse.jetty.server.Request
type alias HttpServletRequest = ##jakarta.servlet.http.HttpServletRequest
type alias HttpServletResponse = ##jakarta.servlet.http.HttpServletResponse
type alias Server = ##org.eclipse.jetty.server.Server
type alias AbstractHandler = ##org.eclipse.jetty.server.handler.AbstractHandler
type alias Handler = ##org.eclipse.jetty.server.Handler
type alias AbstractLifeCycle = ##org.eclipse.jetty.util.component.AbstractLifeCycle
type alias HandlerWrapper = ##org.eclipse.jetty.server.handler.HandlerWrapper
type alias ServletResponse = ##jakarta.servlet.ServletResponse

// The main entry point.
def main(): Unit & Impure =
    import new org.eclipse.jetty.server.Server(Int32): Server & Impure as newServer;
    import org.eclipse.jetty.server.handler.HandlerWrapper.setHandler(Handler): Unit & Impure;
    import org.eclipse.jetty.util.component.AbstractLifeCycle.start(): Unit & Impure;
    import org.eclipse.jetty.server.Server.join(): Unit & Impure;
    import org.eclipse.jetty.server.Request.setHandled(Bool): Unit & Impure;
    import jakarta.servlet.http.HttpServletResponse.setStatus(Int32): Unit & Impure;
    import jakarta.servlet.ServletResponse.getWriter(): ##java.io.PrintWriter & Impure;
    import jakarta.servlet.ServletResponse.setContentType(String): Unit & Impure;
    import java.io.PrintWriter.print(String): Unit & Impure;

    let server = newServer(8080);
    let handler = object ##org.eclipse.jetty.server.handler.AbstractHandler {
        def handle(_this: ##org.eclipse.jetty.server.handler.AbstractHandler, _target: String, jettyRequest: ##org.eclipse.jetty.server.Request, _request: ##jakarta.servlet.http.HttpServletRequest, response: ##jakarta.servlet.http.HttpServletResponse): Unit =
            setHandled(jettyRequest, true);
            setStatus(response, 200);
            setContentType(response as ServletResponse, "text/html; charset=UTF-8");
            let writer = getWriter(response as ServletResponse);
            print(writer, "<h1>Hello from Flix!</h1>")
    };
    setHandler(server as HandlerWrapper, handler as Handler);
    start(server as AbstractLifeCycle);
    join(server)
