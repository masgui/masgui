const vueapp = new Vue({
  el: '#vueapp',
  data: {
    startM: true,
    gpulist: '',
    command: '',
    checkedAlgos: [],
    alglolist: '',
    coinsymbols: [
      "ABY", "ACP", "ALQO", "ARG", "ARTX", "AUR", "BELA", "BERN", "BLAS", "BOLI", "BSD", "BTB", "BTC", "BTCZ", "BTQ", "BTX", "CANN", "CDN", "CESC", "CHAN", "COPPER", "CPN", "CRC", "CRW", "DASH", "DFS", "DGB", "DGC", "DNR", "DOGE", "DSR", "EDC", "EDDIE", "EFL", "ELM", "EQT", "EVO", "FLO", "FTC", "GAME", "GBX", "GEERT", "GRS", "GUN", "HBC", "HOLD", "HPC", "HSR", "HUSH", "INN", "IRL", "KASH", "KMD", "KRONE", "LBC", "LBTC", "LEA", "LTC", "LTCU", "LUX", "MAC", "MAR", "MARS", "MATRX", "MAX", "MAY", "MBL", "MEC", "MONA", "MONK", "MUE", "MZC", "NEVA", "NKC", "NLG", "NOTE", "NVC", "NYC", "ONEX", "ONX", "ORB", "PAK", "PBS", "PCOIN", "PHILS", "PINK", "PIZZA", "PLC", "PLYS", "PPC", "PTC", "PURA", "Q2C", "QTL", "RAP", "RUP", "SAND", "SIB", "SKR", "SMC", "SONG", "SPK", "START", "SXC", "TAJ", "THC", "TIT", "TRC", "TZC", "UIS", "UNB", "UNIC", "VSX", "VTC", "WDC", "XCT", "XMCC", "XMG", "XMY", "XRE", "XSH", "XVG", "ZCL", "ZSE", "ZYD"
    ],
    coinsymbol: "",
    poolwebsites: {
      allpools: "",
      ahashpool: "https://www.ahashpool.com/",
      blazepool: "http://blazepool.com/",
      hashrefinery: "http://pool.hashrefinery.com/",
      minemoney: "https://www.minemoney.co/",
      miningpoolhub: "https://miningpoolhub.com/",
      nicehash: "https://www.nicehash.com/",
      zergpool: "http://zergpool.com/",
      zpool: "http://www.zpool.ca/"
    },
    poolwalletwebsites: {
      allpools: "",
      ahashpool: "https://www.ahashpool.com/wallet.php?wallet=",
      blazepool: "http://blazepool.com/wallet.html?btc=",
      hashrefinery: "http://pool.hashrefinery.com/?address=",
      minemoney: "https://www.minemoney.co/?address=",
      miningpoolhub: "https://miningpoolhub.com/",
      nicehash: "https://www.nicehash.com/miner/",
      zergpool: "http://zergpool.com/?address=",
      zpool: "http://www.zpool.ca/?address="
    },
    poolnames: [
      "AHashpool",
      "Blazepool",
      "Hashrefinery",
      "Minemoney",
      "Miningpoolhub",
      "Nicehash",
      "Zergpool",
      "Zpool",
      "All Pools (switch automatically)"
    ],
    poolname: '',
    pools: {
      allpools: ["bitcore", "blake2s", "blakecoin", "c11", "cryptonight", "equihash", "ethash", "groestl", "hsr", "keccak", "lbry", "Lyra2RE2", "lyra2z", "MyriadGroestl", "neoscrypt", "Nist5", "phi", "poly", "sib", "skein", "skunk", "timetravel", "tribus", "x11evo", "x11gost", "x17", "xevan", "yescrypt"],
      ahashpool: ["xevan", "hsr", "phi", "tribus", "c11", "lbry", "skein", "sib", "bitcore", "x17", "Nist5", "MyriadGroestl", "Lyra2RE2", "neoscrypt", "blake2s", "skunk"],
      blazepool: ["xevan", "hsr", "phi", "tribus", "c11", "skein", "groestl", "sib", "bitcore", "x17", "Nist5", "Lyra2RE2", "neoscrypt", "blake2s", "yescrypt", "blakecoin", "keccak"],
      hashrefinery: ["skunk", "xevan", "tribus", "skein", "bitcore", "x17", "Nist5", "Lyra2RE2", "neoscrypt"],
      minemoney: ["poly", "hsr", "keccak", "xevan", "skunk", "tribus", "c11", "x11evo", "lbry", "phi", "skein", "groestl", "timetravel", "sib", "bitcore", "x17", "blakecoin", "Nist5", "MyriadGroestl", "Lyra2RE2", "neoscrypt", "blake2s"],
      miningpoolhub: ["ethash", "cryptonight", "keccak", "lyra2z", "skein", "equihash", "groestl", "MyriadGroestl", "Lyra2RE2", "neoscrypt"],
      nicehash: ["ethash", "x11gost", "cryptonight", "keccak", "skunk", "lbry", "equihash", "Nist5", "Lyra2RE2", "neoscrypt", "blake2s"],
      zergpool: ["hsr", "xevan", "skunk", "tribus", "phi", "c11", "skein", "groestl", "sib", "bitcore", "x17", "Nist5", "MyriadGroestl", "Lyra2RE2", "neoscrypt", "blake2s", "lyra2z"],
      zpool: ["poly", "hsr", "keccak", "xevan", "skunk", "tribus", "c11", "x11evo", "lbry", "phi", "skein", "equihash", "groestl", "timetravel", "sib", "bitcore", "x17", "blakecoin", "Nist5", "MyriadGroestl", "Lyra2RE2", "neoscrypt", "blake2s", "lyra2z"]
    },
    inputs: {
      walletadress: {
        name: "Wallet Address:",
        value: "D6VmxuuEDDxY2uSkMLUVS4GGXTEP8Xwnxu",
        help: "Make sure that this is a valid address and use the matching coin symbol below!",
        message: ""
      },
      workerlogin: {
        name: "Worker Login:",
        value: "doctororbit",
        help: "Only required for MiningPoolHub (You need to register there first).",
        message: ""
      },
      workername: {
        name: "Worker Name:",
        value: "doctororbit",
        help: "Can be whatever you like.",
        message: ""
      },
      password: {
        name: "Password:",
        value: "x",
        help: "'x' is fine, but you can change it if you prefer.",
        message: ""
      },
      gpunum: {
        name: "GPU\'s:",
        value: "1",
        help: "Number of GPU's that should run on this Software (Nvidia only for now).",
        message: ""
      },
      gaimpact: {
        name: "Switch Algorithm on X% change:",
        value: "3",
        help: "Switches to a more profitable algorithm once the difference is >= X%",
        message: ""
      },
      donate: {
        name: "Donate X minutes per Day:",
        value: "5",
        help: "Number of minutes you want to donate per day (0 is not possible in Trial version)",
        message: ""
      },
      currency: {
        name: "Preferred Currency for displaying Profits/Day:",
        value: "USD",
        help: "(GBP, USD, AUD, EUR)",
        message: ""
      },
      location: {
        name: "Location:",
        value: "US",
        help: "Europe, Asia, US",
        message: ""
      }
    }
  },
  methods: {
    switchAndStartMiner(data){
      this.startM = !this.startM
      this.executeCommand(data)
    },
    executeCommand(data) {
      var spawn = require('child_process').spawn,
        ls = spawn('cmd.exe', ["/c", data], {
          env: process.env,
          detached: true
        })

        console.log(data);


      ls.stdout.on('data', function(data) {
        console.log('stdout: ' + data)
      })

      ls.stderr.on('data', function(data) {
        console.log('stderr: ' + data)
      })

      ls.on('exit', function(code) {
        console.log('child process exited with code ' + code)
      })
    },
    downloadFile(name, type) {
      let a = document.getElementById("downloadClass")
      let file = new Blob([this.Algos], {
        type: type
      })
      a.href = URL.createObjectURL(file)
      a.download = name
    },
    missingName(inp) {
      if (inp.value === '') {
        inp.message = "Cannot be empty"
        return true
      } else if (inp.name == this.inputs.gpunum.name || inp.name == this.inputs.donate.name || inp.name == this.inputs.gaimpact.name) {
        //if (!inp.value.match(/\d+/g)) {
        if (isNaN(inp.value)) {
          inp.message = "Has to be a number!"
          return true
        }
      } else if (inp.name == this.inputs.currency.name || inp.name == this.inputs.location.name) {
        //if (inp.value.match(/\d+/g)) {
        if (!isNaN(inp.value)) {
          inp.message = "Has to be a text!"
          return true
        }
      }
    },
    clearCheckedAlgos() {
      this.checkedAlgos = []
    },
    preAlgo(data) {
      if (data == "all pools (switch automatically)") {
        data = "allpools"
        console.log(data)
        return data
      }
      this.poolname = data
      return data
    },
    outputPoolUrl(e, f) {
      const {shell} = require('electron')
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
        this.inputs.location.value = 'US'
      }

      if (this.poolname.toLowerCase() == 'blazepool') {
        this.inputs.walletcoin.value = "BTC"
        this.inputs.walletadress.value = "3DYWArrdPYoEUzmfdxWGYh1cvdaozZm95q"
      }

      if (this.inputs.donate.value <= 5) {
        this.inputs.donate.value = 5
      }

      if (this.poolname.toLowerCase() == "all pools (switch automatically)") {
        this.poolname = "ahashpool,hashrefinery,minemoney,miningpoolhub,nicehash,zergpool,zpool"
      }

      let location = __dirname.substring(0, __dirname.length - 9)

      this.command = [
        "powershell -version 5.0 -noexit -executionpolicy bypass -windowstyle maximized -command",
        location + "\\MasGUI-v1.1.0.ps1",
        "-SelGPUDSTM \'" + this.gpuNumbers.gpus + "'",
        "-SelGPUCC \'" + this.gpuNumbers.gpuc + "'",
        "-Currency " + this.inputs.currency.value,
        "-Passwordcurrency " + this.coinsymbol,
        "-Interval 30",
        "-Wallet " + this.inputs.walletadress.value,
        "-Location " + this.inputs.location.value,
        "-ActiveMinerGainPct " + this.inputs.gaimpact.value,
        "-PoolName " + this.poolname.toLowerCase(),
        "-WorkerName " + this.inputs.workername.value,
        "-Type nvidia",
        "-Algorithm " + this.algolist,
        "-Donate " + this.inputs.donate.value
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
