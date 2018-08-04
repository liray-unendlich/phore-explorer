
const mongoose = require('mongoose');

/**
 * Budget
 *
 * Connected masternode to the network.
 */
const Budget = mongoose.model('Budget', new mongoose.Schema({
  __v: { select: false, type: Number },
  name: { index: true, required: true, type: String },
  url: { index: true, required: true, type: String },
  hash: { index: true, required: true, type: String },
  sheight: { required: true, type: Number },
  eheight: { required: true, type: Number },
  addr: { index: true, required: true, type: String },
  yea: { type: Number },
  nay: { type: Number },
  tpay: { index: true, required: true, type: Number },
  mpay: { index: true, required: true, type: Number }
}, { versionKey: false }), 'budget');

module.exports =  Budget;
