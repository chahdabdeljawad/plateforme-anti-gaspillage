const {
  addProduct,
  myProducts,
  allProducts,
  update,
  remove
} = require('../services/productService');

// ➕ ADD PRODUCT
const create = async (req, res) => {

  try {

    const data = {

      ...req.body,

      image: req.file
          ? req.file.filename
          : null,
    };

    console.log("REQ.USER =", req.user);

    console.log("REQ.BODY =", req.body);

    console.log("REQ.FILE =", req.file);

    const product = await addProduct(
      data,
      req.file,
      req.user
    );

    res.status(201).json({

      success: true,
      product,
    });

  } catch (err) {

    console.log(err);

    res.status(400).json({

      success: false,
      message: err.message,
    });
  }
};

// 🔄 UPDATE PRODUCT
const updateOne = async (
  req,
  res
) => {

  try {

    console.log(
      "UPDATE CONTROLLER WORKING"
    );

    console.log(
      "PARAMS ID =",
      req.params.id
    );

    console.log(
      "REQ.USER =",
      req.user
    );

    console.log(
      "REQ.BODY =",
      req.body
    );

    const product = await update(
      req.params.id,
      req.body,
      req.user
    );

    console.log(
      "UPDATED PRODUCT =",
      product
    );

    res.json({

      success: true,
      product
    });

  } catch (err) {

    console.log(err);

    res.status(400).json({

      success: false,
      message: err.message
    });
  }
};

// 🗑 DELETE PRODUCT
const deleteOne = async (
  req,
  res
) => {

  try {

    console.log(
      "DELETE CONTROLLER WORKING"
    );

    console.log(
      "PARAMS ID =",
      req.params.id
    );

    console.log(
      "REQ.USER =",
      req.user
    );

    const product = await remove(
      req.params.id,
      req.user
    );

    console.log(
      "DELETED PRODUCT =",
      product
    );

    res.json({

      success: true,
      product
    });

  } catch (err) {

    console.log(err);

    res.status(400).json({

      success: false,
      message: err.message
    });
  }
};

// 📦 MY PRODUCTS
const getMine = async (
  req,
  res
) => {

  try {

    const products =
        await myProducts(req.user);

    res.json({

      success: true,
      products
    });

  } catch (err) {

    console.log(err);

    res.status(403).json({

      success: false,
      message: err.message
    });
  }
};

// 🌍 ALL PRODUCTS
const getAll = async (
  req,
  res
) => {

  try {

    const products =
        await allProducts();

    res.json({

      success: true,
      products
    });

  } catch (err) {

    console.log(err);

    res.status(500).json({

      success: false,
      message: err.message
    });
  }
};

module.exports = {

  create,
  getMine,
  getAll,
  updateOne,
  deleteOne
};