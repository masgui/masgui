![MasGUI](https://i.imgur.com/hor5HIC.png)

[![GitHub release](https://img.shields.io/github/release/masgui/masgui.svg)](https://github.com/masgui/masgui/releases/latest)
[![David-DM](https://david-dm.org/masgui/masgui.svg)](https://david-dm.org/masgui/masgui)
[![Github commits (since latest release)](https://img.shields.io/github/commits-since/masgui/masgui/latest.svg)](https://github.com/masgui/masgui/commits/master)
[![](https://img.shields.io/github/issues-raw/masgui/masgui.svg)](https://github.com/masgui/masgui/issues)

This is a Miner which switches based on the current most profitable algorithm (checks every 5 minutes).

## Getting Started

Download the [latest Release](https://github.com/masgui/masgui/releases/latest) to get started quickly.
Enter your Wallet Address and the corresponding Coin Symbol below that. (Coin Symbol will be changed to dropdown of available coins)
Make sure to check the pool if it supports the coin you want to receive payouts in for now.

### Prerequisites

No prerequisites.

### Installing

To build the app on your machine:


```
git clone https://github.com/masgui/masgui.git
cd masgui
npm i
```

Run test build

```
In Directory: ../masgui/
npm run start
```



## Deployment

Package App for the OS you are running on

```
In Directory: ../masgui/
npm run dist
```
(Refer to [electron-builder](https://github.com/electron-userland/electron-builder) for use of "npm run dist")

## Built With

* [Electron ](https://electronjs.org/) [![GitHub release](https://img.shields.io/github/release/electron/electron.svg)](https://github.com/electron/electron/releases/latest)
* [Electron Builder ](https://github.com/electron-userland/electron-builder) [![GitHub release](https://img.shields.io/github/release/electron-userland/electron-builder.svg)](https://github.com/electron-userland/electron-builder/releases/latest)
* [Vue.js ](https://vuejs.org/) [![GitHub release](https://img.shields.io/github/release/vuejs/vue.svg)](https://github.com/vuejs/vue/releases/latest)
* [Bootstrap ](https://getbootstrap.com/) [![GitHub release](https://img.shields.io/github/release/twbs/bootstrap.svg)](https://github.com/twbs/bootstrap/releases/latest)
* [Atom ](https://atom.io/) [![GitHub release](https://img.shields.io/github/release/atom/atom.svg)](https://github.com/atom/atom/releases/latest)

## Contributing

Please read [CONTRIBUTING.md](https://github.com/masgui/masgui/CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/masgui/masgui/tags).

## Authors

* **Tanis Webb** - *Initial work* - [DoctorORBiT](https://github.com/stockbrot)

See also the list of [contributors](https://github.com/masgui/masgui/contributors) who participated in this project.

## Acknowledgments

* NemosMiner v2.4.2 (modified)
* [DeathPosion](https://github.com/DeathPoison)
