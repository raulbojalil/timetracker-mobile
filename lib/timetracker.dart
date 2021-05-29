import 'dart:convert';
import 'dart:io';

import 'package:web_scraper/web_scraper.dart';

class TimeTracker {
  static dynamic _cookies;

  static Future<String> login(username, password) async {
    final webScraper = WebScraper();
    final getHtml =
        await _httpRequest("https://timetracker.bairesdev.com", "get", null);

    webScraper.loadFromString(getHtml);
    final viewState =
        webScraper.getElement('input[name="__VIEWSTATE"]', ['value'])[0]
            ["attributes"]["value"];
    final viewStateGenerator = webScraper
            .getElement('input[name="__VIEWSTATEGENERATOR"]', ['value'])[0]
        ["attributes"]["value"];
    final eventValidation =
        webScraper.getElement('input[name="__EVENTVALIDATION"]', ['value'])[0]
            ["attributes"]["value"];

    final postHtml =
        await _httpRequest("https://timetracker.bairesdev.com/", "post", {
      '__EVENTTARGET': '',
      '__EVENTARGUMENT': '',
      '__VIEWSTATE': viewState,
      '__VIEWSTATEGENERATOR': viewStateGenerator,
      '__EVENTVALIDATION': eventValidation,
      'ctl00\$ContentPlaceHolder\$UserNameTextBox': username,
      'ctl00\$ContentPlaceHolder\$PasswordTextBox': password,
      'ctl00\$ContentPlaceHolder\$LoginButton': 'Login',
      'ctl00\$ContentPlaceHolder\$clientTimezoneOffset': '300',
    });

    return postHtml;
  }

  static Future<String> listaTimeTracker(start, end) async {
    final webScraper = WebScraper();
    final getHtml = await _httpRequest(
        "https://timetracker.bairesdev.com/ListaTimeTracker.aspx", "get", null);

    webScraper.loadFromString(getHtml);

    final postHtml = await _httpRequest(
        "https://timetracker.bairesdev.com/ListaTimeTracker.aspx", "post", {
      '__EVENTTARGET': 'ctl00\$ContentPlaceHolder\$AplicarFiltroLinkButton',
      '__EVENTARGUMENT': '',
      '__VIEWSTATE':
          webScraper.getElement('input[name="__VIEWSTATE"]', ['value'])[0]
              ["attributes"]["value"],
      '__VIEWSTATEGENERATOR': webScraper
              .getElement('input[name="__VIEWSTATEGENERATOR"]', ['value'])[0]
          ["attributes"]["value"],
      '__VIEWSTATEENCRYPTED': '',
      '__EVENTVALIDATION':
          webScraper.getElement('input[name="__EVENTVALIDATION"]', ['value'])[0]
              ["attributes"]["value"],
      'ctl00\$ContentPlaceHolder\$txtFrom': start,
      'ctl00\$ContentPlaceHolder\$txtTo': end
    });

    final responseWebScraper = WebScraper();
    responseWebScraper.loadFromString(postHtml);

    return postHtml;
  }

