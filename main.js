const electron = require('electron')
const {
  app,
  BrowserWindow
} = electron

const path = require('path')
const url = require('url')

let mainWindow

function createWindow() {
  let {
    width,
    height
  } = electron.screen.getPrimaryDisplay().workAreaSize

  if (width <= 1700) {
    width = 1700
  }

  mainWindow = new BrowserWindow({
    width: width * .5,
    height: height * .9,
    frame: false
  })

  mainWindow.loadURL(url.format({
    pathname: path.join(__dirname, 'index.html'),
    protocol: 'file:',
    slashes: true
  }))

  mainWindow.on('closed', function() {
    mainWindow = null
  })
}

app.on('ready', createWindow)

app.on('window-all-closed', function() {
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', function() {
  if (mainWindow === null) {
    createWindow()
  }
})
