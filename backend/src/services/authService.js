const bcrypt = require('bcrypt');
const { createUser, findUserByEmail } = require('../models/userModel');
const { generateToken } = require('../config/jwt');

const registerUser = async ({ name, email, password, role }) => {
  const existing = await findUserByEmail(email);
  if (existing) throw new Error('Email already exists');

  const hashedPassword = await bcrypt.hash(password, 10);

  const user = await createUser(name, email, hashedPassword, role);

  const token = generateToken(user);

  return { user, token };
};

const loginUser = async ({ email, password }) => {
  const user = await findUserByEmail(email);
  if (!user) throw new Error('User not found');

  const valid = await bcrypt.compare(password, user.password);
  if (!valid) throw new Error('Invalid password');

  const token = generateToken(user);

  return { user, token };
};

module.exports = { registerUser, loginUser };