part of fitlog_web_client;

@Injectable()
class Routes {

  void call(Router router, RouteViewFactory views) {
    views.configure({
      'entry_screen': ngRoute(path: '', defaultRoute: true, viewHtml: '<entry-screen></entry-screen>')
    });
  }
}
