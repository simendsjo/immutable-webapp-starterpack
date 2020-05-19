const fs = require('fs');

const sha = 1;
const environment =  "test";
const url = 'https://ramslok-immutable-webapp-assets.s3.eu-north-1.amazonaws.com' ;
const date = new Date().toISOString();

const index = `<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Immutable webapp starterpack</title>
    <meta name="description" content="Immutable webapp.">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  </head>
  <body>
       <!--  env vars -->
       <script>
       env = {
           ENV_NAME: '${environment}',
           GIT_SHA: '${sha}',
           API_URL: '${url}',
           CREATED_AT: '${date}'
       }
       </script>
       <!-- application binding -->
       <app-root></app-root>
       <!-- fully-qualified static assets -->
       <script src="${url}/assets/${sha}/main.js" type="text/javascript"></script>
   </body>
</html>`;

fs.writeFile('index.html', index, 'utf8', function(){});
