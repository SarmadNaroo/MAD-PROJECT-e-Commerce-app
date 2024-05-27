import React, { useState } from 'react';
import { addProduct } from '../api/services';

function AddProduct() {
  const [product, setProduct] = useState({
    title: '',
    price: '',
    description: '',
    category: '',
    image: '',
    rating: { rate: '', count: '' }
  });

  const [feedback, setFeedback] = useState({ message: '', type: '' });
  const [showSnackbar, setShowSnackbar] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const addedProduct = await addProduct(product);
      console.log('Product added successfully:', addedProduct);
      setFeedback({ message: 'Product added successfully!', type: 'success' });
      setShowSnackbar(true);
      setTimeout(() => {
        setShowSnackbar(false);
      }, 3000); // Message will disappear after 3 seconds
      // Optionally reset the form
      setProduct({
        title: '',
        price: '',
        description: '',
        category: '',
        image: '',
        rating: { rate: '', count: '' }
      });
    } catch (error) {
      console.error('Failed to add product:', error);
      setFeedback({ message: 'Failed to add product. Please try again.', type: 'error' });
      setShowSnackbar(true);
      setTimeout(() => {
        setShowSnackbar(false);
      }, 3000); // Message will disappear after 3 seconds
    }
  };


  return (
    <div className="max-w-4xl mx-auto p-5 bg-gray-100 rounded-lg shadow-xl mt-6">
      <h2 className="text-2xl font-bold text-center mb-6 text-gray-600">Add New Product</h2>
      {showSnackbar && (
        <div className={`fixed bottom-5 right-5 md:bottom-10 md:right-10 p-4 rounded-lg shadow-lg text-white ${feedback.type === 'success' ? 'bg-green-500' : 'bg-red-500'}`}>
          {feedback.message}
        </div>
      )}
      <form onSubmit={handleSubmit} className="space-y-6">
        <input
          type="text"
          value={product.title}
          onChange={(e) => setProduct({ ...product, title: e.target.value })}
          placeholder="Title"
          className="block w-full p-3 rounded bg-white text-gray-900 placeholder-gray-400 border border-gray-200 focus:border-gray-300 focus:ring focus:ring-gray-300 focus:ring-opacity-50"
        />
        <input
          type="number"
          value={product.price}
          onChange={(e) => setProduct({ ...product, price: e.target.value })}
          placeholder="Price"
          className="block w-full p-3 rounded bg-white text-gray-900 placeholder-gray-400 border border-gray-200 focus:border-gray-300 focus:ring focus:ring-gray-300 focus:ring-opacity-50"
        />
        <textarea
          value={product.description}
          onChange={(e) => setProduct({ ...product, description: e.target.value })}
          placeholder="Description"
          className="block w-full p-3 rounded bg-white text-gray-900 placeholder-gray-400 border border-gray-200 focus:border-gray-300 focus:ring focus:ring-gray-300 focus:ring-opacity-50"
        />
        <select
          value={product.category}
          onChange={(e) => setProduct({ ...product, category: e.target.value })}
          className="block w-full p-3 rounded bg-white text-gray-900 placeholder-gray-400 border border-gray-200 focus:border-gray-300 focus:ring focus:ring-gray-300 focus:ring-opacity-50"
        >
          <option value="">Select Category</option>
          <option value="electronics">Electronics</option>
          <option value="jewelery">Jewelery</option>
          <option value="men's clothing">Men's Clothing</option>
          <option value="women's clothing">Women's Clothing</option>
        </select>
        <input
          type="text"
          value={product.image}
          onChange={(e) => setProduct({ ...product, image: e.target.value })}
          placeholder="Image URL"
          className="block w-full p-3 rounded bg-white text-gray-900 placeholder-gray-400 border border-gray-200 focus:border-gray-300 focus:ring focus:ring-gray-300 focus:ring-opacity-50"
        />
        <div className="grid grid-cols-2 gap-4">
          <input
            type="number"
            value={product.rating.rate}
            onChange={(e) => setProduct({ ...product, rating: { ...product.rating, rate: e.target.value } })}
            placeholder="Rating"
            className="w-full p-3 rounded bg-white text-gray-900 placeholder-gray-400 border border-gray-200 focus:border-gray-300 focus:ring focus:ring-gray-300 focus:ring-opacity-50"
          />
          <input
            type="number"
            value={product.rating.count}
            onChange={(e) => setProduct({ ...product, rating: { ...product.rating, count: e.target.value } })}
            placeholder="Rating Count"
            className="w-full p-3 rounded bg-white text-gray-900 placeholder-gray-400 border border-gray-200 focus:border-gray-300 focus:ring focus:ring-gray-300 focus:ring-opacity-50"
          />
        </div>
        <button
          type="submit"
          className="w-full bg-gray-300 hover:bg-gray-400 text-gray-900 font-bold py-3 px-4 rounded shadow hover:shadow-lg transition duration-300"
        >
          Add Product
        </button>
      </form>
    </div>
  );
}

export default AddProduct;