  static Future<String> cargaTimeTracker(from, idProyecto, tiempo,
      idTipoAsignacion, descripcion, idFocalPointClient) async {
    final webScraper = WebScraper();

    final getHtml = await _httpRequest(
        "https://timetracker.bairesdev.com/CargaTimeTracker.aspx", "get", null);

    webScraper.loadFromString(getHtml);

    final loadProjectIntoSessionHtml = await _httpRequest(
        "https://timetracker.bairesdev.com/CargaTimeTracker.aspx", "post", {
      'ctl00\$ContentPlaceHolder\$ScriptManager':
          'ctl00\$ContentPlaceHolder\$UpdatePanel1|ctl00\$ContentPlaceHolder\$idProyectoDropDownList',
      '__VIEWSTATE':
          webScraper.getElement('input[name="__VIEWSTATE"]', ['value'])[0]
              ["attributes"]["value"],
      '__VIEWSTATEGENERATOR': webScraper
              .getElement('input[name="__VIEWSTATEGENERATOR"]', ['value'])[0]
          ["attributes"]["value"],
      '__EVENTVALIDATION':
          webScraper.getElement('input[name="__EVENTVALIDATION"]', ['value'])[0]
              ["attributes"]["value"],
      'ctl00\$ContentPlaceHolder\$txtFrom': from,
      'ctl00\$ContentPlaceHolder\$idProyectoDropDownList': idProyecto,
      'ctl00\$ContentPlaceHolder\$DescripcionTextBox': '',
      'ctl00\$ContentPlaceHolder\$TiempoTextBox': '',
      'ctl00\$ContentPlaceHolder\$idTipoAsignacionDropDownList': '',
      'ctl00\$ContentPlaceHolder\$idFocalPointClientDropDownList': '',
      '__ASYNCPOST': 'true'
    });

    final loadHoursHtml = await _httpRequest(
        "https://timetracker.bairesdev.com/CargaTimeTracker.aspx", "post", {
      '__VIEWSTATE': _searchValue(r'hiddenField\|__VIEWSTATE\|([\w*/*\+*=*]*)',
          loadProjectIntoSessionHtml),
      '__VIEWSTATEGENERATOR': _searchValue(
          r'hiddenField\|__VIEWSTATEGENERATOR\|([\w*/*\+*=*]*)',
          loadProjectIntoSessionHtml),
      '__EVENTVALIDATION': _searchValue(
          r'hiddenField\|__EVENTVALIDATION\|([\w*/*\+*=*]*)',
          loadProjectIntoSessionHtml),
      '__EVENTTARGET': _searchValue(
          r'hiddenField\|__EVENTTARGET\|([\w*/*\+*=*]*)',
          loadProjectIntoSessionHtml),
      '__EVENTARGUMENT': _searchValue(
          r'hiddenField\|__EVENTARGUMENT\|([\w*/*\+*=*]*)',
          loadProjectIntoSessionHtml),
      '__LASTFOCUS': _searchValue(r'hiddenField\|__LASTFOCUS\|([\w*/*\+*=*]*)',
          loadProjectIntoSessionHtml),
      'ctl00\$ContentPlaceHolder\$txtFrom': from,
      'ctl00\$ContentPlaceHolder\$idProyectoDropDownList': idProyecto,
      'ctl00\$ContentPlaceHolder\$DescripcionTextBox': descripcion,
      'ctl00\$ContentPlaceHolder\$TiempoTextBox': tiempo,
      'ctl00\$ContentPlaceHolder\$idTipoAsignacionDropDownList':
          idTipoAsignacion,
      'ctl00\$ContentPlaceHolder\$idFocalPointClientDropDownList':
          idFocalPointClient,
      'ctl00\$ContentPlaceHolder\$btnAceptar': 'Accept'
    });

    return loadHoursHtml;
  }

  static String _searchValue(regex, text) {
    RegExp exp = new RegExp(regex);
    Iterable<RegExpMatch> matches = exp.allMatches(text);
    for (var match in matches) {
      return match.group(1);
    }
    return "";
  }

  static Future<dynamic> _getRequest(
      HttpClient client, String method, String url) async {
    if (method == "post") return await client.postUrl(Uri.parse(url));
    if (method == "put") return await client.putUrl(Uri.parse(url));
    if (method == "patch") return await client.patchUrl(Uri.parse(url));

    return await client.getUrl(Uri.parse(url));
  }

  static Future<String> _httpRequest(String url, method, Map bodyMap) async {
    HttpClient client = new HttpClient();

    HttpClientRequest request = await _getRequest(client, method, url);

    request.headers.set('authority', 'timetracker.bairesdev.com');
    request.headers.set('pragma', 'no-cache');
    request.headers.set('cache-control', 'no-cache');
    request.headers.set('Origin', 'http://timetracker.bairesdev.com');
    request.headers.set('upgrade-insecure-requests', '1');
    request.headers.set('dnt', '1');
    request.headers.set('User-Agent',
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36');
    request.headers.set('accept',
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9');
    request.headers.set('sec-fetch-dest', 'document');
    request.headers.set('sec-fetch-mode', 'cors');
    request.headers.set('sec-fetch-site', 'same-origin');
    request.headers.set('sec-fetch-user', '?1');
    request.headers.set('Referer', url);
    request.headers.set('accept-language', 'es-419,es;q=0.9,de;q=0.8');

    if (_cookies != null) request.cookies.addAll(_cookies);

    var bodyContent = "";

    if (bodyMap != null) {
      bodyContent = _encode(bodyMap);
      var bodyAsText = utf8.encode(bodyContent);

      request.headers.set('Content-Length', bodyAsText.length.toString());
      request.headers.set(
          'content-type', 'application/x-www-form-urlencoded; charset=UTF-8');

      request.add(bodyAsText);
    }

    HttpClientResponse response = await request.close();

    if (response.statusCode != 200 && response.statusCode != 302) {
      throw new Exception(response.reasonPhrase);
    }

    if (method == "post" && response.cookies.length > 0)
      _cookies = response.cookies;

    String reply = await response.transform(utf8.decoder).join();

    if (reply == "" || reply == null) return null;

    return reply;
  }

  static String _encode(Map bodyMap) {
    var list = [];
    for (var key in bodyMap.keys) {
      list.add(
          "${Uri.encodeQueryComponent(key)}=${Uri.encodeQueryComponent(bodyMap[key])}");
    }

    return list.join("&");
  }
}
