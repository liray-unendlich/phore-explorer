
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
  feehash: {index: true, required: true, type: String },
  address: { index: true, required: true, type: String },
  total_amount: { index: true, required: true, type: Number },
  monthly_amount: { index: true, required: true, type: Number },
  total_count: { index: true, required: true, type: Number },
  remained_count: { required: true, type: Number },
  start_height: { index: true, required: true, type: Number },
  end_height: { index: true, required: true, type: Number },
  yays: { type: Number },
  nays: { type: Number },
  ratio: { type: Number }
}, { versionKey: false }), 'budget');

module.exports =  Budget;
