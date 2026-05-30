const jwt = require('jsonwebtoken');

const protect = (req, res, next) => {

  const authHeader =
      req.headers.authorization;

  if (!authHeader) {

    return res.status(401).json({
      message: 'No token provided'
    });
  }

  try {

    const token =
        authHeader.split(' ')[1];

    const decoded = jwt.verify(
      token,
      process.env.JWT_SECRET
    );

    console.log(
      "DECODED USER:",
      decoded
    );

    // ✅ IMPORTANT FIX
req.user = {
  userId: decoded.id,
  role: decoded.role,
};


   console.log(
      "FINAL REQ.USER =",
      req.user
    );

    next();

  } catch (err) {

    console.log(err);

    return res.status(401).json({
      message: 'Invalid token'
    });
  }
};

module.exports = { protect };