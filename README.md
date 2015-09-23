
a javascript native code embed template with

* clear
* powerful
* Compatible


compare with similar libs

|            | ejs | dot | wheei |
|------------|:---:|:---:|:-----:|
| javascript |  √  |  √  |   √   |
| shortcut   |  ×  |  √  |   √   |
| debug      |  √  |  ×  |   √   |
| {{!0}}     |  √  |  ×  |   √   |
| mark safe  |  ×  |  ×  |   √   |



## fire

```
<%=0%>      //0
<%=false%>  //
<%=true%>   //true
<%=null%>   //

<%-'<'%>    // &lt;


<%
var a=0;
%>


<% if(a===1){ %>

<% }else if(a===2){ %>

<% }else{ %>

<% } %>


// shortcut:

<%? a===1 %>     // if(a===1){

<%?? a===2 %>    // }else if(a===2){

<%??%>           // }else{

<%?%>            // }


<%var arr=['a','b','c'];if(arr)for(var i=0;i<arr.length){var v=arr[i];%>
    <%-i%> <%-v%>,      // 0 a,1 b,2 c,
<%}%>

// shortcut:

<%~['a','b','c'] i,v%>
    <%-i%> <%-v%>,      // 0 a,1 b,2 c,
<%~%>

<%~['a','b','c'] v%>
    <%-v%>,             // a,b,c
<%~%>

```

render html

```javascript
var html=wheei('<h1><%-it.title%></h1>',{title:'wheei'}); // 'wheei'
```

get template function

```javascript
var func=wheei('<h1><%-it.title%></h1>');         // function(it){...}
func({title:'wheei'});                            // 'wheei'
```

third argument is conf

```javascript
var html=wheei('<%-data%>','ok',{argName:data}); // 'ok'
```

* open    `<%`
* close   `%>`
* argName `it`
* strip   `false`     strip white-space between line and line

the globel default is `wheei.conf`

* wheei is a global variable (because template function will access it)

## beyond

### mark safe

```javascript
    wheei('<%-it%>','<a href="xxx">xxx</a>'); // you will get a `<a href="xxx">xxx</a>` text
    wheei('<%-it%>',wheei.markSafe('<a href="xxx">xxx</a>')); // you will get a link element
    wheei('<%=it%>',wheei.markSafe('<a href="xxx">xxx</a>')); // you will get a link element too
```


### inner template

```
<%#list data , a%>
    <%~data item%>
        <li><%-item%></li>
    <%~%>
    <%=a%>
<%#%>
<%=list(['first','second'],'aaa')%>
```

same to

```
<%function list(data , a){var __out='';%>
    <%~data item%>
        <li><%-item%></li>
    <%~%>
    <%=a%>
<%return __out;} %>
<%=list(['first','second'],'aaa')%>
```

### include template

```html
<script type="text/plain" id="list">
    <%~data item%>
        <li><%-item%></li>
    <%~%>
</script>
```

```javascript
wheei.tpls.list = wheei(document.getElementById('list').innerHTML);
```

```html
<script type="text/plain" id="page">
    <h1>in page</h1>
    <%=wheei.tpls.list(['first','second'])%>
</script>
```

## nodejs with express

`npm install wheei --save`

```javascript
var wheei=require('wheei');
var path=require('path');

app.engine('whe',wheei.__express);
app.set('view engine', 'whe');
app.set('views', path.join(__dirname,'views'));
// if `view cache` is `true`,you have to restart server after `.whe` file change
app.set('view cache', true||false);
```

### include

`index.whe`:

```
index.whe
<%@ 'whe/a.whe','hello'%>
index.whe
```

`whe/a.whe`:

```
a.whe:<%=it%>
```

result is:

```
index.whe
a.whe:hello
index.whe
```

#### about the path

just like linux `cd`

* the root is `app.set('views', path.join(__dirname,'views'))`
* `absolute` start with `/`,like `/index.whe`
* `relative` like `whe/a.whe` `./whe/a.whe` `../index.whe`