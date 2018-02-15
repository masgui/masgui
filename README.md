<div style="text-align:center"><img src="img/header.png" /></div

[![GitHub release](https://img.shields.io/github/release/masgui/masgui.svg?style=flat-square)](https://github.com/masgui/masgui/releases/latest)
[![David-DM](https://david-dm.org/masgui/masgui.svg?style=flat-square)](https://david-dm.org/masgui/masgui)
[![Github commits (since latest release)](https://img.shields.io/github/commits-since/masgui/masgui/latest.svg?style=flat-square)](https://github.com/masgui/masgui/commits/master)
[![](https://img.shields.io/github/issues-raw/masgui/masgui.svg?style=flat-square)](https://github.com/masgui/masgui/issues)
[![Github All Releases](https://img.shields.io/github/downloads/masgui/masgui/total.svg)]()

This is a Miner which switches based on the current most profitable algorithm (checks every 5 minutes).

## Latest additions

### MasGUI v1.2.0

* Moved optional Settings to a seperate menu
* Added a Saving and Loading Profile feature

### MasGUI v1.1.1

* ~~You can now select "All Pools" to switch automatically between all the pools (except Blazepool for now)~~
* Pool switching has been removed for now as it seemed to be bugged

### MasGUI v1.1.0

Additons:
* ~~You can now select "All Pools" to switch automatically between all the pools (except Blazepool for now)~~
* Pool switching has been removed for now as it seemed to be bugged
* Added Website links beneath the pool select
* Added more information beneath the pool select
* Added Buttons for checking your current Profit (based on entered Wallet Address)

## Getting Started

Download the [latest Release](https://github.com/masgui/masgui/releases/latest) to get started quickly.
Enter your Wallet Address and select the corresponding Coin symbol, thats it! :)

### Prerequisites

(Only download from trusted sources)

On Windows 7, 8 or 8.1:
* [Update Powershell](https://www.microsoft.com/en-us/download/details.aspx?id=50395)

CCMiner may need:
* [MSVCR120.dll](https://www.microsoft.com/en-gb/download/details.aspx?id=40784)
* [VCRUNTIME140.DLL](https://www.microsoft.com/en-us/download/details.aspx?id=48145)

Other requirements:
* [Node.JS](https://nodejs.org/en/download/)


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

## Troubleshooting

For now, no errors or issues have been reported.
If you encounter anything please post it to the [issue tracker](https://github.com/masgui/masgui/issues)

## Built With

* [Electron ](https://electronjs.org/) [![GitHub release](https://img.shields.io/github/release/electron/electron.svg?style=flat-square)](https://github.com/electron/electron/releases/latest)
* [Electron Builder ](https://github.com/electron-userland/electron-builder) [![GitHub release](https://img.shields.io/github/release/electron-userland/electron-builder.svg?style=flat-square)](https://github.com/electron-userland/electron-builder/releases/latest)
* [Vue.js ](https://vuejs.org/) [![GitHub release](https://img.shields.io/github/release/vuejs/vue.svg?style=flat-square)](https://github.com/vuejs/vue/releases/latest)
* [Bootstrap ](https://getbootstrap.com/) [![GitHub release](https://img.shields.io/github/release/twbs/bootstrap.svg?style=flat-square)](https://github.com/twbs/bootstrap/releases/latest)
* [Atom ](https://atom.io/) [![GitHub release](https://img.shields.io/github/release/atom/atom.svg?style=flat-square)](https://github.com/atom/atom/releases/latest)

## Contributing

Please read [CONTRIBUTING.md](https://github.com/masgui/masgui/CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/masgui/masgui/tags).

## Authors

* **Tanis Webb** - *Initial work* - [DoctorORBiT](https://github.com/stockbrot)

See also the list of [contributors](https://github.com/masgui/masgui/contributors) who participated in this project.

## Donate

* ETH: 0x5D28b0038756EE67CAc6eF003507B9E36745f0cF
* DGB: D6VmxuuEDDxY2uSkMLUVS4GGXTEP8Xwnxu

## Acknowledgments

* [NemosMiner v2.4.2 (modified)](https://github.com/nemosminer/NemosMiner-v2.4.2)
* [DeathPosion](https://github.com/DeathPoison)
* [Shields.io](https://shields.io/)
