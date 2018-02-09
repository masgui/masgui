const vueapp = new Vue({
  el: '#vueapp',
  data: {
    startM: true,
    gpulist: '',
    command: '',
    poolname: '',
    checkedAlgos: [],
    alglolist: '',
    poolnames: [
      "AHashpool",
      "Blazepool",
      "Hashrefinery",
      "Minemoney",
      "Miningpoolhub",
      "Nicehash",
      "Zergpool",
      "Zpool"
    ],
    pools: {
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
      walletcoin: {
        name: "Wallet Coin Symbol:",
        value: "DGB",
        help: "Using a BTC Wallet Address is recommended, but it can be set to any coin that the Pool supports (Blazepool ONLY supports BTC).",
        message: ""
      },
      workerlogin: {
        name: "Worker Login:",
        value: "doctororbit",
        help: "Only required for MiningPoolHub.",
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

      let location = __dirname.substring(0, __dirname.length - 9)

      this.command = [
        "powershell -version 5.0 -noexit -executionpolicy bypass -windowstyle maximized -command",
        location + "\\MasGUI-v1.0.1.ps1",
        "-SelGPUDSTM \'" + this.gpuNumbers.gpus + "'",
        "-SelGPUCC \'" + this.gpuNumbers.gpuc + "'",
        "-Currency " + this.inputs.currency.value,
        "-Passwordcurrency " + this.inputs.walletcoin.value,
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
      if (this.inputs.gpunum.value > 0 && this.poolname != '' && this.checkedAlgos != '' && this.startM) {
        return true
      }
    }

  }
})
