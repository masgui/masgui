![MasGUI](https://i.imgur.com/hor5HIC.png)

[![GitHub release](https://img.shields.io/github/release/masgui/masgui.svg)](https://github.com/masgui/masgui/releases/latest)
[![David-DM](https://david-dm.org/masgui/masgui.svg)](https://david-dm.org/masgui/masgui)


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

[![Github All Releases](https://img.shields.io/github/downloads/electron/electron/total.svg)](https://github.com/electron)
* [Electron v1.7.11](https://github.com/electron/electron)
* [Electron Builder v19.55.3](https://github.com/electron-userland/electron-builder)
* [Vue.js v2.5.13](https://github.com/vuejs/vue)
* [Bootstrap v4.0](https://github.com/twbs/bootstrap)
* [Atom v1.23.3](https://github.com/atom/atom)

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
