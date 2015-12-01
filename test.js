// Generated by LiveScript 1.4.0
(function(){
  var test, e;
  require('./wheei');
  test = function(text, arg, res, conf){
    var func;
    func = wheei(text, null, conf);
    if (res !== func(arg)) {
      console.log(func.toString());
      throw new Error(text + " noteq " + res);
    } else {
      return console.log("OK: " + text);
    }
  };
  test("<%*\nthis is a comment\nthis is a comment\nthis is a comment\nthis is a comment\n%>", {}, '');
  test(" aaaa ", {}, ' aaaa ');
  test(" \\\"\"\" \\''' ", {}, " \\\"\"\" \\''' ");
  test(" a\n\na <%=''%> c\n\n     b\n\n", {}, 'aa  cb', {
    strip: true
  });
  test("<%var a=1,b={};__out+=1;%>", {}, '1');
  test("<%=0%>", {}, '0');
  test("<%='0'%>", {}, '0');
  test("<%=false%>", {}, '');
  test("<%=true%>", {}, 'true');
  test("<%=null%>", {}, '');
  test("<%={} %>", {}, '[object Object]');
  test("<%=function(a,b){return a<b;} %>", {}, 'function (a,b){return a<b;}');
  test("<%-0%>", {}, '0');
  test("<%-'/\\'\"<>&'%>", {}, '&#47;&#39;&#34;&lt;&gt;&amp;');
  test("<%-'0'%>", {}, '0');
  test("<%-false%>", {}, '');
  test("<%-true%>", {}, 'true');
  test("<%-null%>", {}, '');
  test("<%-{} %>", {}, '[object Object]');
  test("<%-function(a,b){return a<b;} %>", {}, 'function (a,b){return a&lt;b;}');
  test("b<%if(false){%>aa<%}else if(false){%>cc<%}else{%>dd<% } %>b", {}, 'bddb');
  test("<%-it%>", wheei.markSafe('<'), '<');
  test("<%=it%>", wheei.markSafe('<'), '<');
  test("b<%?false%>aa<%?%>b", {}, 'bb');
  test("b<%?true%>aa<%?%>b", {}, 'baab');
  test("b<%?false%>aa<%??%>cc<%?%>b", {}, 'bccb');
  test("b<%?true%>aa<%??%>cc<%?%>b", {}, 'baab');
  test("b<%?false%>aa<%??false%>cc<%??true%>dd<%?%>b", {}, 'bddb');
  test("<%~[1,2,3] i,v%><%=i%><%=v%><%~%>", {}, '011223');
  test('<%function list(data){\n    var __out=\'\';\n%>\n    <%~data item%>\n        <li><%-item%></li>\n    <%~%>\n<%\n    return __out;\n}\n%>\n<%=list([\'first\',\'second\'])%>', {}, '<li>first</li><li>second</li>', {
    strip: true
  });
  test('<%=list([\'first\',\'second\'],\'aaa\')%>\n<%#list data , a%>\n    <%~data item%>\n        <li><%-item%></li>\n    <%~%>\n    <%=a%>\n<%#%>', {}, '<li>first</li><li>second</li>aaa', {
    strip: true
  });
  try {
    test('<%~[1,2,3] k,v%>\n\n<%?%>', {}, '');
    throw new Error('ERROR: unclosed check');
  } catch (e$) {
    e = e$;
    if (~e.message.indexOf('[wheei complie error] unclosed `~`')) {
      console.log("OK: unclosed check");
    } else {
      throw e;
    }
  }
  try {
    test('\n<%?%>', {}, '');
    throw new Error('ERROR: unopend check');
  } catch (e$) {
    e = e$;
    if (~e.message.indexOf('[wheei complie error] unopend `?`')) {
      console.log("OK: unopend check");
    } else {
      throw e;
    }
  }
  try {
    test('\n<%varr a%>', {}, '');
    throw new Error('ERROR: new Function check');
  } catch (e$) {
    e = e$;
    if (~e.message.indexOf('[wheei new Function error]')) {
      console.log("OK: new Function check");
    } else {
      throw e;
    }
  }
}).call(this);
