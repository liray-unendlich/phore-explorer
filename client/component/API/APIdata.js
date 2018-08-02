const APIdata = [
  {
    heading: 'API Calls',
    subHeading: 'Return data from coind',
    calls: [
        {
          name: 'getAddress [hash]',
          info: 'Returns information for given address.',
          path: '/api/address/PRgtiCnHnxcNVfRbGttX9EfNJpuZcTodY7'
        },
        {
          name: 'getBlock [hash] [height]',
          info: 'Returns block information for the given hash or height.',
          path: '/api/block/6ed5fa55804256b300ae98776226005c310e098f80f16aa0bca27c538a7c6159'
        },
        {
          name: 'getBlockAverage',
          info: 'Returns the average block time over 24 hours.',
          path: '/api/block/average'
        },
        {
          name: 'getCoin',
          info: 'Returns coin information.',
          path: '/api/coin/'
        },
        {
          name: 'getCoinHistory',
          info: 'Returns the coin history.',
          path: '/api/coin/history'
        },
        {
          name: 'getMasternodes',
          info: 'Returns masternode information.',
          path: '/api/masternode'
        },
        {
          name: 'getMasternodeByAddress',
          info: 'Returns masternode information by Wallet Address.',
          path: '/api/masternode/PWjrqSZFvuhW6YhjEcTYEwC77Yvb1fZh6B'
        },
        {
          name: 'getMasternodeCount',
          info: 'Returns masternodes enabled and total counts.',
          path: '/api/masternodecount'
        },
        {
          name: 'getMasternodeAverage',
          info: 'Returns the average payment for a masternode vs 24 hours.',
          path: '/api/masternode/average'
        },
        {
          name: 'getPeer',
          info: 'Returns peer information.',
          path: '/api/peer'
        },
        {
          name: 'getSupply',
          info: 'Returns circulating and total supply information.<br />https://github.com/coincheckup/crypto-supplies',
          path: '/api/supply'
        },
        {
          name: 'getTop100',
          info: 'Returns top 100',
          path: '/api/top100'
        },
        {
          name: 'getTXs',
          info: 'Returns transaction information.',
          path: '/api/tx'
        },
        {
          name: 'getTXLatest',
          info: 'Returns latest transaction information.',
          path: '/api/tx/latest'
        },
        {
          name: 'getTX [hash]',
          info: 'Returns information for the given transaction.',
          path: '/api/tx/8222d3ff3267550fad216e3b603f89170aa7e60162b6a45fadf25cf08640f25f'
        },
        {
          name: 'getDifficulty',
          info: 'Returns the current difficulty.',
          path: '/api/getdifficulty'
        },
        {
          name: 'getConnectionCount',
          info: 'Returns the number of connections the block explorer has to other nodes.',
          path: '/api/getconnectioncount'
        },
        {
          name: 'getBlockCount',
          info: 'Returns the current block index.',
          path: '/api/getblockcount'
        },
        {
          name: 'getNetworkHashPS',
          info: 'Returns the current network hashrate. (hash/s)',
          path: '/api/getnetworkhashps'
        },
    ]
  },
  {
    heading: 'Extended API',
    subHeading: 'Return data from local indexes',
    calls: [
        {
          name: 'getMoneySupply',
          info: 'Returns the current money supply.',
          path: '/ext/getmoneysupply'
        },
        // { name: 'getdistribution',
        //   info: 'Returns the number of connections the block explorer has to other nodes.',
        //   path: '/ext/getdistribution'
        // },
        {
          name: 'getAddress',
          info: 'Returns address information.',
          path: '/ext/getaddress'
        },
        {
          name: 'getBalance',
          info: 'Returns the current balance.',
          path: '/ext/getbalance'
        },
        {
          name: 'getLastTXs',
          info: 'Returns the last transactions.',
          path: '/ext/getlasttxs'
        }
    ]
  },
  {
    heading: 'Linking (GET)',
    subHeading: 'Linking to the block explorer',
    calls: [
        {
          name: 'Transaction (/#/tx/[hash])',
          info: 'Returns transaction information',
          path: '/#/tx/8222d3ff3267550fad216e3b603f89170aa7e60162b6a45fadf25cf08640f25f'
        },
        {
          name: 'Block (/#/block/[hash|height]',
          info: 'Returns block information.',
          path: '/#/block/6ed5fa55804256b300ae98776226005c310e098f80f16aa0bca27c538a7c6159'
        },
        {
          name: 'Address (/#/address/[hash]',
          info: 'Returns address information.',
          path: '/#/block/6ed5fa55804256b300ae98776226005c310e098f80f16aa0bca27c538a7c6159'
        },
        // { name: 'qr (qr/[hash]',
        //   info: 'Returns qr code information.',
        //   path: '/#/qr/6ed5fa55804256b300ae98776226005c310e098f80f16aa0bca27c538a7c6159'
        // },
    ]
  }
]

export default APIdata;
