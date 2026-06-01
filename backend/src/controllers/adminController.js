const db = require('../config/db'); 
const { Parser } = require('json2csv');

exports.adminLogin = async (req, res) => {
  const { email, password } = req.body;

  try {
    const result = await db.query(
      "SELECT * FROM admins WHERE email = $1 AND password = $2",
      [email, password]
    );

    if (result.rows.length > 0) {
      res.json({
        success: true,
        admin: result.rows[0]
      });
    } else {
      res.json({
        success: false,
        message: "Invalid admin credentials"
      });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};

// ================= GET PENDING STORES =================
exports.getPendingStores =
async (req, res) => {

  try {

    const result = await db.query(
      `
      SELECT *
      FROM stores
      WHERE is_validated = false
      ORDER BY id DESC
      `
    );

    res.json({
      success: true,
      stores: result.rows
    });

  } catch (err) {

    console.error(err);

    res.status(500).json({
      success: false,
      message: err.message
    });
  }
};



// ================= VALIDATE STORE =================
exports.validateStore =
async (req, res) => {

  try {

    const { id } = req.params;

    await db.query(
      `
      UPDATE stores
      SET is_validated = true
      WHERE id = $1
      `,
      [id]
    );

    res.json({
      success: true,
      message:
        "Store validated successfully"
    });

  } catch (err) {

    console.error(err);

    res.status(500).json({
      success: false,
      message: err.message
    });
  }
  
};

// ================= DELETE STORE =================
exports.deleteStore =
async (req, res) => {

  try {

    const { id } = req.params;

    await db.query(
      `
      DELETE FROM stores
      WHERE id = $1
      `,
      [id]
    );

    res.json({
      success: true,
      message: "Store deleted successfully"
    });

  } catch (err) {

    console.error(err);

    res.status(500).json({
      success: false,
      message: err.message
    });
  }
};

// ================= DELETE PRODUCT =================

exports.deleteProduct =
async (req, res) => {

  try {

    const { id } = req.params;

    await db.query(

      `
      DELETE FROM products
      WHERE id = $1
      `,
      [id]
    );

    res.json({

      success: true,

      message:
        "Product deleted successfully"
    });

  } catch (err) {

    console.error(err);

    res.status(500).json({

      success: false,

      message: err.message
    });
  }
};


// ================= DELETE CLIENT =================

exports.deleteClient =
async (req, res) => {

  try {

    const { id } = req.params;

    await db.query(

      `
      DELETE FROM clients
      WHERE id = $1
      `,
      [id]
    );

    res.json({

      success: true,

      message:
        "Client deleted successfully"
    });

  } catch (err) {

    console.error(err);

    res.status(500).json({

      success: false,

      message: err.message
    });
  }
};

// ================= DELETE RESERVATION =================

exports.deleteReservation =
async (req, res) => {

  try {

    const { id } = req.params;

    await db.query(

      `
      DELETE FROM reservations
      WHERE id = $1
      `,
      [id]
    );

    res.json({

      success: true,

      message:
        "Reservation deleted successfully"
    });

  } catch (err) {

    console.error(err);

    res.status(500).json({

      success: false,

      message: err.message
    });
  }
};

// ================= EXPORT CLIENTS CSV =================

exports.exportClientsCSV =
async (req, res) => {

  try {

    const result = await db.query(
      `
      SELECT *
      FROM clients
      ORDER BY id DESC
      `
    );

    const clients =
        result.rows;

    const json2csv =
        new Parser();

    const csv =
        json2csv.parse(clients);

    res.header(
      'Content-Type',
      'text/csv',
    );

    res.attachment(
      'clients.csv',
    );

    return res.send(csv);

  } catch (err) {

    console.error(err);

    res.status(500).json({

      success: false,

      message: err.message
    });
  }
};

// ================= EXPORT STORES CSV =================
exports.exportStoresCSV =
async (req, res) => {

  try {

    const result = await db.query(
      `
      SELECT *
      FROM stores
      ORDER BY id DESC
      `
    );

    const stores =
        result.rows;

    const json2csv =
        new Parser();

    const csv =
        json2csv.parse(stores);

    res.header(
      'Content-Type',
      'text/csv',
    );

    res.attachment(
      'stores.csv',
    );

    return res.send(csv);

  } catch (err) {

    console.error(err);

    res.status(500).json({

      success: false,

      message: err.message
    });
  }
};

// ================= EXPORT PRODUCTS CSV =================
exports.exportProductsCSV =
async (req, res) => {

  try {

    const result = await db.query(
      `
      SELECT *
      FROM products
      ORDER BY id DESC
      `
    );

    const products =
        result.rows;

    const json2csv =
        new Parser();

    const csv =
        json2csv.parse(products);

    res.header(
      'Content-Type',
      'text/csv',
    );

    res.attachment(
      'products.csv',
    );

    return res.send(csv);

  } catch (err) {

    console.error(err);

    res.status(500).json({

      success: false,

      message: err.message
    });
  }
};

// ================= EXPORT RESERVATIONS CSV =================
exports.exportReservationsCSV =
async (req, res) => {

  try {

    const result = await db.query(
      `
      SELECT *
      FROM reservations
      ORDER BY id DESC
      `
    );

    const reservations =
        result.rows;

    const json2csv =
        new Parser();

    const csv =
        json2csv.parse(
          reservations
        );

    res.header(
      'Content-Type',
      'text/csv',
    );

    res.attachment(
      'reservations.csv',
    );

    return res.send(csv);

  } catch (err) {

    console.error(err);

    res.status(500).json({

      success: false,

      message: err.message
    });
  }
};

// ================= GET REPORTS =================

exports.getReports = async (req, res) => {

  try {

    const result = await db.query(`

      SELECT
        reports.id,
        reports.reason,
        reviews.comment,
        reviews.client_name,
        reviews.store_name

      FROM reports

      JOIN reviews
      ON reports.review_id = reviews.id

      ORDER BY reports.id DESC

    `);

    res.json(result.rows);

  } catch (err) {

    console.error(err);

    res.status(500).json({

      success: false,

      message: err.message
    });
  }
};

// ================= DELETE REPORT =================

exports.deleteReport = async (req, res) => {

  try {

    const { id } = req.params;

    await db.query(`
      DELETE FROM reports
      WHERE id = $1
    `, [id]);

    res.json({
      success: true,
      message: "Report deleted"
    });

  } catch (err) {

    console.error(err);

    res.status(500).json({
      success: false,
      message: err.message
    });
  }
};

// ================= GET REVIEWS =================

exports.getReviews = async (req, res) => {

  try {

    const result = await db.query(`
      SELECT *
      FROM reviews
      ORDER BY id DESC
    `);

    res.json(result.rows);

  } catch (err) {

    console.error(err);

    res.status(500).json({
      success: false,
      message: err.message
    });
  }
};

// ================= DELETE REVIEW =================

exports.deleteReview = async (req, res) => {

  try {

    const { id } = req.params;

    await db.query(

      `
      DELETE FROM reviews
      WHERE id = $1
      `,
      [id]

    );

    res.json({

      success: true,

      message: "Review deleted successfully"
    });

  } catch (err) {

    console.error(err);

    res.status(500).json({

      success: false,

      message: err.message
    });
  }
};

// ================= GET STATISTICS =================
exports.getStatistics = async (req, res) => {

  try {

    const clients =
      await db.query(
        `SELECT COUNT(*) FROM clients`
      );

    const stores =
      await db.query(
        `SELECT COUNT(*) FROM stores`
      );

    const products =
      await db.query(
        `SELECT COUNT(*) FROM products`
      );

    const reservations =
      await db.query(
        `SELECT COUNT(*) FROM reservations`
      );

    const reviews =
      await db.query(
        `SELECT COUNT(*) FROM reviews`
      );

    const reports =
      await db.query(
        `SELECT COUNT(*) FROM reports`
      );

    res.json({

      clients:
        clients.rows[0].count,

      stores:
        stores.rows[0].count,

      products:
        products.rows[0].count,

      reservations:
        reservations.rows[0].count,

      reviews:
        reviews.rows[0].count,

      reports:
        reports.rows[0].count,
    });

  } catch (err) {

    console.error(err);

    res.status(500).json({

      success: false,

      message: err.message
    });
  }
};
