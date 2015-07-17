
a javascript native code embed template with

* clear
* powerful
* Compatible

## fire

```
{{=0}}      //0
{{=false}}  //
{{=true}}   //true
{{=null}}   //

{{-'<'}}    // &lt;


{{
var a=0;
}}


{{ if(a===1){ }}

{{ }else if(a===2){ }}

{{ }else{ }}

{{ } }}


// sugar:

{{? a===1 }}     // if(a===1){

{{?? a===2 }}    // }else if(a===2){

{{??}}           // }else{

{{?}}            // }


{{~['a','b','c'] v}}
    {{-v}},             // a,b,c
{{~}}

{{~['a','b','c'] i,v}}
    {{-i}} {{-v}},      // 0 a,1 b,2 c,
{{~}}

```

render html

```javascript
var html=wheei('<h1>{{-it.title}}</h1>',{title:'wheei'}); // 'wheei'
```

get template function

```javascript
var func=wheei('<h1>{{-it.title}}</h1>');         // function(it){...}
func({title:'wheei'});                            // 'wheei'
```

third argument is conf

```javascript
var html=wheei('{{-data}}','ok',{argName:data}); // 'ok'
```

* open    `{{`
* close   `}}`
* argName `it`
* strip   `false`     strip white-space between line and line

the globel default is `wheei.conf`

* wheei is a global variable (because template function will access it)

## beyond

### inner template

```
{{#list data , a}}
    {{~data item}}
        <li>{{-item}}</li>
    {{~}}
    {{=a}}
{{#}}
{{=list(['first','second'],'aaa')}}
```

same to

```
{{function list(data , a){var __out='';}}
    {{~data item}}
        <li>{{-item}}</li>
    {{~}}
    {{=a}}
{{return __out;} }}
{{=list(['first','second'],'aaa')}}
```

### include template

```html
<script type="text/plain" id="list">
    {{~data item}}
        <li>{{-item}}</li>
    {{~}}
</script>
```

```javascript
wheei.tpls.list = wheei(document.getElementById('list').innerHTML);
```

```html
<script type="text/plain" id="page">
    <h1>in page</h1>
    {{=wheei.tpls.list(['first','second'])}}
</script>
```