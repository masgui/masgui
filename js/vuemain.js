/*global Vue */
/*eslint no-unused-vars: */
/*eslint no-undef: */

var fs = require('fs')

const vueapp = new Vue({
    el: '#vueapp',
    data: {
        startM: true,
        saveName: '',
        gpulist: '',
        command: '',
        checkedAlgos: [],
        alglolist: '',
        coinsymbols: [
            'ABY', 'ACP', 'ALQO', 'ARG', 'ARTX', 'AUR', 'BELA', 'BERN', 'BLAS', 'BOLI', 'BSD', 'BTB', 'BTC', 'BTCZ', 'BTQ', 'BTX', 'CANN', 'CDN', 'CESC', 'CHAN', 'COPPER', 'CPN', 'CRC', 'CRW', 'DASH', 'DFS', 'DGB', 'DGC', 'DNR', 'DOGE', 'DSR', 'EDC', 'EDDIE', 'EFL', 'ELM', 'EQT', 'EVO', 'FLO', 'FTC', 'GAME', 'GBX', 'GEERT', 'GRS', 'GUN', 'HBC', 'HOLD', 'HPC', 'HSR', 'HUSH', 'INN', 'IRL', 'KASH', 'KMD', 'KRONE', 'LBC', 'LBTC', 'LEA', 'LTC', 'LTCU', 'LUX', 'MAC', 'MAR', 'MARS', 'MATRX', 'MAX', 'MAY', 'MBL', 'MEC', 'MONA', 'MONK', 'MUE', 'MZC', 'NEVA', 'NKC', 'NLG', 'NOTE', 'NVC', 'NYC', 'ONEX', 'ONX', 'ORB', 'PAK', 'PBS', 'PCOIN', 'PHILS', 'PINK', 'PIZZA', 'PLC', 'PLYS', 'PPC', 'PTC', 'PURA', 'Q2C', 'QTL', 'RAP', 'RUP', 'SAND', 'SIB', 'SKR', 'SMC', 'SONG', 'SPK', 'START', 'SXC', 'TAJ', 'THC', 'TIT', 'TRC', 'TZC', 'UIS', 'UNB', 'UNIC', 'VSX', 'VTC', 'WDC', 'XCT', 'XMCC', 'XMG', 'XMY', 'XRE', 'XSH', 'XVG', 'ZCL', 'ZSE', 'ZYD'
        ],
        coinsymbol: '',
        poolwebsites: {
            ahashpool: 'https://www.ahashpool.com/',
            blazepool: 'http://blazepool.com/',
            hashrefinery: 'http://pool.hashrefinery.com/',
            minemoney: 'https://www.minemoney.co/',
            miningpoolhub: 'https://miningpoolhub.com/',
            nicehash: 'https://www.nicehash.com/',
            zergpool: 'http://zergpool.com/',
            zpool: 'http://www.zpool.ca/'
        },
        poolwalletwebsites: {
            ahashpool: 'https://www.ahashpool.com/wallet.php?wallet=',
            blazepool: 'http://blazepool.com/wallet.html?btc=',
            hashrefinery: 'http://pool.hashrefinery.com/?address=',
            minemoney: 'https://www.minemoney.co/?address=',
            miningpoolhub: 'https://miningpoolhub.com/index.php?page=login',
            nicehash: 'https://www.nicehash.com/miner/',
            zergpool: 'http://zergpool.com/?address=',
            zpool: 'http://www.zpool.ca/?address='
        },
        poolnames: [
            'AHashpool',
            'Blazepool',
            'Hashrefinery',
            'Minemoney',
            'Miningpoolhub',
            'Nicehash',
            'Zergpool',
            'Zpool'
        ],
        poolname: '',
        pools: {
            allpools: ['bitcore', 'blake2s', 'blakecoin', 'c11', 'cryptonight', 'equihash', 'ethash', 'groestl', 'hsr', 'keccak', 'lbry', 'Lyra2RE2', 'lyra2z', 'MyriadGroestl', 'neoscrypt', 'Nist5', 'phi', 'poly', 'sib', 'skein', 'skunk', 'timetravel', 'tribus', 'x11evo', 'x11gost', 'x17', 'xevan', 'yescrypt'],
            ahashpool: ['xevan', 'hsr', 'phi', 'tribus', 'c11', 'lbry', 'skein', 'sib', 'bitcore', 'x17', 'Nist5', 'MyriadGroestl', 'Lyra2RE2', 'neoscrypt', 'blake2s', 'skunk'],
            blazepool: ['xevan', 'hsr', 'phi', 'tribus', 'c11', 'skein', 'groestl', 'sib', 'bitcore', 'x17', 'Nist5', 'Lyra2RE2', 'neoscrypt', 'blake2s', 'yescrypt', 'blakecoin', 'keccak'],
            hashrefinery: ['skunk', 'xevan', 'tribus', 'skein', 'bitcore', 'x17', 'Nist5', 'Lyra2RE2', 'neoscrypt'],
            minemoney: ['poly', 'hsr', 'keccak', 'xevan', 'skunk', 'tribus', 'c11', 'x11evo', 'lbry', 'phi', 'skein', 'groestl', 'timetravel', 'sib', 'bitcore', 'x17', 'blakecoin', 'Nist5', 'MyriadGroestl', 'Lyra2RE2', 'neoscrypt', 'blake2s'],
            miningpoolhub: ['ethash', 'cryptonight', 'keccak', 'lyra2z', 'skein', 'equihash', 'groestl', 'MyriadGroestl', 'Lyra2RE2', 'neoscrypt'],
            nicehash: ['ethash', 'x11gost', 'cryptonight', 'keccak', 'skunk', 'lbry', 'equihash', 'Nist5', 'Lyra2RE2', 'neoscrypt', 'blake2s'],
            zergpool: ['hsr', 'xevan', 'skunk', 'tribus', 'phi', 'c11', 'skein', 'groestl', 'sib', 'bitcore', 'x17', 'Nist5', 'MyriadGroestl', 'Lyra2RE2', 'neoscrypt', 'blake2s', 'lyra2z'],
            zpool: ['poly', 'hsr', 'keccak', 'xevan', 'skunk', 'tribus', 'c11', 'x11evo', 'lbry', 'phi', 'skein', 'equihash', 'groestl', 'timetravel', 'sib', 'bitcore', 'x17', 'blakecoin', 'Nist5', 'MyriadGroestl', 'Lyra2RE2', 'neoscrypt', 'blake2s', 'lyra2z']
        },
        inputs: {
            walletadress: {
                name: 'Wallet Address:',
                value: 'D6VmxuuEDDxY2uSkMLUVS4GGXTEP8Xwnxu',
                help: 'Make sure that this is a valid address and use the matching coin symbol below!',
                message: ''
            },
            workerlogin: {
                name: 'Worker Login:',
                value: 'workerlogin',
                help: 'Only required for MiningPoolHub (You need to register there first)',
                message: ''
            },
            gpunum: {
                name: 'GPU\'s:',
                value: '1',
                help: 'Number of GPU\'s you want to use (Nvidia only for now)',
                message: ''
            }
        },
        advinputs: {
            mphapikey: {
                name: 'Your API Key',
                value: 'exampleapikey',
                help: 'Go to MiningPoolHubStats.com for details',
                message: ''
            },
            currency: {
                name: 'Preferred Currency for displaying Profits/Day:',
                value: 'USD',
                help: '(GBP, USD, AUD, EUR)',
                message: ''
            },
            workername: {
                name: 'Worker Name:',
                value: 'workername',
                help: 'Can be whatever you like',
                message: ''
            },
            location: {
                name: 'Location:',
                value: 'US',
                help: 'Closest location to you (i.e. Europe, Asia, US)',
                message: ''
            },
            donate: {
                name: 'Donate X minutes per Day:',
                value: '5',
                help: 'Number of minutes you want to donate per day ( 5min = 0,03$ if you have a 10$/day profit )',
                message: ''
            },
            gaimpact: {
                name: 'Switch Algorithm on X% change:',
                value: '3',
                help: 'Switches to a more profitable algorithm once the difference is >= X%',
                message: ''
            }
        },
        prerunobj: {
            prerunalgo: {
                name: 'Algo name:',
                value: 'default'
            },
            baseclock: {
                name: 'Base Clock:',
                value: '0,0,75'
            },
            memoryclock: {
                name: 'Memory Clock:',
                value: '0,0,505'
            },
            voltageoffset: {
                name: 'Voltage Offset:',
                value: '0,0,0'
            },
            powertarget: {
                name: 'Power Target:',
                value: '0,75'
            },
            temptarget: {
                name: 'Temp Target:',
                value: '0,0,90'
            }
        }
    },
    methods: {
        switchAndStartMiner(data) {
            this.startM = !this.startM
            this.executeCommand(data)
        },

        executeCommand(data) {
            var spawn = require('child_process').spawn,
                ls = spawn('cmd.exe', ['/c', data], {
                    env: process.env,
                    detached: true
                })
        },

        downloadFile(name, type) {
            let a = document.getElementById('downloadClass')
            let file = new Blob([this.Algos], {
                type: type
            })
            a.href = URL.createObjectURL(file)
            a.download = name
        },

        errorInInput(inp) {
            if (inp.value === '') {
                inp.message = 'Cannot be empty'
                return true
            }
            if (inp.name == this.inputs.gpunum.name ||
                inp.name == this.advinputs.donate.name ||
                inp.name == this.advinputs.gaimpact.name
            ) {
                if (isNaN(inp.value)) {
                    inp.message = 'Has to be a number!'
                    return true
                }
            }
            if (inp.name == this.advinputs.currency.name ||
                inp.name == this.advinputs.location.name) {
                if (!isNaN(inp.value)) {
                    inp.message = 'Has to be a text!'
                    return true
                }
            }
            return false
        },

        saveConfig() {
            fs.writeFileSync('cfg/' + this.saveName.toLowerCase() + 'inp.txt', JSON.stringify(this.inputs, null, 2), 'utf8', function(err) {
                if (err) {
                    throw err
                }
            })
            fs.writeFileSync('cfg/' + this.saveName.toLowerCase() + 'adv.txt', JSON.stringify(this.advinputs, null, 2), 'utf8', function(err) {
                if (err) {
                    throw err
                }
            })
            fs.writeFileSync('cfg/' + this.saveName.toLowerCase() + 'algo.txt', JSON.stringify(this.checkedAlgos, null, 2), 'utf8', function(err) {
                if (err) {
                    throw err
                }
            })
            fs.writeFileSync('cfg/' + this.saveName.toLowerCase() + 'pool.txt', JSON.stringify(this.poolname, null, 2), 'utf8', function(err) {
                if (err) {
                    throw err
                }
            })
            fs.writeFileSync('cfg/' + this.saveName.toLowerCase() + 'coin.txt', JSON.stringify(this.coinsymbol, null, 2), 'utf8', function(err) {
                if (err) {
                    throw err
                }
            })
        },

        loadConfig() {
            fs.readFile('cfg/' + this.saveName.toLowerCase() + 'inp.txt', 'utf8', (err, inpdata) => {
                if (err) throw err
                this.inputs = JSON.parse(inpdata)
            })
            fs.readFile('cfg/' + this.saveName.toLowerCase() + 'adv.txt', 'utf8', (err, advdata) => {
                if (err) throw err
                this.advinputs = JSON.parse(advdata)
            })
            fs.readFile('cfg/' + this.saveName.toLowerCase() + 'algo.txt', 'utf8', (err, algodata) => {
                if (err) throw err
                this.checkedAlgos = JSON.parse(algodata)
            })
            fs.readFile('cfg/' + this.saveName.toLowerCase() + 'pool.txt', 'utf8', (err, pooldata) => {
                if (err) throw err
                this.poolname = JSON.parse(pooldata)
            })
            fs.readFile('cfg/' + this.saveName.toLowerCase() + 'coin.txt', 'utf8', (err, coindata) => {
                if (err) throw err
                this.coinsymbol = JSON.parse(coindata)
            })
        },

        createPrerunFile() {
            var prerunFilename = 'nvidiaInspector.exe -setBaseClockOffset:' + this.prerunobj.baseclock.value + ' -setMemoryClockOffset:' + this.prerunobj.memoryclock.value + ' -setVoltageOffset:' + this.prerunobj.voltageoffset.value + ' -setPowerTarget:' + this.prerunobj.powertarget.value + ' -setTempTarget:' + this.prerunobj.temptarget.value

            fs.writeFileSync('scripts/prerun/' + this.prerunobj.prerunalgo.value.toLowerCase() + '.bat', prerunFilename, 'utf8', function(err) {
                if (err) {
                    throw err
                }
            })
        },

        clearCheckedAlgos() {
            this.checkedAlgos = []
        },

        preAlgo(data) {
            if (data == 'all pools (switch automatically)') {
                data = 'allpools'
                return data
            }
            this.poolname = data
            return data
        },

        outputPoolUrl(e, f) {
            const {
                shell
            } = require('electron')
            if (f) {
                shell.openExternal(this.poolwalletwebsites[e] + this.inputs.walletadress.value)
            } else if (!f) {
                shell.openExternal(this.poolwebsites[e])
            }
        }
    },

    computed: {

        gpuNumbers() {
            let gpulist = {
                gpuc: '',
                gpus: ''
            }
            let i = 0
            for (i = 0; i < this.inputs.gpunum.value.length; i++) {
                gpulist.gpuc += i + ','
                gpulist.gpus += i + ' '
            }
            gpulist.gpuc = gpulist.gpuc.substring(0, gpulist.gpuc.length - 1)
            gpulist.gpus = gpulist.gpus.substring(0, gpulist.gpus.length - 1)
            return gpulist
        },

        Algos() {
            this.algolist = this.checkedAlgos.join()

            if (this.poolname.toLowerCase() == 'zpool') {
                this.advinputs.location.value = 'US'
            }

            if (this.poolname.toLowerCase() == 'blazepool') {
                this.inputs.walletcoin.value = 'BTC'
                this.inputs.walletadress.value = '3DYWArrdPYoEUzmfdxWGYh1cvdaozZm95q'
            }

            /* Removed Donating
            if (this.advinputs.donate.value <= 5) {
                this.advinputs.donate.value = 5
            }
            */

            if (this.poolname.toLowerCase() == 'all pools (switch automatically)') {
                this.poolname = 'ahashpool,hashrefinery,minemoney,miningpoolhub,nicehash,zergpool,zpool'
            }

            let location = __dirname.substring(0, __dirname.length - 9)

            this.command = [
                'powershell -version 5.0 -noexit -executionpolicy bypass -windowstyle maximized -command',
                location + '\\MasGUI-v1.1.0.ps1',
                '-SelGPUDSTM "' + this.gpuNumbers.gpus + '"',
                '-SelGPUCC "' + this.gpuNumbers.gpuc + '"',
                '-Currency ' + this.inputs.currency.value,
                '-Passwordcurrency ' + this.coinsymbol,
                '-Interval 30',
                '-Wallet ' + this.inputs.walletadress.value,
                '-Location ' + this.advinputs.location.value,
                '-ActiveMinerGainPct ' + this.advinputs.gaimpact.value,
                '-PoolName ' + this.poolname.toLowerCase(),
                '-WorkerName ' + this.inputs.workername.value,
                '-Type nvidia',
                '-Algorithm ' + this.algolist,
                '-Donate ' + this.advinputs.donate.value,
                '-MPHApiKey ' + this.advinputs.mphapikey.value
            ]

            this.command = this.command.join(' ')

            return this.command
        },

        showButton() {
            if (this.inputs.gpunum.value > 0 && this.poolname != '' && this.checkedAlgos != '' && this.startM && this.coinsymbol != '') {
                return true
            }
        }

    }
})
