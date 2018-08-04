
import chai from 'chai';
import RPC from '../../lib/rpc';

const expect = chai.expect;
const rpc = new RPC();
const should = chai.should();

describe('RPC', () => {
  it('getinfo', (done) => {
    rpc.call('getinfo')
      .then((res) => {
        res.version.should.be.a('number');
        res.protocolversion.should.be.a('number');
        res.walletversion.should.be.a('number');
        res.blocks.should.be.a('number');
        res.difficulty.should.be.a('number');
        done();
      });
  });

  it('getnetworkhashps', (done) => {
    rpc.call('getnetworkhashps')
      .then((res) => {
        res.should.be.a('number');
        done();
      });
  });

  it('getblockhash', (done) => {
    rpc.call('getblockhash', [36007])
      .then((res) => {
        res.should.be.a('string');
        res.should.eq('6eb979d2faaec7bfa12098bf749272b409f6f675cdac262ddb820ec1103f25a8');
        done();
      });
  });

  it('getblock', (done) => {
    rpc.call('getblock', ['6eb979d2faaec7bfa12098bf749272b409f6f675cdac262ddb820ec1103f25a8'])
      .then((res) => {
        res.hash.should.be.a('string');
        res.confirmations.should.be.a('number');
        res.version.should.be.a('number');
        res.merkleroot.should.be.a('string');
        res.tx.should.be.a('array');
        res.time.should.be.a('number');
        res.nonce.should.be.a('number');
        res.bits.should.be.a('string');
        res.difficulty.should.be.a('number');
        res.chainwork.should.be.a('string');
        done();
      });
  });

  it('getrawtransaction', (done) => {
    rpc.call('getrawtransaction', ['ee49c6452efae775a614723139347978b76cfc0ece566004e1d9585fe4397dc9'])
      .then((res) => {
        res.should.be.a('string');
        res.should.eq('0100000001ed8fed189fdad3f99b609db740ac6de465f9c8be2eb1dcaa2414c4901e437a9d0100000049483045022100cbcdf63db0550ebd098c66b2f20e2aff67e534c9fd02420893a31fa8e34eba28022018a9f0fda43aeb20a05a693b33dab52e631bc0ee701e64e471e51d807b34f93f01ffffffff03000000000000000000cc9b6f7813000000232103d9168fa26fafd03a8ee236880fc4a1bf5953830846f30a74f29eb71786a7a34dac00b10819000000001976a914e949d390393ab4cc2252f4132082d729cd0a2a4e88ac00000000');
        done();
      });
  });

  it('getpeerinfo', (done) => {
    rpc.call('getpeerinfo')
      .then((res) => {
        res.should.be.a('array');
        done();
      });
  });

  it('getmasternodecount', (done) => {
    rpc.call('getmasternodecount')
      .then((res) => {
        res.should.be.a('object');
        res.total.should.be.a('number');
        res.stable.should.be.a('number');
        res.enabled.should.be.a('number');
        res.ipv4.should.be.a('number');
        res.ipv6.should.be.a('number');
        res.onion.should.be.a('number');
        done();
      });
  });

  it('masternode list', (done) => {
    rpc.call('masternode', ['list'])
      .then((res) => {
        res.should.be.a('array');
        done();
      });
  });
});
