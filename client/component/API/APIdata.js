const APIdata = [
  {
    heading: 'API 一覧',
    subHeading: 'phored からデータを取得します。',
    calls: [
        {
          name: 'getAddress [hash]',
          info: '指定アドレスの情報を返します。',
          path: '/api/address/PRgtiCnHnxcNVfRbGttX9EfNJpuZcTodY7'
        },
        {
          name: 'getBlock [hash] [height]',
          info: '与えられたハッシュ/数のブロックの情報を返します。',
          path: '/api/block/6ed5fa55804256b300ae98776226005c310e098f80f16aa0bca27c538a7c6159'
        },
        {
          name: 'getBlockAverage',
          info: '24時間の平均ブロック数を返します。',
          path: '/api/block/average'
        },
        {
          name: 'getCoin',
          info: 'コインの情報を返します。',
          path: '/api/coin/'
        },
        {
          name: 'getCoinHistory',
          info: 'コインのこれまでの情報を返します。',
          path: '/api/coin/history'
        },
        {
          name: 'getMasternodes',
          info: 'マスターノード一覧を返します。',
          path: '/api/masternode'
        },
        {
          name: 'getMasternodeByAddress',
          info: '指定アドレスのマスターノードの情報を返します。',
          path: '/api/masternode/PWjrqSZFvuhW6YhjEcTYEwC77Yvb1fZh6B'
        },
        {
          name: 'getMasternodeCount',
          info: '稼働中のマスターノード数および総数を返します。',
          path: '/api/masternodecount'
        },
        {
          name: 'getMasternodeAverage',
          info: '平均のマスターノードの報酬時間を返します。',
          path: '/api/masternode/average'
        },
        {
          name: 'getProposalLists',
          info: 'プロポーザルのリストを返します。',
          path: '/api/proposal'
        },
        {
          name: 'getProposalByName',
          info: '指定プロポーザルの情報を返します。',
          path: '/api/proposal/PhoreCoreTeam'
        },
        {
          name: 'getPeer',
          info: '接続情報を返します。',
          path: '/api/peer'
        },
        {
          name: 'getSupply',
          info: '通貨の流通枚数・総数を返します。',
          path: '/api/supply'
        },
        {
          name: 'getTop100',
          info: '保持数上位100のリストを返します。',
          path: '/api/top100'
        },
        {
          name: 'getTXs',
          info: 'トランザクション情報を返します。',
          path: '/api/tx'
        },
        {
          name: 'getTXLatest',
          info: '最新のトランザクションの情報を返します。',
          path: '/api/tx/latest'
        },
        {
          name: 'getTX [hash]',
          info: '指定TXハッシュの情報を返します。',
          path: '/api/tx/8222d3ff3267550fad216e3b603f89170aa7e60162b6a45fadf25cf08640f25f'
        },
        {
          name: 'getDifficulty',
          info: '現在のDifficultyを返します。',
          path: '/api/getdifficulty'
        },
        {
          name: 'getConnectionCount',
          info: 'ブロックエクスプローラと他のノードとの接続数を返します。',
          path: '/api/getconnectioncount'
        },
        {
          name: 'getBlockCount',
          info: '現在のブロック数を返します。',
          path: '/api/getblockcount'
        },
        {
          name: 'getNetworkHashPS',
          info: '現在のネットワークハッシュレートを返します。 (hash/s)',
          path: '/api/getnetworkhashps'
        },
    ]
  },
  {
    heading: '拡張 API',
    subHeading: 'データベースからデータを取得します。',
    calls: [
        {
          name: 'getMoneySupply',
          info: '現在の発行枚数を返します。',
          path: '/ext/getmoneysupply'
        },
        // { name: 'getdistribution',
        //   info: 'Returns the number of connections the block explorer has to other nodes.',
        //   path: '/ext/getdistribution'
        // },
        {
          name: 'getAddress',
          info: 'アドレスの状態を返します。',
          path: '/ext/getaddress'
        },
        {
          name: 'getBalance',
          info: '現在のバランスを返します。',
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
