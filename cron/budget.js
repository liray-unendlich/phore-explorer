require('babel-polyfill');
require('../lib/cron');
const config = require('../config');
const { exit, rpc } = require('../lib/cron');
const fetch = require('../lib/fetch');
const { forEach } = require('p-iteration');
const locker = require('../lib/locker');
const moment = require('moment');
// Models
const Budget = require('../model/budget');


/**
* proposal function
* get proposal lists.
*/
async function syncPR() {

  await Budget.remove({});
 // Set timeout for budget data get.
  rpc.timeout(1000); //1 sec

  const prs = await rpc.call('getbudgetinfo');
  const inserts = [];

  await forEach(prs, async (pr) => {
    const budget = new Budget({
      name: pr.Name,
      url: pr.URL,
      hash: pr.Hash,
      feehash: pr.FeeHash,
      address: pr.PaymentAddress,
      total_amount: pr.TotalPayment,
      monthly_amount: pr.MonthlyPayment,
      total_count: pr.TotalPaymentCount,
      remained_count: pr.RemainingPaymentCount,
      start_height: pr.BlockStart,
      end_height: pr.BlockEnd,
      yays: pr.Yeas,
      nays: pr.Nays,
      ratio: pr.Ratio
    });

    inserts.push(budget);
    console.log(`Name: ${ budget.name } added.`)
  });

  if (inserts.length) {
    await Budget.insertMany(inserts);
  }
}

/**
 * Handle locking.
 */
async function update() {
  const type = 'budget';
  let code = 0;

  try {
    locker.lock(type);
    await syncPR();
  } catch(err) {
    console.log(err);
    code = 1;
  } finally {
    try {
      locker.unlock(type);
    } catch(err) {
      console.log(err);
      code = 1;
    }
    exit(code);
  }
}

update();
