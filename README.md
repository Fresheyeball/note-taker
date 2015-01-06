Note Taker

A mobile web-app for taking notes!

===

### Execute!
To run this application you will need `node.js` installed. If you do not have `node.js` installed please do so here: http://nodejs.org/

Then simply run 
```
    sudo sh init.sh
```
at the root of this project to get all remaining dependencies and start the server. The application will be available at `http://localhost/`.

### Tests

get dependencies
```
    sudo npm install -g karma karma-cli
```

run tests
```
    gulp test
```

### Dev

Write code, see updates:
```
    sudo gulp watch
```
and
```
    sudo gulp
```
in separate terminals (or `nohup`)

#### Notes

This is not teseted on Android in any way. 
