# elm-facebook-login

A completely basic Elm 0.17 app for logging in with facebook authorization

* Work in progress
* Model needs to describe the log-in statuses 
* View needs to display login/logout buttons  


(Readme copied and modified from https://github.com/moarwick/elm-webpack-starter)

### Install:
Clone this repo into a new project folder, e.g. `my-elm-project`, and install its dependencies:
```
git clone https://github.com/safhac/elm0.17-facebook-login my-elm-project
cd my-elm-project
npm install
```

Re-initialize the project folder as your own repo:
```
rm -rf .git
git init
git add .
git commit -m 'first commit'
```

Install Elm and elm-live globally:
```
npm install -g elm elm-live
```

Install Elm's dependencies:
```
elm package install
```
### Add a start script to your package.json
```
"start" : "elm-live src/Main.elm --output=src/main.js --port=8000 --open"
```
* Access app at `http://localhost:8000/`
* Get coding! The entry point file is `src/Main.elm`
* Browser will refresh automatically on any file changes..





